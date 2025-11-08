import 'package:flutter/material.dart';

import '../constants/locale_keys.g.dart';
import '../extensions/string_extension.dart';

mixin InputValidationMixin {

  final formKey = GlobalKey<FormState>();
  bool isValidate = false;
  final String _emailRegex = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  String? isValid(String? value) {
    return value?.trim().isNotEmpty ?? false 
      ? null
      : LocaleKeys.inputValidation_cannotEmpty.locale;
  }  
  
  String? isValidEmail(String? email) {
    return email != null 
      ? RegExp(_emailRegex).hasMatch(email) 
        ? null 
        : LocaleKeys.inputValidation_invalidMail.locale 
      : LocaleKeys.inputValidation_cannotEmpty.locale;
  }  
  
  String? isValidPassword(String? password) {
    return password?.isNotEmpty ?? false
      ? password!.trim().length >= 6 
        ? null 
        : LocaleKeys.inputValidation_invalidPass.locale
      : LocaleKeys.inputValidation_cannotEmpty.locale;
  }  

}
