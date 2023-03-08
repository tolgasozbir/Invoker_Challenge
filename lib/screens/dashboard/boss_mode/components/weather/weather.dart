import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:dota2_invoker/screens/dashboard/boss_mode/components/weather/rain/rain.dart';
import 'package:flutter/material.dart';

enum WeatherType { empty, rainy, thunderstorm, }

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
        case WeatherType.empty:
          weather = const EmptyBox();
          break;
        case WeatherType.rainy:
        case WeatherType.thunderstorm:
          weather = Rain(
            width: constraints.maxWidth, 
            height: constraints.maxHeight
          );
          break;
      }
      return ClipRect(child: this.weather);
    });
  }
}
