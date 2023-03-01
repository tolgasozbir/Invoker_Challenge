import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';
import '../extensions/widget_extension.dart';

class AppTextFormField extends StatelessWidget {
  final Key? key;
  final String? hintText;
  final String? errorText;
  final Widget? prefixIcon;
  final String topLabel;
  final bool obscureText;
  final bool isExpand;
  final TextCapitalization textCapitalization;
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

  const AppTextFormField({
    this.key,
    this.hintText,
    this.prefixIcon,
    this.topLabel = '',
    this.obscureText = false,
    this.isExpand = false,
    this.textCapitalization = TextCapitalization.none,
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
          textAlignVertical: TextAlignVertical.top,
          keyboardType: this.keyboardType,
          obscureText: this.obscureText,
          expands: isExpand,
          onSaved: this.onSaved,
          onChanged: this.onChanged,
          validator: this.validator,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          style: TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 12),
            //labelText: hintText,
            hintMaxLines: 4,
            fillColor: bgColor ?? AppColors.textFormFieldBg,
            filled: true,
            prefixIcon: this.prefixIcon,
            enabledBorder: _inputBorderSide(color: borderColor ?? AppColors.white, width: 1),
            focusedBorder: _inputBorderSide(color: focusedBorderColor ?? Theme.of(context).colorScheme.primary),
            errorBorder: _inputBorderSide(color: errorBorderColor ?? Theme.of(context).colorScheme.error),
            focusedErrorBorder: _inputBorderSide(color: errorBorderColor ?? Theme.of(context).colorScheme.error),
            hintText: this.hintText,
            errorText: this.errorText
          ),
        ).wrapExpanded(flex: isExpand ? 1 : 0)
      ],
    );
  }

  OutlineInputBorder _inputBorderSide({required Color color, double width = 2}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }

}
