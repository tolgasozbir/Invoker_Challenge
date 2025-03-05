import 'package:flutter/material.dart';

class AssetManager {
  static final Map<String, ImageProvider> _imageCache = {};
  static Map<String, ImageProvider> get imageCache => _imageCache;
  //static const int _maxCacheSize = 20; // Max 20 ikon tutulsun

  static ImageProvider getIcon(String path) {
    //return _imageCache.putIfAbsent(path, () => AssetImage(path));
    if (!_imageCache.containsKey(path)) {
      // if (_imageCache.length >= _maxCacheSize) {
      //   _imageCache.remove(imageCache.keys.first); // En eski ikonu sil
      // }
      _imageCache[path] = AssetImage(path);
    }
    return _imageCache[path]!;
  }

  // /// **Belirli bir görseli önbellekten temizle**
  // static void removeImage(String path) {
  //   _imageCache.remove(path);
  // }

  // /// **Tüm görsel önbelleğini temizle**
  // static void clearImageCache() {
  //   _imageCache.clear();
  // }
}
