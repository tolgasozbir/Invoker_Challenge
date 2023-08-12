import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalizationManager extends EasyLocalization {
  LocalizationManager({
    super.key, 
    required super.child, 
  }) : super(
    path: 'assets/lang',
    supportedLocales: [
      const Locale('en', 'US'),
      const Locale('tr', 'TR'),
      const Locale('ru', 'RU'),
    ],
    fallbackLocale: const Locale('en', 'US'),
    useFallbackTranslations: true,
  );
}
