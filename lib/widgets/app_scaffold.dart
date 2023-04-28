import 'package:flutter/material.dart';

class AppScaffold extends Scaffold {
  @override
  final Widget body;
  @override
  final bool resizeToAvoidBottomInset;
  @override
  final bool extendBodyBehindAppBar;
  final AppBar? appbar;

  AppScaffold({required this.body, this.resizeToAvoidBottomInset = true, this.extendBodyBehindAppBar = true, this.appbar}) : super(
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    extendBodyBehindAppBar: extendBodyBehindAppBar,
    appBar: appbar ?? _BaseAppBar(),
    body: body,
  );
}

class _BaseAppBar extends AppBar {
  _BaseAppBar() : super(
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
