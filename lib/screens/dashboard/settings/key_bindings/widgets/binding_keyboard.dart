import 'package:flutter/material.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../enums/elements.dart';
import '../../../../../extensions/context_extension.dart';
import 'keyboard_layout.dart';

/// Tuş atamak için kullanılan sanal klavye. Bir elemente bağlı tuşlar o
/// elementin renginde gösterilir; boş bir tuşa dokunmak seçili elementi ona taşır.
class BindingKeyboard extends StatelessWidget {
  const BindingKeyboard({
    required this.elementsByKey,
    required this.selectedElement,
    required this.onKeyTap,
    super.key,
  });

  /// Büyük harf tuş -> o tuşa bağlı element.
  final Map<String, Elements> elementsByKey;

  final Elements selectedElement;

  /// Dokunulan tuşun büyük harfi ile çağrılır.
  final ValueChanged<String> onKeyTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: KeyboardLayout.padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black.withValues(alpha: 0.28),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.2)),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final unitWidth = KeyboardLayout.unitWidth(constraints.maxWidth);
          return Column(
            children: [
              _statusLeds(),
              for (var rowIndex = 0; rowIndex < KeyboardLayout.rows.length; rowIndex++) ...[
                if (rowIndex != 0) const SizedBox(height: KeyboardLayout.keyGap),
                _row(KeyboardLayout.rows[rowIndex], unitWidth),
              ],
            ],
          );
        },
      ),
    );
  }

  /// Klavyedeki element renklerindeki küçük durum ışıkları.
  Widget _statusLeds() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (final element in elementsByKey.values)
            Container(
              margin: const EdgeInsets.only(left: 6),
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: element.getColor,
              ),
            ),
        ],
      ),
    );
  }

  /// Tek bir klavye satırı; tuşların arasına eşit boşluk koyar.
  Widget _row(List<KeyboardKeySpec> specs, double unitWidth) {
    return Row(
      children: [
        for (var i = 0; i < specs.length; i++) ...[
          if (i != 0) const SizedBox(width: KeyboardLayout.keyGap),
          _keyCap(specs[i], unitWidth),
        ],
      ],
    );
  }

  /// Tuşun ölçüsünü hesaplar ve türüne göre atanabilir/dekoratif tuşa yönlendirir.
  Widget _keyCap(KeyboardKeySpec spec, double unitWidth) {
    final width = KeyboardLayout.keyWidth(spec, unitWidth);
    final height = unitWidth * KeyboardLayout.keyHeightRatio;

    if (!spec.isBindable) {
      return _DecorativeKeyCap(spec: spec, width: width, height: height);
    }

    final character = spec.character!;
    return _BindableKeyCap(
      character: character,
      boundElement: elementsByKey[character],
      selectedElement: selectedElement,
      width: width,
      height: height,
      onTap: () => onKeyTap(character),
    );
  }
}

/// Tıklanamayan dolgu tuşu (shift, enter...).
class _DecorativeKeyCap extends StatelessWidget {
  const _DecorativeKeyCap({
    required this.spec,
    required this.width,
    required this.height,
  });

  final KeyboardKeySpec spec;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white.withValues(alpha: 0.04),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
      ),
      child: Icon(
        spec.icon,
        size: 14,
        color: AppColors.white.withValues(alpha: 0.22),
      ),
    );
  }
}

/// Bir elemente atanabilen harf/rakam tuşu.
class _BindableKeyCap extends StatelessWidget {
  const _BindableKeyCap({
    required this.character,
    required this.boundElement,
    required this.selectedElement,
    required this.width,
    required this.height,
    required this.onTap,
  });

  final String character;

  /// Bu tuşa bağlı element; boş tuşlarda null.
  final Elements? boundElement;

  final Elements selectedElement;
  final double width;
  final double height;
  final VoidCallback onTap;

  bool get _isBound => boundElement != null;
  bool get _isSelected => boundElement == selectedElement;

  @override
  Widget build(BuildContext context) {
    final color = boundElement?.getColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: Durations.short4,
        scale: _isSelected ? 1.06 : 1.0,
        child: AnimatedContainer(
          duration: Durations.short4,
          curve: Curves.easeOut,
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _isBound
                ? color
                : AppColors.white.withValues(alpha: 0.06),
            border: _border(),
            // Basılı tuş hissi veren, gölgesiz sert alt kenar.
            boxShadow: _isBound
                ? [
                    BoxShadow(
                      color: Color.lerp(color, Colors.black, 0.5)!,
                      offset: const Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Text(
            character,
            style: TextStyle(
              fontSize: context.sp(12.5),
              fontWeight: _isBound ? FontWeight.w900 : FontWeight.w600,
              //fontFamily: "Virgil",
              color: _isBound
                  ? Colors.black.withValues(alpha: 0.8)
                  : AppColors.white.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }

  /// Seçili element beyaz çerçeveyle vurgulanır; bağlı tuşlar zaten dolu renkli olduğu için çerçevesiz kalır.
  Border? _border() {
    if (_isSelected) return Border.all(color: AppColors.white, width: 1.6);
    if (_isBound) return null;
    return Border.all(color: AppColors.white.withValues(alpha: 0.08));
  }
}
