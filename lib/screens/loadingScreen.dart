import 'dart:async';
import 'package:dota2_invoker/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class LoadingScreen extends StatefulWidget {
  dynamic screen;
  LoadingScreen(this.screen);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {


  @override
  void initState() {
    Timer(Duration(milliseconds: 3000), ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> widget.screen)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          body: buildBody(),
        );
      },
    );
  }

  Widget buildBody() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePaths.loadingGif),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

}