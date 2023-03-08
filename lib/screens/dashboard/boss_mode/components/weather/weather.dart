import 'package:dota2_invoker/screens/dashboard/boss_mode/components/weather/rain/rain.dart';
import 'package:dota2_invoker/screens/dashboard/boss_mode/components/weather/snow/snow.dart';
import 'package:dota2_invoker/screens/dashboard/boss_mode/components/weather/wind/wind.dart';
import 'package:flutter/material.dart';

class Weather extends StatefulWidget {
  final String weatherMode;

  @override
  State<StatefulWidget> createState() => WeatherState();

  const Weather({required this.weatherMode});
}

class WeatherState extends State<Weather> with TickerProviderStateMixin {
  Widget? weather;

  @override
  void initState() {
    super.initState();
    _updateWeather();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Weather oldWidget) {
    super.didUpdateWidget(oldWidget);

    _updateWeather();
  }

  @override
  void dispose() {
    _updateWeather();
    super.dispose();
  }

  _updateWeather() {}

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (widget.weatherMode == 'rainy' || widget.weatherMode == 'thunderstorm') {
        this.weather = Rain( width: constraints.maxWidth, height: constraints.maxHeight);
      } 
      else if (widget.weatherMode == 'snowy') {
        this.weather = Snow(width: constraints.maxWidth, height: constraints.maxHeight);
      } 
      else if (widget.weatherMode == 'windy') {
        this.weather = Wind(width: constraints.maxWidth, height: constraints.maxHeight);
      } 
      else {
        this.weather = Container();
      }
      return ClipRect(child: this.weather);
    });
  }
}
