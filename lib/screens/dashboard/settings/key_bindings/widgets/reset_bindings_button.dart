import 'package:flutter/material.dart';
import 'package:splash/splash.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../constants/locale_keys.g.dart';
import '../../../../../extensions/context_extension.dart';
import '../../../../../extensions/string_extension.dart';

/// Tüm tuş atamalarını varsayılana (QWER) döndüren buton.
class ResetBindingsButton extends StatelessWidget {
  const ResetBindingsButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  /// Köşeleri çapraz kırılmış Dota tarzı çerçeve. Hem [Material]'in şekli hem
  /// de [InkWell]'in dalga sınırı olarak kullanıldığı için tek yerde tanımlı.
  ShapeBorder get _shape => BeveledRectangleBorder(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
          topRight: Radius.circular(4),
          bottomLeft: Radius.circular(4),
        ),
        side: BorderSide(color: AppColors.white.withValues(alpha: 0.6)),
      );

  @override
  Widget build(BuildContext context) {
    final shape = _shape;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          splashFactory: WaveSplash.splashFactory,
          customBorder: shape,
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restart_alt_rounded,
                  color: AppColors.white,
                  size: context.sp(18),
                ),
                const SizedBox(width: 8),
                Text(
                  LocaleKeys.keyBindings_reset.locale,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
