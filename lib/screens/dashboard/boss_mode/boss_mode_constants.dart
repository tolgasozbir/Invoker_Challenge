import 'package:flutter/material.dart';

//TODO: CONST
const circleColor = Color(0xFFB50DE2);
const boxDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(8)),
  border: Border.symmetric(
    horizontal: BorderSide(strokeAlign: BorderSide.strokeAlignOutside),
    vertical: BorderSide(strokeAlign: BorderSide.strokeAlignOutside),
  ),
  boxShadow: [BoxShadow(blurRadius: 8)],
);
