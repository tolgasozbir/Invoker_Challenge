import 'package:dota2_invoker_game/services/user_manager.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_image_paths.dart';

enum Elements {quas, wex, exort, invoke}

extension ElementsExtension on Elements {
  String get getImage => UserManager.instance.invokerType.skills[this] ?? ImagePaths.ic_unknown;
  String get getKey {
    if (this.name == 'invoke') return 'r';
    return name[0];
  }
  Color get getColor {
    switch (this) {
      case Elements.quas:
        return AppColors.quasColor;
      case Elements.wex:
        return AppColors.wexColor;
      case Elements.exort:
        return AppColors.exortColor;
      case Elements.invoke:
        return AppColors.white;
    }
  }
}
