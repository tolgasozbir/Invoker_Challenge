import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../enums/local_storage_keys.dart';
import '../extensions/color_extension.dart';
import '../services/app_services.dart';

class ColorSettingsProvider extends ChangeNotifier {
  late Color _healthColor;
  late Color _healthColorBg;
  late Color _roundColor;
  late Color _roundColorBg;
  late Color _timeColor;
  late Color _timeColorBg;

  ColorSettingsProvider() {
    _loadAllColors();
  }

  // --- Renk Yükleme --- \\
  void _loadAllColors() {
    final cache = AppServices.instance.localStorageService;
    final defaultColorValue = AppColors.circleColor.toARGB32();

    // Sağlık Dairesi Rengi
    final healthColorValue = cache.getValue<int>(LocalStorageKey.outerColor) ?? defaultColorValue;
    _healthColor = Color(healthColorValue);
    _healthColorBg = _healthColor.darkerColor();

    // Tur Dairesi Rengi
    final roundColorValue = cache.getValue<int>(LocalStorageKey.middleColor) ?? defaultColorValue;
    _roundColor = Color(roundColorValue);
    _roundColorBg = _roundColor.darkerColor();

    // Zaman Dairesi Rengi
    final timeColorValue = cache.getValue<int>(LocalStorageKey.innerColor) ?? defaultColorValue;
    _timeColor = Color(timeColorValue);
    _timeColorBg = _timeColor.darkerColor();
  }

  // --- Public Getters (Erişimciler) ---

  // Sağlık Dairesi Renkleri
  Color get healthProgressColor => _healthColor;
  Color get healthBackgroundColor => _healthColorBg;

  // Tur Dairesi Renkleri
  Color get roundProgressColor => _roundColor;
  Color get roundBackgroundColor => _roundColorBg;

  // Zaman Dairesi Renkleri
  Color get timeProgressColor => _timeColor;
  Color get timeBackgroundColor => _timeColorBg;


  // --- Renk Güncelleme Metotları ---

  void updateColors({required Color healthColor, required Color roundColor, required Color timeColor}) {
    _updateHealthColor(healthColor);
    _updateRoundColor(roundColor);
    _updateTimeColor(timeColor);
    notifyListeners();
  }

  void _updateHealthColor(Color newColor) async {
    if (_healthColor == newColor) return;
    _healthColor = newColor;
    _healthColorBg = newColor.darkerColor();
  }

  void _updateRoundColor(Color newColor) async {
    if (_roundColor == newColor) return;
    _roundColor = newColor;
    _roundColorBg = newColor.darkerColor();
  }

  void _updateTimeColor(Color newColor) async {
    if (_timeColor == newColor) return;
    _timeColor = newColor;
    _timeColorBg = newColor.darkerColor();
  }
}
