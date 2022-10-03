import 'package:flutter/material.dart';
import '../../../mixins/orb_mixin.dart';
import '../../../widgets/trueFalseWidget.dart';
import 'challanger_view.dart';

abstract class ChallangerViewModel extends State<ChallangerView> with OrbMixin {
  
  final globalAnimKey = GlobalKey<TrueFalseWidgetState>();

  @override
  void initState() {
    super.initState();
  }
}

