// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class MosaicGridWidget extends StatefulWidget {
  final List<FFUploadedFile> images;
  final double width;
  final double height;

  const MosaicGridWidget({
    Key? key,
    this.images = const [],
    this.width = 393,
    this.height = 852,
  }) : super(key: key);

  @override
  State<MosaicGridWidget> createState() => _MosaicGridWidgetState();
}

class _MosaicGridWidgetState extends State<MosaicGridWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[200],
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Tire fotos para criar o mosaico'),
          ),
        ),
      );
    }

    final isVerticalDominant = _isVerticalDominant(widget.images);

    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: widget.images.map((img) {
            final size = isVerticalDominant ? 
              Size(widget.width / 2 - 6, (widget.width / 2 - 6) * 1.5) :
              Size(widget.width / 3 - 8, (widget.width / 3 - 8) * 0.8);
              
            return Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: MemoryImage(img.bytes!),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  bool _isVerticalDominant(List<FFUploadedFile> images) {
    int verticalCount = 0;
    int horizontalCount = 0;

    for (var image in images) {
      if (image.dimensions != null) {
        if (image.dimensions!.height > image.dimensions!.width) {
          verticalCount++;
        } else {
          horizontalCount++;
        }
      }
    }

    return verticalCount > horizontalCount;
  }
} 