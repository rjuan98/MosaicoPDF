import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_view/photo_view.dart';
import '../models/image_model.dart';

class MosaicGrid extends StatelessWidget {
  final List<File> images;
  final Function(int) onRemove;
  final Function(int, int)? onReorder;
  final MosaicLayout layout;
  final double width;
  final double height;
  final bool isDarkMode;
  final VoidCallback? onUndo;
  final bool canUndo;

  const MosaicGrid({
    Key? key,
    required this.images,
    required this.onRemove,
    this.onReorder,
    this.layout = MosaicLayout.masonry,
    this.width = 393,
    this.height = 852,
    this.isDarkMode = false,
    this.onUndo,
    this.canUndo = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      child: Stack(
        children: [
          _buildMosaicLayout(),
          if (canUndo)
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                mini: true,
                onPressed: onUndo,
                child: const Icon(Icons.undo),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMosaicLayout() {
    switch (layout) {
      case MosaicLayout.grid2x2:
        return _buildGridLayout(2);
      case MosaicLayout.grid3x3:
        return _buildGridLayout(3);
      case MosaicLayout.pinterest:
        return _buildPinterestLayout();
      case MosaicLayout.dynamic:
        return _buildDynamicLayout();
      case MosaicLayout.masonry:
      default:
        return _buildMasonryLayout();
    }
  }

  Widget _buildMasonryLayout() {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: images.length,
      itemBuilder: (context, index) => _buildImageTile(context, index),
    );
  }

  Widget _buildGridLayout(int crossAxisCount) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) => _buildImageTile(context, index),
    );
  }

  Widget _buildPinterestLayout() {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: images.length,
      itemBuilder: (context, index) {
        final aspectRatio = index % 2 == 0 ? 0.8 : 1.2;
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: _buildImageTile(context, index),
        );
      },
    );
  }

  Widget _buildDynamicLayout() {
    return ReorderableListView.builder(
      onReorder: onReorder ?? (_, __) {},
      itemCount: images.length,
      itemBuilder: (context, index) {
        return KeyedSubtree(
          key: ValueKey(images[index].path),
          child: _buildImageTile(context, index),
        );
      },
    );
  }

  Widget _buildImageTile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _showImagePreview(context, index),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'image_$index',
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.black26 : Colors.grey.shade300,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  images[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => onRemove(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Hero(
              tag: 'image_$index',
              child: PhotoView(
                imageProvider: FileImage(images[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                backgroundDecoration: BoxDecoration(
                  color: isDarkMode ? Colors.black87 : Colors.white70,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 