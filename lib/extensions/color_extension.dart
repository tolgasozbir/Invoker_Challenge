import 'package:dota2_invoker_game/extensions/number_extension.dart';
import 'package:flutter/material.dart';

extension ColorExtension on Color {
  // /// Returns a new color with the provided components updated.
  // /// Each component (alpha, red, green, blue) represents a floating-point value; see 
  // /// [Color.from](https://api.flutter.dev/flutter/dart-ui/Color/Color.from.html) for details and examples.
  // Color withValues({double? alpha, double? red, double? green, double? blue}) {
  //   final r = red == null ? this.r : (255 * red).round();
  //   final g = green == null ? this.g : (255 * green).round();
  //   final b = blue == null ? this.b : (255 * blue).round();
  //   return Color.fromRGBO(r, g, b, alpha ?? opacity);
  // }

  /// Returns a darker version of the color by the given [factor] (default: 0.6).
  /// Pure black (almost) won't be darkened further; instead, it’s slightly lightened.
  Color darkerColor({double factor = 0.54}) {
    final clampedFactor = factor.clamp(0.0, 1.0);

    final rByte = r.toColorByte();
    final gByte = g.toColorByte();
    final bByte = b.toColorByte();

    // Avoid over-darkening near-black colors (threshold 20)
    if (rByte < 20 && gByte < 20 && bByte < 20) {
      return Color.fromARGB(
        255,
        (rByte * 1.1).clamp(0, 255).toInt(),
        (gByte * 1.1).clamp(0, 255).toInt(),
        (bByte * 1.1).clamp(0, 255).toInt(),
      );
    }

    return Color.fromARGB(
      255,
      (rByte * clampedFactor).clamp(0, 255).toInt(),
      (gByte * clampedFactor).clamp(0, 255).toInt(),
      (bByte * clampedFactor).clamp(0, 255).toInt(),
    );
  }
}
