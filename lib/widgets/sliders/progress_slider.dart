import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class ProgressSlider extends StatelessWidget {
  const ProgressSlider({super.key, required this.current, required this.max, this.activeColor, this.inactiveColor, this.trackHeight});

  final double current;
  final double max;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? trackHeight;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: SliderComponentShape.noThumb,
        overlayShape: SliderComponentShape.noThumb,
        activeTrackColor: activeColor ?? AppColors.green,
        inactiveTrackColor: inactiveColor ?? AppColors.white,
        trackHeight: trackHeight,
      ),
      child: Slider(
        value: current,
        max: max,
        min: 0,
        onChanged: (value) => null,
      ),
    );
  }
}
