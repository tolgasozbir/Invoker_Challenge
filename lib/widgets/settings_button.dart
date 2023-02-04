import '../constants/app_strings.dart';
import '../extensions/context_extension.dart';
import 'custom_animated_dialog.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../screens/dashboard/settings/settings_view.dart';

class SettingsButton extends StatefulWidget {
  const SettingsButton({ Key? key, }) : super(key: key);

  @override
  State<SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  final _tween = Tween<double>(begin: 0.0, end: 1.0);
  final _animDuration = const Duration(milliseconds: 1000);

  final boxDecoration = BoxDecoration(
    color: AppColors.buttonSurfaceColor,
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(
      color: Colors.black,
      width: 2,
    ),
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
        margin: EdgeInsets.all(8.0),
        decoration: boxDecoration,
        child: RotationTransition(
          turns: _tween.animate(_controller),
          child: icon,
        ),
      ),
    );
  }

  Icon get icon => Icon(
    Icons.settings, 
    size: 40, 
    color: Colors.white, 
    shadows: [
      Shadow(
        color: Colors.black, 
        blurRadius: 32
      ),
    ],
  );

  void onTapFn() async {
    _controller.forward();
    await CustomAnimatedDialog.showCustomDialog<bool>(
      height: context.dynamicHeight(0.72),
      title: AppStrings.settings, 
      content: SettingsView(),
      dismissible: true,
    );
    _controller.reverse();
  }
}