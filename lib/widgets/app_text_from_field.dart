import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTextFormField extends StatelessWidget {
  final Key? key;
  final String? hintText;
  final String? errorText;
  final Widget? prefixIcon;
  final String topLabel;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int? maxLength;
  final int? maxLines;
  final Color? errorBorderColor;
  final Color? focusedBorderColor;
  final Color? borderColor;
  final Color? bgColor;

  AppTextFormField({
    this.key,
    this.hintText,
    this.prefixIcon,
    this.topLabel = '',
    this.obscureText = false,
    this.textInputAction,
    this.onSaved,
    this.keyboardType,
    this.errorText,
    this.onChanged,
    this.validator,
    this.controller,
    this.maxLength, 
    this.maxLines = 1,
    this.borderColor,
    this.errorBorderColor,
    this.focusedBorderColor,
    this.bgColor,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(this.topLabel, style: TextStyle(fontSize: context.sp(10))),
        const EmptyBox.h4(),
        TextFormField(
          key: this.key,
          controller: this.controller,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: this.keyboardType,
          obscureText: this.obscureText,
          onSaved: this.onSaved,
          onChanged: this.onChanged,
          validator: this.validator,
          textInputAction: textInputAction,
          style: TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 12),
            //labelText: hintText,
            fillColor: bgColor ?? AppColors.textFormFieldBg,
            filled: true,
            prefixIcon: this.prefixIcon,
            enabledBorder: inputBorderSide(color: borderColor ?? AppColors.white, width: 1),
            focusedBorder: inputBorderSide(color: focusedBorderColor ?? Theme.of(context).colorScheme.primary),
            errorBorder: inputBorderSide(color: errorBorderColor ?? Theme.of(context).errorColor),
            focusedErrorBorder: inputBorderSide(color: errorBorderColor ?? Theme.of(context).errorColor),
            hintText: this.hintText,
            errorText: this.errorText
          ),
        )
      ],
    );
  }

  OutlineInputBorder inputBorderSide({required Color color, double width = 2}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }

}
