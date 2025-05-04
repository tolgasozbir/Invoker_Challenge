import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalizationManager extends EasyLocalization {
  LocalizationManager({
    super.key, 
    required super.child, 
  }) : super(
    path: 'assets/lang',
    supportedLocales: [
      const Locale('en'),
      const Locale('tr'),
      const Locale('ru'),
    ],
    fallbackLocale: const Locale('en'),
    useFallbackTranslations: true,
  );
}
