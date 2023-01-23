import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';

class BigSpellPicture extends StatelessWidget {
  const BigSpellPicture({
    Key? key,
    required this.image,
    this.size,
  }) : super(key: key);

  final String image;
  final double? size;
