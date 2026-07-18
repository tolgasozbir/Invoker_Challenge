import 'package:flutter/material.dart';

/// Element renklerinden oluşan ince gradient ayraç.
class ElementGradientDivider extends StatelessWidget {
  const ElementGradientDivider({required this.colors, super.key});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    // LinearGradient en az iki renk ister; tek renk gelirse kendisiyle tekrarlanır.
    final gradientColors = colors.length >= 2 ? colors : [...colors, ...colors];

    return Container(
      height: 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        gradient: LinearGradient(colors: gradientColors),
      ),
    );
  }
}
