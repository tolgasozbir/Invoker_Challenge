import 'package:flutter/material.dart';

class ChallangerView extends StatefulWidget {
  const ChallangerView({Key? key}) : super(key: key);

  @override
  State<ChallangerView> createState() => _ChallangerViewState();
}

class _ChallangerViewState extends State<ChallangerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return Text('body');
  }
}