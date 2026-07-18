import 'package:flutter/material.dart';

/// Sanal klavyedeki tek bir tuşun tanımı.
class KeyboardKeySpec {
  /// Bir elemente atanabilen harf/rakam tuşu.
  const KeyboardKeySpec.character(String this.character)
      : icon = null,
        widthInUnits = 1;

  /// Sadece klavye görüntüsünü tamamlayan, tıklanamayan tuş (shift, enter...).
  const KeyboardKeySpec.decorative(IconData this.icon, this.widthInUnits)
      : character = null;

  /// Tuşun harfi; dekoratif tuşlarda null.
  final String? character;

  /// Dekoratif tuşun ikonu; harf tuşlarında null.
  final IconData? icon;

  /// Tuşun genişliği; 1 birim = standart harf tuşu genişliği.
  final double widthInUnits;

  bool get isBindable => character != null;
}

/// Sanal klavyenin ölçüleri ve tuş yerleşimi.
abstract final class KeyboardLayout {
  /// Tuşlar arası boşluk.
  static const double keyGap = 5.0;

  /// Tuş yüksekliğinin birim genişliğe oranı.
  static const double keyHeightRatio = 1.30;

  /// Klavye panelinin iç boşluğu.
  static const EdgeInsets padding = EdgeInsets.fromLTRB(10, 8, 10, 10);

  /// En geniş satırdaki birim sayısı; birim genişliği buna göre hesaplanır.
  static const int unitsPerRow = 10;

  static final List<List<KeyboardKeySpec>> rows = [
    [for (final c in '1234567890'.split('')) KeyboardKeySpec.character(c)],
    [for (final c in 'QWERTYUIOP'.split('')) KeyboardKeySpec.character(c)],
    [
      for (final c in 'ASDFGHJKL'.split('')) KeyboardKeySpec.character(c),
      const KeyboardKeySpec.decorative(Icons.keyboard_return_rounded, 1),
    ],
    [
      const KeyboardKeySpec.decorative(Icons.arrow_upward_rounded, 1.5),
      for (final c in 'ZXCVBNM'.split('')) KeyboardKeySpec.character(c),
      const KeyboardKeySpec.decorative(Icons.arrow_upward_rounded, 1.5),
    ],
  ];

  /// [availableWidth] (iç boşluk düşülmüş genişlik) için bir birimin genişliği.
  static double unitWidth(double availableWidth) =>
      (availableWidth - keyGap * (unitsPerRow - 1)) / unitsPerRow;

  /// [spec] tuşunun ekrandaki genişliği.
  static double keyWidth(KeyboardKeySpec spec, double unitWidth) =>
      unitWidth * spec.widthInUnits + keyGap * (spec.widthInUnits - 1);

  /// [character] tuşunun merkezinin, klavye panelinin dış koordinatlarındaki X
  /// değeri. Kablo uçlarını doğru tuşa bağlamak için kullanılır.
  /// [keyboardWidth] panelin iç boşluk dahil toplam genişliğidir.
  static double? centerXOfCharacter(String character, double keyboardWidth) {
    final unit = unitWidth(keyboardWidth - padding.horizontal);
    for (final row in rows) {
      var x = 0.0;
      for (final spec in row) {
        final width = keyWidth(spec, unit);
        if (spec.character == character) return padding.left + x + width / 2;
        x += width + keyGap;
      }
    }
    return null;
  }
}
