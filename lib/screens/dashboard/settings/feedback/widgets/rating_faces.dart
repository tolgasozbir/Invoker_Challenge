import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_strings.dart';

class RatingFaces extends StatefulWidget {
  const RatingFaces({super.key, required this.onSelected});

  final ValueChanged<int> onSelected;

  @override
  State<RatingFaces> createState() => _RatingFacesState();
}

class _RatingFacesState extends State<RatingFaces> {
  int selectedIndex = 5;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(ImagePaths.ratingFaces.length, (index) {
        var svg = ImagePaths.ratingFaces[index];
        return InkWell(
          child: SvgPicture.asset(svg, color: selectedIndex == index+1 ? AppColors.amber : AppColors.white30),
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            setState(() => selectedIndex = index+1);
            widget.onSelected.call(selectedIndex);
          },
        ).wrapPadding(EdgeInsets.symmetric(horizontal: 4)).wrapExpanded();
      }),
    );
  }
}