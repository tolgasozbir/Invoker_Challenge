import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_colors.dart';

class UserStatus extends StatelessWidget {
  UserStatus({super.key});

  final boxDecoration = BoxDecoration(
    color: AppColors.buttonSurfaceColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(width: 2),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          margin: const EdgeInsets.all(8),
          decoration: boxDecoration,
          child: const Icon(
            FontAwesomeIcons.userSecret, 
            shadows: [
              Shadow(
                blurRadius: 32,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Guest'),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: SliderComponentShape.noThumb,
                overlayShape: SliderComponentShape.noThumb,
                activeTrackColor: AppColors.expBarColor,
                inactiveTrackColor: AppColors.expBarColor.withOpacity(0.5),
              ),
              child: Slider(
                value: 32,
                max: 150,
                min: 10,
                onChanged: (double value) {},
              ),
            ).wrapPadding(const EdgeInsets.symmetric(vertical: 8)),
            Row(
              children: const [
                Text('Level 1'),
                Spacer(),
                Text('25/100')
              ],
            )
          ],
        ).wrapPadding(const EdgeInsets.only(top: 8)).wrapExpanded(),
      ],
    );
  }
}
