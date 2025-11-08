import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_image_paths.dart';
import '../../constants/locale_keys.g.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/string_extension.dart';
import '../../utils/fade_in_page_animation.dart';
import '../../widgets/empty_box.dart';

class LoadingContent {
  final String message;
  final List<String> imagePaths;

  LoadingContent({required this.message, this.imagePaths = const []});
}

class LoadingView extends StatefulWidget {
  const LoadingView({super.key, required this.page});

  final Widget page;

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  final _rng = Random();
  late LoadingContent _currentLoadingContent;
  List<LoadingContent> get _loadingContentList => [
    LoadingContent(
      message: LocaleKeys.loading_message1.locale,
      imagePaths: [],
    ),
    // LoadingContent(
    //   message: LocaleKeys.loading_message2.locale,
    //   imagePaths: [],
    // ),
    LoadingContent(
      message: LocaleKeys.loading_message3.locale,
      imagePaths: [
        ImagePaths.infoSettings,
        ImagePaths.infoFeedback,
      ],
    ),
    LoadingContent(
      message: LocaleKeys.loading_message4.locale,
      imagePaths: [
        ImagePaths.infoSettings,
        ImagePaths.infoFeedback,
      ],
    ),
    LoadingContent(
      message: LocaleKeys.loading_message5.locale,
      imagePaths: [
        ImagePaths.infoProfile,
        ImagePaths.infoPersona,
      ],
    ),
    LoadingContent(
      message: LocaleKeys.loading_message6.locale,
      imagePaths: [
        ImagePaths.infoColors1,
        ImagePaths.infoColors2,
      ],
    ),
    LoadingContent(
      message: LocaleKeys.loading_message7.locale,
      imagePaths: [
        ImagePaths.infoProfile,
        ImagePaths.infoPremium,
      ],
    ),
  ];

  @override
  void initState() {
    _currentLoadingContent = _loadingContentList[_rng.nextInt(_loadingContentList.length)];
    super.initState();
  }

  void _navigateToPage() {
    if (mounted) Navigator.pushReplacement(context, fadeInPageRoute(widget.page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateToPage,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _currentLoadingContent.imagePaths.map((path) => Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: Image.asset(path)),
                      const EmptyBox.h32(),
                    ],
                  ),
                ),).toList(),
              ),
            ),
            Column(
              children: [
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      LocaleKeys.loading_continue.locale,
                      style: const TextStyle(
                        color: AppColors.amberAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Virgil',
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(duration: 1600.ms, delay: 800.ms)
                    .animate(onPlay: (controller) => controller.repeat())
                    .scaleXY(begin: 1.0, end: 1.05, duration: 800.ms, curve: Curves.easeInOut)
                    .then().scaleXY(begin: 1.05, end: 1.0, duration: 800.ms, curve: Curves.easeInOut),
                  ),
                ),
        
                const EmptyBox.h8(),
                Image.asset(ImagePaths.loading),
                const EmptyBox.h16(),
                Text(
                  _currentLoadingContent.message,
                  style: TextStyle(fontSize: context.sp(12), fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
