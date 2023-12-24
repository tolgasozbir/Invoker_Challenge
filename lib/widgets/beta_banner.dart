import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

//TODO: UNUSED
class BetaBanner extends StatelessWidget {
  const BetaBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Banner(
      message: AppStrings.appVersionStr, 
      location: BannerLocation.topStart,
      color: AppColors.black,
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
