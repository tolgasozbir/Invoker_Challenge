import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_strings.dart';
import '../../../../../extensions/context_extension.dart';
import '../../../../../widgets/context_menu.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  final name = "Tolga Sözbir";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height/3,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          avatarContextMenu(context),
          nameArcText(context),
        ],
      ),
    );
  }

  Positioned avatarContextMenu(BuildContext context) {
    return Positioned(
      top: context.dynamicHeight(0.08),
      child: ContextMenu(
        previewBuilder: (context, animation, child) => previewImage(),
        child: CircleImage(context),
      ),
    );
  }

  Image previewImage() => Image.asset(ImagePaths.profilePic);

  CircleAvatar CircleImage(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: context.dynamicHeight(0.086),
      child: CircleAvatar(
        backgroundImage: AssetImage(ImagePaths.profilePic),
        radius: context.dynamicHeight(0.08),
        child: smallCircleIcon(context),
      ),
    );
  }

  Stack smallCircleIcon(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: 0,
          right: -context.dynamicHeight(0.004),
          child: CircleAvatar(
            backgroundColor: AppColors.white,
            radius: context.dynamicHeight(0.024),
            child: CircleAvatar(
              backgroundColor: AppColors.aboutMeSmallCircle,
              radius: context.dynamicHeight(0.020),
              child: const Icon(
                CupertinoIcons.zoom_in, 
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Positioned nameArcText(BuildContext context) {
    return Positioned(
      top: 0,
      child: ArcText(
        radius: context.height/3,
        text: name,
        textStyle: TextStyle(
          fontSize: context.sp(20),
          fontWeight: FontWeight.w500, 
          shadows: [Shadow(blurRadius: 8,),],
        ),
        direction: Direction.counterClockwise,
        startAngleAlignment: StartAngleAlignment.center,
        startAngle: math.pi,
        placement: Placement.inside,
      ),
    );
  }
}