import '../extensions/context_extension.dart';
import 'package:flutter/material.dart';

class BigSpellPicture extends StatelessWidget {
  const BigSpellPicture({
    Key? key,
    required this.image,
    this.size,
  }) : super(key: key);

  final String image;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? context.dynamicWidth(0.28),
      height: size ?? context.dynamicWidth(0.28),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white30, 
            blurRadius: 12, 
            spreadRadius: 4
          ),
        ],
      ),
      child: Image.asset(image)
    );
  }
}