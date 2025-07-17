import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;

class PdfService {
  static Future<String> generatePdf(
    List<File> images, {
    bool isDarkMode = false,
    double imageQuality = 1.0,
    String? watermark,
    bool addTimestamp = true,
    PdfPageFormat pageFormat = PdfPageFormat.a4,
  }) async {
    final pdf = pw.Document();
    final imageWidth = 393.0;
    final imageHeight = 852.0;

    // Configurar tema do PDF
    final theme = isDarkMode
        ? pw.ThemeData.darkRounded
        : pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
          );

    // Preparar marca d'água se fornecida
    pw.Widget? watermarkWidget;
    if (watermark != null) {
      watermarkWidget = pw.Center(
        child: pw.Opacity(
          opacity: 0.2,
          child: pw.Transform.rotate(
            angle: -0.5,
            child: pw.Text(
              watermark,
              style: pw.TextStyle(
                fontSize: 60,
                color: isDarkMode ? PdfColors.grey300 : PdfColors.grey700,
              ),
            ),
          ),
        ),
      );
    }

    for (var imageFile in images) {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image != null) {
        // Ajustar qualidade da imagem se necessário
        var processedImage = image;
        if (imageQuality < 1.0) {
          processedImage = img.copyResize(
            image,
            width: (image.width * imageQuality).round(),
            height: (image.height * imageQuality).round(),
          );
        }

        final pdfImage = pw.MemoryImage(img.encodeJpg(processedImage));

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat(imageWidth, imageHeight),
            theme: theme,
            build: (context) {
              return pw.Stack(
                children: [
                  pw.Center(
                    child: pw.Image(
                      pdfImage,
                      width: imageWidth,
                      height: imageHeight,
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                  if (watermarkWidget != null) watermarkWidget,
                  if (addTimestamp)
                    pw.Positioned(
                      bottom: 5,
                      right: 5,
                      child: pw.Text(
                        DateTime.now().toString(),
                        style: pw.TextStyle(
                          fontSize: 8,
                          color: isDarkMode ? PdfColors.grey300 : PdfColors.grey700,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      }
    }

    // Adicionar página de metadados
    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        theme: theme,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Informações do PDF'),
              ),
              pw.Paragraph(
                text: 'Data de criação: ${DateTime.now()}',
              ),
              pw.Paragraph(
                text: 'Número de imagens: ${images.length}',
              ),
              pw.Paragraph(
                text: 'Qualidade das imagens: ${(imageQuality * 100).round()}%',
              ),
              if (watermark != null)
                pw.Paragraph(
                  text: 'Marca d\'água: $watermark',
                ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final fileName = 'mosaic_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
} 