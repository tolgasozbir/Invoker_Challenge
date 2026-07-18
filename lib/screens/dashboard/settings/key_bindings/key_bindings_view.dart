import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/locale_keys.g.dart';
import '../../../../enums/elements.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../extensions/string_extension.dart';
import '../../../../mixins/screen_state_mixin.dart';
import '../../../../services/key_binding_manager.dart';
import '../../../../widgets/app_snackbar.dart';
import '../../../../widgets/empty_box.dart';
import 'widgets/binding_keyboard.dart';
import 'widgets/cable_board.dart';
import 'widgets/element_gradient_divider.dart';
import 'widgets/element_port_row.dart';
import 'widgets/reset_bindings_button.dart';
import 'widgets/selected_element_hint.dart';

/// Kullanıcının element tuşlarını değiştirdiği ekran.
///
/// Akış: üstteki portlardan bir element seçilir, alttaki sanal klavyeden bir
/// tuşa basılır. Tuş başka bir elemente aitse ikisi takas edilir.
class KeyBindingsView extends StatefulWidget {
  const KeyBindingsView({super.key});

  @override
  State<KeyBindingsView> createState() => _KeyBindingsViewState();
}

class _KeyBindingsViewState extends State<KeyBindingsView> with ScreenStateMixin {
  final _keyBindingManager = KeyBindingManager.instance;

  late Elements _selectedElement;

  List<Elements> get _elements => _keyBindingManager.bindableElements;

  /// Klavyenin hangi tuşunun hangi elemente ait olduğunu bulmak için harita.
  Map<String, Elements> get _elementsByKey =>
      {for (final element in _elements) element.getDisplayKey.toUpperCase(): element};

  @override
  void initState() {
    super.initState();
    _selectedElement = _elements.first;
  }

  void _onElementSelected(Elements element) {
    HapticFeedback.selectionClick();
    if (element == _selectedElement) return;
    updateScreen(fn: () => _selectedElement = element);
  }

  Future<void> _onKeyTap(String key) async {
    HapticFeedback.lightImpact();
    final element = _selectedElement;
    final swappedElement = await _keyBindingManager.assignKey(element, key);
    updateScreen();

    if (swappedElement == null) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    AppSnackBar.showSnackBarMessage(
      text: LocaleKeys.keyBindings_swapMessage.localeWithArgs(
        args: [element.name, swappedElement.name],
      ),
      snackBartype: SnackBarType.info,
    );
  }

  Future<void> _onResetPressed() async {
    await _keyBindingManager.resetToDefaults();
    updateScreen();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    AppSnackBar.showSnackBarMessage(
      text: LocaleKeys.keyBindings_resetDone.locale,
      snackBartype: SnackBarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const EmptyBox.h4(),
              ElementGradientDivider(
                colors: [for (final element in _elements) element.getColor],
              ),
              const EmptyBox.h12(),
              SelectedElementHint(color: _selectedElement.getColor),
              const EmptyBox.h12(),
              ElementPortRow(
                elements: _elements,
                selectedElement: _selectedElement,
                onElementSelected: _onElementSelected,
              ),
              const EmptyBox.h4(),
              Expanded(
                child: CableBoard(
                  elements: _elements,
                  selectedElement: _selectedElement,
                ),
              ),
              const EmptyBox.h4(),
              BindingKeyboard(
                elementsByKey: _elementsByKey,
                selectedElement: _selectedElement,
                onKeyTap: _onKeyTap,
              ),
              const EmptyBox.h12(),
              ResetBindingsButton(onPressed: _onResetPressed),
              // AppOutlinedButton(
              //   title: LocaleKeys.keyBindings_reset.locale,
              //   width: double.infinity,
              //   padding: const EdgeInsets.only(bottom: 16),
              //   onPressed: _onResetPressed,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        LocaleKeys.keyBindings_title.locale.toUpperCase(),
        style: TextStyle(
          fontSize: context.sp(12),
          fontWeight: FontWeight.w800,
          letterSpacing: 4,
          color: AppColors.white.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
