import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';
import '../constants/app_image_paths.dart';
import '../constants/locale_keys.g.dart';
import '../extensions/widget_extension.dart';
import '../models/user_model.dart';
import '../services/user_manager.dart';
import 'context_menu.dart';

class TalentTree extends StatelessWidget {
  const TalentTree({
    super.key, required this.user,
  });

  final UserModel user;

  List<String> get talents => [
    LocaleKeys.talents_talent10.locale,
    LocaleKeys.talents_talent15.locale,
    LocaleKeys.talents_talent20.locale,
    LocaleKeys.talents_talent25.locale,
  ];

  double get offStateIconSize => 64;
  double get previewIconSize => 256;
  List<double> get treeHeightFactors => const [0.64, 0.48, 0.32, 0.0];
  double get getTreeHeightFactor {
    final treeLevels = UserManager.instance.treeLevels.reversed.toList(); //25 20 15 10
    for (var i = 0; i < treeHeightFactors.length; i++) {
      if (user.level >= treeLevels[i]) {
        return treeHeightFactors[treeHeightFactors.length-1-i];
      }
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return ContextMenu(
      actions: actions(context),
      previewBuilder: (context, animation, child) => previewWidget(),
      child: offStateWidget(size: offStateIconSize),
    );
  }

  List<Widget> actions(BuildContext context) {
    return [
      ...List.generate(UserManager.instance.treeLevels.length, (index) => 
        menuActionBtn(
          context: context, 
          title: '${UserManager.instance.treeLevels[index]}) ${talents[index]} ', 
          talentLevel: UserManager.instance.treeLevels[index],
        ),
      ).reversed,
      //Back Button
      CupertinoContextMenuAction(
        onPressed: () => Navigator.pop(context),
        child: Center(
          child: Text(
            LocaleKeys.commonGeneral_close.locale,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
  }

  CupertinoContextMenuAction menuActionBtn({
    required BuildContext context, 
    required String title, 
    required int talentLevel,
  }) => CupertinoContextMenuAction(
    trailingIcon: user.level < talentLevel 
      ? CupertinoIcons.xmark_circle
      : CupertinoIcons.check_mark_circled,
    isDestructiveAction: user.level < talentLevel,
    child: FittedBox(
      child: Text(title),
    ),
  );

  SingleChildScrollView previewWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          offStateWidget(
            alignment: Alignment.topCenter,
            size: previewIconSize,
          ),
          DefaultTextStyle(
            style: const TextStyle(fontSize: 32), 
            child: Text(LocaleKeys.talents_talentTree.locale),
          ),
        ],
      ),
    );
  }

  Widget offStateWidget({Alignment alignment = Alignment.topLeft, required double size}) {
    return Stack(
      children: [
        talentTreeSvg(size, AppColors.amber).wrapAlign(alignment),
        ClipRect(
          child: Align(
            alignment: alignment,
            heightFactor: getTreeHeightFactor,
            child: talentTreeSvg(size, AppColors.grey),
          ),
        ),
      ],
    ).wrapPadding(const EdgeInsets.all(2));
  }

  SvgPicture talentTreeSvg(double size, Color color) {
    return SvgPicture.asset(
      ImagePaths.svgTalentTree, 
      height: size,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }

}
