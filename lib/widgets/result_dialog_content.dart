import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

class ResultDialogContent extends StatelessWidget {
  const ResultDialogContent({Key? key, required this.correctCount, required this.textEditingController}) : super(key: key);

  final int correctCount;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
   return Column(
    children: [
      Text("${AppStrings.trueCombinations}\n\n$correctCount",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),textAlign: TextAlign.center,),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: textEditingController,
          maxLength: 14,
          decoration: InputDecoration(
            fillColor: Colors.white24,
            filled: true,
            border: OutlineInputBorder(),
            hintText: AppStrings.nickname,
            labelText: AppStrings.nickname,
            labelStyle: TextStyle(color: Colors.amber, fontSize: 18,fontWeight: FontWeight.w600)
          ),
        ),
      ),
    ],
   );
  }
}