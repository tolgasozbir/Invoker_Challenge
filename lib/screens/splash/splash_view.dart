import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/app_image_paths.dart';
import 'splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends SplashViewModel {
  @override
  Widget build(BuildContext context) {
    return _bodyView();
  }

  Widget _bodyView() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Arka plan: görselin blur'lu hali, sistem çubuklarının arkası dahil tüm ekranı doldurur.
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30, tileMode: TileMode.clamp),
          child: Image.asset(
            ImagePaths.splashImage,
            fit: BoxFit.cover,
          ),
        ),
        const ColoredBox(color: Colors.black26),
        // Ön plan: görsel tam genişlikte, yanlardan kırpılmaz. Üst ve alt kenarı arka plana doğru erir.
        Center(
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (rect) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black, Colors.black, Colors.transparent],
              stops: [0, 0.15, 0.85, 1],
            ).createShader(rect),
            child: Image.asset(
              ImagePaths.splashImage,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ],
    );
  }
}
