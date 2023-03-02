import 'package:flutter/material.dart';

class AppScaffold extends Scaffold {
  final Widget body;
  final bool resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final AppBar? appBar;

  AppScaffold({required this.body, this.resizeToAvoidBottomInset = true, this.extendBodyBehindAppBar = true, this.appBar}) : super(
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    extendBodyBehindAppBar: extendBodyBehindAppBar,
    appBar: appBar ?? _BaseAppBar(),
    body: body,
  );
}

class _BaseAppBar extends AppBar {
  _BaseAppBar() : super(
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
