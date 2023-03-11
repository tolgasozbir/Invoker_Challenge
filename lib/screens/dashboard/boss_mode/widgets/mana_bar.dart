import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/extensions/widget_extension.dart';
import 'package:flutter/material.dart';

class ManaBar extends StatelessWidget {
  const ManaBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      height: context.dynamicHeight(0.048),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          colors: [
          Color.fromARGB(255, 30, 136, 222),
          Color.fromARGB(255, 54, 104, 190)
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          Text("1007/1007", style: TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.bold)).wrapCenter().wrapExpanded(),
          Text("+6.3", style: TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.bold)).wrapAlign(Alignment.centerRight).wrapExpanded(),
        ],
      ),
    );
  }
}