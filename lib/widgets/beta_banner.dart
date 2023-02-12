import 'package:dota2_invoker/constants/app_colors.dart';

import '../constants/app_strings.dart';
import 'package:flutter/material.dart';

class BetaBanner extends StatelessWidget {
  const BetaBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Banner(
      message: AppStrings.appVersion, 
      location: BannerLocation.topStart,
      color: AppColors.black,
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
