import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/providers/app_context_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum LangCodes { en, ru, tr, }

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({super.key});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  //TODO: DİL
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: context.dynamicWidth(0.72),
      leadingIcon: const Icon(Icons.language),
      label: FittedBox(
        child: Text(
          'Language', 
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
            break;
          case 1: 
            EasyLocalization.of(ctx)?.setLocale(const Locale('ru', 'RU'));
            break;
          case 2: 
            EasyLocalization.of(ctx)?.setLocale(const Locale('tr', 'TR'));
            break;
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
