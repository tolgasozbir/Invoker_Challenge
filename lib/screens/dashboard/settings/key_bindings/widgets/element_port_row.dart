import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:dota2_invoker_game/widgets/empty_box.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../enums/elements.dart';
import '../../../../../extensions/context_extension.dart';

/// Tuşu değiştirilebilen elementlerin üst sırası. Bir porta dokunmak o elementi
/// seçili hale getirir; sonraki tuş ataması bu elemente yapılır.
class ElementPortRow extends StatelessWidget {
  const ElementPortRow({
    required this.elements,
    required this.selectedElement,
    required this.onElementSelected,
    super.key,
  });

  final List<Elements> elements;
  final Elements selectedElement;
  final ValueChanged<Elements> onElementSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final element in elements)
          Expanded(
            child: _ElementPort(
              element: element,
              isSelected: element == selectedElement,
              onTap: () => onElementSelected(element),
            ),
          ),
      ],
    );
  }
}

/// Tek bir element: yuvarlak ikon, köşesinde atanmış tuşun rozeti ve adı.
class _ElementPort extends StatelessWidget {
  const _ElementPort({
    required this.element,
    required this.isSelected,
    required this.onTap,
  });

  final Elements element;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = element.getColor;
    final size = context.dynamicWidth(0.145);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            duration: Durations.short4,
            curve: Curves.easeOut,
            scale: isSelected ? 1.1 : 1.0,
            child: SizedBox(
              width: size,
              height: size,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _icon(size, color),
                  Positioned(right: -3, bottom: -3, child: _keyBadge(context, color)),
                ],
              ),
            ),
          ),
          const EmptyBox.h8(),
          _name(context),
        ],
      ),
    );
  }

  Widget _icon(double size, Color color) {
    return AnimatedContainer(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.08),
      duration: Durations.short4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: isSelected ? 0.26 : 0.16),
            Colors.black.withValues(alpha: 0.35),
          ],
          stops: const [0.35, 1.0],
        ),
        border: Border.all(
          color: color.withValues(alpha: isSelected ? 0.8 : 0.4),
          width: isSelected ? 2 : 1.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadiusGeometry.all(Radius.circular(50)),
        child: Image.asset(element.getImage, fit: BoxFit.contain),
      ),
    );
  }

  /// Elemente atanmış tuşu gösteren badge.
  Widget _keyBadge(BuildContext context, Color color) {
    return AnimatedContainer(
      duration: Durations.short4,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: isSelected ? 1 : 0.6),
        ),
      ),
      child: Text(
        element.getDisplayKey.toUpperCase(),
        style: TextStyle(
          fontSize: context.sp(10.5),
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  Widget _name(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: Durations.short4,
      style: TextStyle(
        fontSize: context.sp(11),
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: isSelected ? AppColors.white : AppColors.white.withValues(alpha: 0.5),
      ),
      child: Text(
        element.name.capitalize(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}
