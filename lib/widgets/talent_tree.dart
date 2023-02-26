import '../constants/app_strings.dart';
import '../extensions/widget_extension.dart';
import '../models/user_model.dart';
import '../providers/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_colors.dart';
import 'context_menu.dart';

class TalentTree extends StatelessWidget {
  const TalentTree({
    Key? key, required this.user,
  }) : super(key: key);

  final UserModel user;

  final double offStateIconSize = 64;
  final double previewIconSize = 256;
  List<double> get treeHeightFactors => const [0.64, 0.48, 0.32, 0.0];
  double get getTreeHeightFactor {
    var treeLevels = UserManager.instance.treeLevels.reversed.toList(); //25 20 15 10
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
          title: AppStrings.talents[index], 
          talentLevel: UserManager.instance.treeLevels[index]
        ),
      ).reversed.toList(),
      //Back Button
      CupertinoContextMenuAction(
        onPressed: () => Navigator.pop(context),
        child: Center(
          child: Text(
            AppStrings.close,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
  }

  CupertinoContextMenuAction menuActionBtn({
    required BuildContext context, 
    required String title, 
    required int talentLevel
  }) => CupertinoContextMenuAction(
    trailingIcon: user.level < talentLevel 
      ? CupertinoIcons.xmark_circle
      : CupertinoIcons.check_mark_circled,
    child: Text(
      title,
      textAlign: TextAlign.center,
    ).wrapCenter(),
  );

  SingleChildScrollView previewWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          offStateWidget(
            alignment: Alignment.topCenter,
            size: previewIconSize
          ),
          DefaultTextStyle(
            style: TextStyle(fontSize: 32), 
            child: Text(AppStrings.talentTree)
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
            child: talentTreeSvg(size, AppColors.svgTalentTree),
          ),
        ),
      ],
    ).wrapPadding(const EdgeInsets.all(2));
  }

  SvgPicture talentTreeSvg(double size, Color color) {
    return SvgPicture.asset(
      ImagePaths.svgTalentTree, 
      height: size, 
      color: color
    );
  }

}
