import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../constants/locale_keys.g.dart';
import '../../enums/local_storage_keys.dart';
import '../../services/app_services.dart';
import '../../services/sound_manager.dart';

class VolumeSlider extends StatelessWidget {
  const VolumeSlider({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      min: 0,
      max: 100,
      initialValue: SoundManager.instance.getVolume,
      onChangeEnd: (value) async {
        SoundManager.instance.setVolume(value);
        await AppServices.instance.localStorageService.setValue<int>(
          LocalStorageKey.volume, 
          value.ceil(),
        );
      },
      appearance: CircularSliderAppearance(
        size: size,
        animDurationMultiplier: 1.6,
        infoProperties: InfoProperties(
          mainLabelStyle: TextStyle(
            //color: Color(0xFFDCBEFB),
            fontSize: size / 5.0,
            fontWeight: FontWeight.w300,
          ),
          bottomLabelText: LocaleKeys.settings_volume.locale,
          bottomLabelStyle: TextStyle(
            //color: Color(0xFFDCBEFB),
            fontSize: size / 10.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
