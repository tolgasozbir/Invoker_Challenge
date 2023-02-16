import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../extensions/context_extension.dart';
import '../screens/dashboard/settings/settings_view.dart';
import 'custom_animated_dialog.dart';

class SettingsButton extends StatefulWidget {
  const SettingsButton({ super.key, });

  @override
  State<SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  final _tween = Tween<double>(begin: 0, end: 1);
  final _animDuration = const Duration(milliseconds: 1000);

  final boxDecoration = BoxDecoration(
    color: AppColors.buttonBgColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(width: 2),
  );

  @override
  void initState() {
    _controller = AnimationController(
      duration: _animDuration,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFn,
      child: Container(
        width: 64,
        height: 64,
        margin: const EdgeInsets.all(8),
        decoration: boxDecoration,
        child: RotationTransition(
          turns: _tween.animate(_controller),
          child: icon,
        ),
      ),
    );
  }

  Icon get icon => const Icon(
    Icons.settings, 
    size: 40, 
    shadows: [
      Shadow(blurRadius: 32),
    ],
  );

  void onTapFn() async {
    _controller.forward();
    await CustomAnimatedDialog.showCustomDialog<bool>(
      height: context.dynamicHeight(0.72),
      title: AppStrings.settings, 
      content: const SettingsView(),
      dismissible: true,
    );
    _controller.reverse();
  }
}
