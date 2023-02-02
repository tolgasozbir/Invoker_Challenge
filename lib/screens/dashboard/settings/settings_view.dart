import 'package:dota2_invoker/constants/app_strings.dart';

import '../../../extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.dynamicHeight(0.24);
    return Center(
      child: Column(
        children: [
          volumeSlider(size),
          divider(),
          menuItem(
            leading: FontAwesomeIcons.questionCircle,
            text: AppStrings.aboutUs
          ),
          divider(),
          menuItem(
            leading: FontAwesomeIcons.commentDots,
            text: AppStrings.feedback
          ),
          divider(),
          menuItem(
            leading: FontAwesomeIcons.starHalfAlt,
            text: AppStrings.rateApp
          ),
          divider(),
        ],
      ),
    );
  }

  Divider divider() => Divider(color: Colors.amber, height: 24,);

  SleekCircularSlider volumeSlider(double size) {
    return SleekCircularSlider(
      min: 0,
      max: 100,
      initialValue: 50,
      onChangeEnd: (value) {
        print(value);
      },
      appearance: CircularSliderAppearance(
        size: size,
        infoProperties: InfoProperties(
          mainLabelStyle: TextStyle(
            color: Color.fromRGBO(220, 190, 251, 1.0),
            fontSize: size / 5.0,
            fontWeight: FontWeight.w300,
          ),
          bottomLabelText: "Volume",
          bottomLabelStyle: TextStyle(
            color: Color.fromRGBO(220, 190, 251, 1.0),
            fontSize: size / 10.0,
            fontWeight: FontWeight.w600,
          ),
        )
      ),
    );
  }

  Widget menuItem({required IconData leading, required String text}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(leading),
        Spacer(),
        Text(text, style: TextStyle(fontSize: 18),),
        Spacer(flex: 9,),
        Icon(FontAwesomeIcons.chevronRight)
      ],
    );
  }
}