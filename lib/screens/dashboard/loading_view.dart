import 'package:flutter/material.dart';

import '../../constants/app_strings.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key, required this.page});

  final Widget page;

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {

  final Duration _loadingDuration = const Duration(milliseconds: 3000);

  @override
  void initState() {
    _navigateToPage();
    super.initState();
  }

  Future<void> _navigateToPage() async {
    await Future.delayed(_loadingDuration, () {
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
    return const SizedBox.expand(
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
