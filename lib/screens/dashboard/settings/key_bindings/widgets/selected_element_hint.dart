import 'package:dota2_invoker_game/widgets/empty_box.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../constants/locale_keys.g.dart';
import '../../../../../extensions/context_extension.dart';
import '../../../../../extensions/string_extension.dart';

/// "Yeni tuşa bas" ipucu satırı. Baştaki nokta seçili elementin rengini alır.
class SelectedElementHint extends StatelessWidget {
  const SelectedElementHint({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: Durations.short4,
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const EmptyBox.w8(),
        Flexible(
          child: Text(
            LocaleKeys.keyBindings_assignHint.locale,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: context.sp(11.5),
              color: AppColors.white.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}
