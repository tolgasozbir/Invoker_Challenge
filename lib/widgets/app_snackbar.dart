import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

enum SnackBarType{
  info,
  success,
  warning,
  error,
}

class AppSnackBar {
  AppSnackBar._();

  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBarMessage({
    required String text, 
    Duration duration = const Duration(milliseconds: 2000), 
    required SnackBarType snackBartype,
  }) {
    return scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        clipBehavior: Clip.none,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.transparent,
        elevation: 0,
        content: _SnacBarContent(message: text, type: snackBartype),
      ),
    );
  }
}

class _SnacBarContent extends StatefulWidget {
  const _SnacBarContent({required this.type,required this.message,});

  final SnackBarType type;
  final String message;

  @override
  State<_SnacBarContent> createState() => _SnacBarContentState();
}

class _SnacBarContentState extends State<_SnacBarContent> with TickerProviderStateMixin {
  late final String snackBarTitle;
  late final Color snackBarColor;

  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animation = Tween<Offset>(begin: const Offset(0, 10), end: Offset.zero)
                .animate(CurvedAnimation(
                  parent: _controller, 
                  curve: Curves.elasticOut,
                ),
              );
    _controller.forward();

    switch (widget.type) {
      case SnackBarType.info:
        snackBarColor = AppColors.infoColor;
        snackBarTitle = 'info'; //TODO: STRİNGLERDE TOPLAYABİLİRSİN
        break;
      case SnackBarType.success:
        snackBarColor = AppColors.successColor;
        snackBarTitle = 'success';
        break;
      case SnackBarType.warning:
        snackBarColor = AppColors.warningColor;
        snackBarTitle = 'warning';
        break;
      case SnackBarType.error:
        snackBarColor = AppColors.errorColor;
        snackBarTitle = 'error';
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      child: SlideTransition(
        position: _animation,
        child: Stack(
          children: [
            Container(
              height: 92,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: snackBarColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: Row(
                children: [
                  const EmptyBox.w32(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$snackBarTitle!',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.message,
                          style: const TextStyle(fontSize: 14,color: AppColors.white), 
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
