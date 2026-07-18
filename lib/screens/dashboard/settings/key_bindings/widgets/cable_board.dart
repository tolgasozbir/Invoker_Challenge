import 'package:flutter/material.dart';

import '../../../../../enums/elements.dart';
import '../../../../../extensions/context_extension.dart';
import 'cable_painter.dart';
import 'keyboard_layout.dart';

/// Element portları ile klavye arasındaki alan: arka planda seçili elementin
/// dev harfi, önünde her elementi kendi tuşuna bağlayan kablolar.
class CableBoard extends StatelessWidget {
  const CableBoard({
    required this.elements,
    required this.selectedElement,
    super.key,
  });

  final List<Elements> elements;
  final Elements selectedElement;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;
        // Portlar eşit genişlikte dağıldığı için kablo başlangıcı da öyle.
        final portSlotWidth = width / elements.length;

        return Stack(
          children: [
            Positioned.fill(child: _GhostLetter(element: selectedElement)),
            for (var i = 0; i < elements.length; i++)
              Positioned.fill(
                child: _Cable(
                  element: elements[i],
                  isEmphasized: elements[i] == selectedElement,
                  startX: portSlotWidth * (i + 0.5),
                  boardWidth: width,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Seçili elementin tuşunu, arka planda soluk gösterir.
class _GhostLetter extends StatelessWidget {
  const _GhostLetter({required this.element});

  final Elements element;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: AnimatedSwitcher(
              duration: Durations.short4,
              switchInCurve: Curves.easeOut,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1).animate(animation),
                  child: child,
                ),
              ),
              child: Text(
                element.getDisplayKey.toUpperCase(),
                key: ValueKey('${element.name}-${element.getDisplayKey}'),
                style: TextStyle(
                  fontSize: context.dynamicWidth(0.4),
                  fontWeight: FontWeight.bold,
                  height: 1,
                  fontFamily: 'Virgil',
                  color: element.getColor.withValues(alpha: 0.12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tek bir kablo. Elementin tuşu değiştiğinde alt ucu yeni tuşa yumuşak
/// bir geçişle kayar.
class _Cable extends StatelessWidget {
  const _Cable({
    required this.element,
    required this.isEmphasized,
    required this.startX,
    required this.boardWidth,
  });

  final Elements element;
  final bool isEmphasized;

  /// Kablonun üst ucu; elementin portunun merkezi.
  final double startX;

  /// Klavyenin de kullandığı toplam genişlik; tuş konumu buna göre bulunur.
  final double boardWidth;

  @override
  Widget build(BuildContext context) {
    final keyCenterX = KeyboardLayout.centerXOfCharacter(
      element.getDisplayKey.toUpperCase(),
      boardWidth,
    );

    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        // Tuş düzende bulunamazsa kablo düz iner.
        tween: Tween(end: keyCenterX ?? startX),
        duration: Durations.medium4,
        curve: Curves.easeInOutCubic,
        builder: (_, endX, __) => CustomPaint(
          painter: CablePainter(
            color: element.getColor,
            startX: startX,
            endX: endX,
            isEmphasized: isEmphasized,
          ),
        ),
      ),
    );
  }
}
