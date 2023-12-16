import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/boss_battle_provider.dart';
import 'weather/weather.dart';

class BackgroundWeather extends StatelessWidget {
  const BackgroundWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<BossBattleProvider, int>(
      selector: (_, provider) => provider.roundProgress,
      builder: (_, value, __) => Weather(weatherType: value >= 10 ? WeatherType.rainy : WeatherType.normal),
    );
  }
}
