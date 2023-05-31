import 'dart:math';

import 'package:flutter/material.dart';

import '../../constants/app_image_paths.dart';
import '../../constants/app_strings.dart';
import '../../extensions/context_extension.dart';
import '../../utils/fade_in_page_animation.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key, required this.page});

  final Widget page;

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {

  final Duration _loadingDuration = const Duration(milliseconds: 5000);
  final rng = Random();
  String get message => AppStrings.messageList[rng.nextInt(AppStrings.messageList.length)];

  @override
  void initState() {
    _navigateToPage();
    super.initState();
  }

  Future<void> _navigateToPage() async {
    await Future.delayed(_loadingDuration, () {
      if (mounted) Navigator.pushReplacement(context, fadeInPageRoute(widget.page));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagePaths.loadingGif),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 32,
          left: 32,
          right: 32,
          child: Text(
            message,
            style: TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
