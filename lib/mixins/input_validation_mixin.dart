import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

mixin InputValidationMixin {

  final formKey = GlobalKey<FormState>();
  bool isValidate = false;
  final String _emailRegex = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  String? isValid(String? value) {
    return value?.trim().isNotEmpty ?? false 
      ? null
      : AppStrings.cannotEmpty;
  }  
  
  String? isValidEmail(String? email) {
    return email != null 
      ? RegExp(_emailRegex).hasMatch(email) ? null : AppStrings.invalidMail 
      : AppStrings.cannotEmpty;
  }  
  
  String? isValidPassword(String? password) {
    return password?.isNotEmpty ?? false
      ? password!.trim().length >= 6 ? null : AppStrings.invalidPass
      : AppStrings.cannotEmpty;
  }  

}
