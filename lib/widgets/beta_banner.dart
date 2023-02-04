import 'package:dota2_invoker/constants/app_strings.dart';
import 'package:flutter/material.dart';

class BetaBanner extends StatelessWidget {
  const BetaBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Banner(
      message: AppStrings.appVersion, 
      location: BannerLocation.topStart,
      color: Colors.black,
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}