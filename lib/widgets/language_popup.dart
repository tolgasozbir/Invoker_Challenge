import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/locale_keys.g.dart';
import '../providers/app_context_provider.dart';

enum Languages { 
  En(iconPath: 'assets/icons/en_icon.png'), 
  Ru(iconPath: 'assets/icons/ru_icon.png'), 
  Tr(iconPath: 'assets/icons/tr_icon.png');

  const Languages({required this.iconPath});
  final String iconPath;
}

class LanguagePopup extends StatefulWidget {
  const LanguagePopup({super.key});

  @override
  State<LanguagePopup> createState() => _LanguagePopupState();
}

class _LanguagePopupState extends State<LanguagePopup> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: onSelectFn,
      //icon: const Icon(Icons.language),
      tooltip: 'Languages',
      offset: const Offset(0, 42),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.grey,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      itemBuilder: (context) => Languages.values.map((e) => _buildPopupMenuItem(e)).toList(),
      child: Column(
        children: [
          const Icon(Icons.language),
          Text(LocaleKeys.commonGeneral_language.locale),
        ],
      ),
    );
  }

  void onSelectFn(int selected) async {
    final ctx = context.read<AppContextProvider>().appContext ?? context;
    switch (selected) {
      case 0: 
        EasyLocalization.of(ctx)?.setLocale(const Locale('en', 'US'));
      case 1: 
        EasyLocalization.of(ctx)?.setLocale(const Locale('ru', 'RU'));
      case 2: 
        EasyLocalization.of(ctx)?.setLocale(const Locale('tr', 'TR'));
      default: 
        EasyLocalization.of(ctx)?.setLocale(const Locale('en', 'US'));   
    }
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 100));
      Navigator.pop(context);
    }
  }

  PopupMenuItem<int> _buildPopupMenuItem(Languages lang) {
    return PopupMenuItem(
      value: lang.index,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(lang.iconPath, width: context.dynamicWidth(0.06),),
          Text(lang.name),
        ],
      ),
    );
  }
}
