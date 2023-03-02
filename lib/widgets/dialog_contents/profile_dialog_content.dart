import 'package:dota2_invoker/extensions/context_extension.dart';
import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:dota2_invoker/screens/profile/achievements/achievements_view.dart';
import 'package:flutter/material.dart';

class ProfileDialogContent extends StatelessWidget {
  const ProfileDialogContent({super.key});

  @override
  Widget build(BuildContext context) {

    final ic_achievements = "assets/images/achievements/ic_achievements.png";

    return Column(
      children: [
        achievements(context, ic_achievements),
        Divider(color: Colors.amber)
      ],
    );
  }

  InkWell achievements(BuildContext context, String ic_achievements) {
    return InkWell(
      child: SizedBox(
        height: context.dynamicHeight(0.16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(ic_achievements),
            Column(
              children: [
                FittedBox(child: Text('Achievements',)).wrapExpanded(flex: 2),
                FittedBox(child: Text('0/18',)).wrapExpanded(flex: 1),
                Spacer(),
              ],
            ).wrapExpanded(flex: 2),
            Icon(Icons.chevron_right, color: Color.fromARGB(255, 251, 138, 176),).wrapCenter()
          ],
        ),
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AchievementsView(),)),
    );
  }

}