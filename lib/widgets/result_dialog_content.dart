import '../extensions/context_extension.dart';
import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

class ResultDialogContent extends StatelessWidget {
  const ResultDialogContent({super.key, required this.correctCount, required this.textEditingController});

  final int correctCount;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
   return Column(
    children: [
      Text(
        '${AppStrings.trueCombinations}\n\n$correctCount',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500, 
          fontSize: context.sp(13)
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: textEditingController,
          maxLength: 14,
          decoration: InputDecoration(
            fillColor: Colors.white24,
            filled: true,
            border: const OutlineInputBorder(),
            hintText: AppStrings.username,
            labelText: AppStrings.username,
            labelStyle: TextStyle(color: Colors.amber, fontSize: context.sp(13), fontWeight: FontWeight.w600),
          ),
        ),
      ),
    ],
   );
  }
}
