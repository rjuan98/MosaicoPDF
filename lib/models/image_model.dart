import 'dart:io';
import 'package:flutter/material.dart';

enum MosaicLayout {
  grid2x2,
  grid3x3,
  masonry,
  pinterest,
  dynamic
}

class ImageModel extends ChangeNotifier {
  List<File> _images = [];
  bool _isTestMode = true;
  MosaicLayout _currentLayout = MosaicLayout.masonry;
  bool _isDarkMode = false;
  List<File> _removedImages = [];
  double _imageQuality = 1.0;

  // Getters
  List<File> get images => _images;
  bool get isTestMode => _isTestMode;
  MosaicLayout get currentLayout => _currentLayout;
  bool get isDarkMode => _isDarkMode;
  bool get canUndo => _removedImages.isNotEmpty;
  double get imageQuality => _imageQuality;

  // Imagem methods
  void addImage(File image) {
    _images.add(image);
    notifyListeners();
  }

  void removeImage(int index) {
    if (index >= 0 && index < _images.length) {
      _removedImages.add(_images[index]);
      _images.removeAt(index);
      notifyListeners();
    }
  }

  void undoRemove() {
    if (_removedImages.isNotEmpty) {
      _images.add(_removedImages.removeLast());
      notifyListeners();
    }
  }

  void reorderImages(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final File item = _images.removeAt(oldIndex);
    _images.insert(newIndex, item);
    notifyListeners();
  }

  void clearImages() {
    _removedImages.addAll(_images);
    _images.clear();
    notifyListeners();
  }

  // Layout methods
  void setLayout(MosaicLayout layout) {
    _currentLayout = layout;
    notifyListeners();
  }

  // Theme methods
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Test mode
  void toggleTestMode() {
    _isTestMode = !_isTestMode;
    notifyListeners();
  }

  // Quality settings
  void setImageQuality(double quality) {
    _imageQuality = quality.clamp(0.1, 1.0);
    notifyListeners();
  }

  // Export settings
  Map<String, dynamic> getExportSettings() {
    return {
      'layout': _currentLayout.toString(),
      'isDarkMode': _isDarkMode,
      'imageQuality': _imageQuality,
      'imageCount': _images.length,
    };
  }
} 