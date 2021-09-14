import 'package:flutter/material.dart';

class InvokerCombinedSkillsWidget extends StatelessWidget {
  const InvokerCombinedSkillsWidget({
    Key? key,
    required this.image,
    required this.w,

  }) : super(key: key);

  final String image;
  final double w;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: w,
      decoration: BoxDecoration(
        boxShadow: [ BoxShadow(color: Colors.white30, blurRadius: 12, spreadRadius: 4), ],
      ),
      child: Image.asset(image)
    );
  }
}