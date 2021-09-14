import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrueFalseWidget extends StatelessWidget {
  const TrueFalseWidget({
    Key? key,
    required this.animTranslateTrue,
    required this.animAlphaTrue,
    required this.animTranslateFalse,
    required this.animAlphaFalse,
  }) : super(key: key);

  final Animation<double> animTranslateTrue;
  final Animation<double> animAlphaTrue;
  final Animation<double> animTranslateFalse;
  final Animation<double> animAlphaFalse;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(offset: Offset(0.0,animTranslateTrue.value),
          child: Opacity(
            opacity: animAlphaTrue.value,
            child: Icon(
              FontAwesomeIcons.check,color: Color(0xFF33CC33),
            ),
          ),
        ),
        Transform.translate(offset: Offset(0.0,animTranslateFalse.value),
          child: Opacity(
            opacity: animAlphaFalse.value,
            child: Icon(
              FontAwesomeIcons.times,color: Color(0xFFCC3333),
            ),
          ),
        ),
      ],
    );
  }
}