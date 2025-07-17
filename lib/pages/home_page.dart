import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/image_model.dart';
import '../widgets/mosaic_grid.dart';
import '../services/pdf_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageModel>(
      builder: (context, imageModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Conversor de PDF Pro'),
            actions: [
              IconButton(
                icon: Icon(imageModel.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => imageModel.toggleDarkMode(),
                tooltip: 'Alternar tema',
              ),
              PopupMenuButton<MosaicLayout>(
                icon: const Icon(Icons.grid_view),
                tooltip: 'Mudar layout',
                onSelected: imageModel.setLayout,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: MosaicLayout.masonry,
                    child: Text('Mosaico'),
                  ),
                  const PopupMenuItem(
                    value: MosaicLayout.grid2x2,
                    child: Text('Grade 2x2'),
                  ),
                  const PopupMenuItem(
                    value: MosaicLayout.grid3x3,
                    child: Text('Grade 3x3'),
                  ),
                  const PopupMenuItem(
                    value: MosaicLayout.pinterest,
                    child: Text('Estilo Pinterest'),
                  ),
                  const PopupMenuItem(
                    value: MosaicLayout.dynamic,
                    child: Text('Dinâmico (Arraste)'),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: imageModel.images.isEmpty ? null : imageModel.clearImages,
                tooltip: 'Limpar tudo',
              ),
              IconButton(
                icon: const Icon(Icons.science),
                onPressed: () => imageModel.toggleTestMode(),
                tooltip: 'Modo teste',
              ),
            ],
          ),
          body: Column(
            children: [
              if (imageModel.images.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 64,
                          color: imageModel.isDarkMode ? Colors.white54 : Colors.black54,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Adicione imagens para criar o mosaico',
                          style: TextStyle(
                            color: imageModel.isDarkMode ? Colors.white54 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: MosaicGrid(
                    images: imageModel.images,
                    onRemove: imageModel.removeImage,
                    onReorder: imageModel.currentLayout == MosaicLayout.dynamic
                        ? imageModel.reorderImages
                        : null,
                    layout: imageModel.currentLayout,
                    isDarkMode: imageModel.isDarkMode,
                    onUndo: imageModel.canUndo ? imageModel.undoRemove : null,
                    canUndo: imageModel.canUndo,
                  ),
                ),
              _buildBottomBar(context, imageModel),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _pickImage(context),
            child: const Icon(Icons.add_photo_alternate),
            tooltip: 'Adicionar imagens',
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, ImageModel imageModel) {
    if (imageModel.images.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: imageModel.isDarkMode ? Colors.grey[900] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Qualidade:'),
              Expanded(
                child: Slider(
                  value: imageModel.imageQuality,
                  onChanged: imageModel.setImageQuality,
                  label: '${(imageModel.imageQuality * 100).round()}%',
                  divisions: 9,
                ),
              ),
              Text('${(imageModel.imageQuality * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview PDF'),
                  onPressed: () => _previewPdf(context, imageModel),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Gerar PDF'),
                  onPressed: () => _generatePdf(context, imageModel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      
      if (pickedFile != null && context.mounted) {
        context.read<ImageModel>().addImage(File(pickedFile.path));
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permissão necessária para acessar a galeria'),
          ),
        );
      }
    }
  }

  Future<void> _previewPdf(BuildContext context, ImageModel model) async {
    try {
      final pdfPath = await PdfService.generatePdf(
        model.images,
        isDarkMode: model.isDarkMode,
        imageQuality: model.imageQuality,
        watermark: 'PREVIEW',
        addTimestamp: true,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Preview gerado: $pdfPath'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar preview: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _generatePdf(BuildContext context, ImageModel model) async {
    try {
      final pdfPath = await PdfService.generatePdf(
        model.images,
        isDarkMode: model.isDarkMode,
        imageQuality: model.imageQuality,
        addTimestamp: true,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF gerado com sucesso: $pdfPath'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 