import 'package:flutter/material.dart';

import '../../constants/app_strings.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({Key? key, required this.page}) : super(key: key);

  final Widget page;

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {

  Duration _loadingDuration = Duration(milliseconds: 3000);

  @override
  void initState() {
    _navigateToPage();
    super.initState();
  }

  void _navigateToPage() async {
    Future.delayed(_loadingDuration, () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> widget.page));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePaths.loadingGif),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}