import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.text, required this.padding, required this.onTap}) : super(key: key);

  final String text;
  final EdgeInsetsGeometry padding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: context.dynamicWidth(0.36),
        height: context.dynamicHeight(0.06),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonSurfaceColor,
          ),
          child: Text(text, style: TextStyle(fontSize: context.sp(12)),),
          onPressed: onTap,
        ),
      )
    );
  }
}