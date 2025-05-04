import 'package:dota2_invoker_game/constants/locale_keys.g.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../enums/local_storage_keys.dart';
import '../../extensions/widget_extension.dart';
import '../../services/app_services.dart';
import '../app_snackbar.dart';

class QWERHudHeightSlider extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final bool fullWidth;

  const QWERHudHeightSlider({
    this.sliderHeight = 48,
    this.min = 0,
    this.max = 100,
    this.fullWidth = true,
  });

  @override
  State<QWERHudHeightSlider> createState() => _QWERHudHeightSliderState();
}

class _QWERHudHeightSliderState extends State<QWERHudHeightSlider> {
 double _value = 0;

  @override
  void initState() {
    _value = AppServices.instance.localStorageService.getValue<int>(LocalStorageKey.qwerHudHeight)?.toDouble() ?? 20;
    super.initState();
  }

  SliderThemeData get sliderTheme {
    return SliderTheme.of(context).copyWith(
      activeTrackColor: AppColors.white,
      inactiveTrackColor: AppColors.white.withValues(alpha: 0.5),
      overlayColor: AppColors.white.withValues(alpha: 0.4),
      trackHeight: 4.0,
      thumbShape: _CustomSliderThumbCircle(
        thumbRadius: widget.sliderHeight * 0.4,
        min: widget.min,
        max: widget.max,
        thumbColor: AppColors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double paddingFactor = 0.2;
    if (widget.fullWidth) paddingFactor = 0.3;

    return Row(
      children: [
        Container(
          width: widget.fullWidth ? double.infinity : widget.sliderHeight * 5.5,
          height: widget.sliderHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.sliderHeight * 0.2),
            border: Border.all(strokeAlign: BorderSide.strokeAlignOutside),
            gradient: const LinearGradient(colors: AppColors.qwerHudSliderGradient),
          ),
          child: Row(
            children: [
              valueText(widget.min.toString()),
              SliderTheme(
                data: sliderTheme,
                child: Slider(
                value: _value,
                min: widget.min.toDouble(),
                max: widget.max.toDouble(),
                onChanged: (value) => setState(() => _value = value),
                onChangeEnd: (value) async {
                  await AppServices.instance.localStorageService.setValue<int>(
                    LocalStorageKey.qwerHudHeight, 
                    value.truncate(),
                  );
                },
              ),).wrapCenter().wrapExpanded(),
              valueText(widget.max.toString()),
            ],
          ).wrapPadding(EdgeInsets.symmetric(horizontal: widget.sliderHeight * paddingFactor)),
        ).wrapExpanded(),
        infoQuestionMark(),
      ],
    );
  }

  IconButton infoQuestionMark() {
    return IconButton(
      padding: const EdgeInsets.only(left: 4),
      constraints: const BoxConstraints(),
      icon: const Icon(Icons.question_mark),
      onPressed: () {
        AppSnackBar.showSnackBarMessage(
          text: LocaleKeys.snackbarMessages_qwerHudInfoMessage1.locale, 
          snackBartype: SnackBarType.info,
          duration: const Duration(milliseconds: 3000),
        );
        AppSnackBar.showSnackBarMessage(
          text: LocaleKeys.snackbarMessages_qwerHudInfoMessage2.locale, 
          snackBartype: SnackBarType.info,
          duration: const Duration(milliseconds: 3000),
        );
      }, 
    );
  }

  Text valueText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: widget.sliderHeight * 0.3,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}

class _CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;
  final Color thumbColor;

  const _CustomSliderThumbCircle({
    required this.thumbRadius,
    required this.min,
    required this.max,
    required this.thumbColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.fromRadius(thumbRadius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
      required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow,
    }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill;

    final span = TextSpan(
      text: getValue(value),
      style: TextStyle(
        fontSize: thumbRadius * 0.8,
        fontWeight: FontWeight.w700,
        color: sliderTheme.thumbColor,
      ),
    );

    final tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    final textCenter = Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, thumbRadius * 0.9, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min+(max-min)*value).round().toString();
  }
}
