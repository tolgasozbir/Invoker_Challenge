import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_image_paths.dart';
import '../../../../../extensions/widget_extension.dart';

class RatingFaces extends StatefulWidget {
  const RatingFaces({super.key, required this.onSelected});

  final ValueChanged<int> onSelected;

  @override
  State<RatingFaces> createState() => _RatingFacesState();
}

class _RatingFacesState extends State<RatingFaces> {
  int selectedIndex = 5;
  int flex = 5;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(ImagePaths.ratingFaces.length, (index) {
        final svg = ImagePaths.ratingFaces[index];
        final isSelected = selectedIndex == index+1;
        flex = isSelected ? 6 : 5;
        return InkWell(
          child: SvgPicture.asset(svg, color: isSelected ? AppColors.amber : AppColors.white30),
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            setState(() => selectedIndex = index+1);
            widget.onSelected.call(selectedIndex);
          },
        ).wrapPadding(const EdgeInsets.symmetric(horizontal: 4)).wrapExpanded(flex: flex);
      }),
    );
  }
}
