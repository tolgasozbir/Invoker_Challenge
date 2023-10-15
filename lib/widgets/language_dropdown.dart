import 'package:dota2_invoker_game/constants/locale_keys.g.dart';
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:dota2_invoker_game/providers/app_context_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum LangCodes { En, Ru, Tr, }

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({super.key});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: context.dynamicWidth(0.72),
      leadingIcon: const Icon(Icons.language),
      label: FittedBox(
        child: Text(
          LocaleKeys.commonGeneral_language.locale, 
          style: TextStyle(fontSize: context.sp(13)),
        ),
      ),
      dropdownMenuEntries: LangCodes.values.map((e) => DropdownMenuEntry(value: e.index, label: e.name)).toList(),
      onSelected: (selected) async {
        if (selected == null) return;
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
            break;
        }
        if (mounted) {
          await Future.delayed(const Duration(milliseconds: 100));
          Navigator.pop(context);
        }
      },
    );
  }
}
