import 'package:dota2_invoker/mixins/orb_mixin.dart';
import 'package:dota2_invoker/screens/dashboard/with_timer/with_timer_view.dart';
import 'package:flutter/material.dart';
import '../../../widgets/trueFalseWidget.dart';

abstract class WithTimerViewModel extends State<WithTimerView> with OrbMixin {

  final globalAnimKey = GlobalKey<TrueFalseWidgetState>();

  @override
  void initState() {
    super.initState();
  }

}