import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../constants/app_strings.dart';
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
        await AppServices.instance.localStorageService.setIntValue(
          LocalStorageKey.volume, 
          value.ceil().toInt()
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
          bottomLabelText: AppStrings.volume,
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