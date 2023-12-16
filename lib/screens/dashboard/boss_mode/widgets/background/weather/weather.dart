
import 'package:flutter/material.dart';

import '../../../../../../widgets/empty_box.dart';
import 'rain/rain.dart';

enum WeatherType { normal, rainy, }

class Weather extends StatefulWidget {
  const Weather({super.key, required this.weatherType});

  final WeatherType weatherType;

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  Widget weather = const EmptyBox();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      switch (widget.weatherType) {
        case WeatherType.normal:
          weather = const EmptyBox();
        case WeatherType.rainy:
          weather = Rain(
            width: constraints.maxWidth, 
            height: constraints.maxHeight,
          );
      }
      return ClipRect(child: this.weather);
    },);
  }
}
