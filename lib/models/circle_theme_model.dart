import 'package:flutter/material.dart';

class ColorThemeModel {
  final String name;
  final Color outer;
  final Color middle;
  final Color inner;

  const ColorThemeModel({
    required this.name,
    required this.outer,
    required this.middle,
    required this.inner,
  });
}
