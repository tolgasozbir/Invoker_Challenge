import '../../../mixins/orb_mixin.dart';
import 'package:flutter/material.dart';
import '../../../widgets/trueFalseWidget.dart';
import 'training_view.dart';

abstract class TrainingViewModel extends State<TrainingView> with OrbMixin {

  final globalAnimKey = GlobalKey<TrueFalseWidgetState>();
  bool showAllSpells = false;

  @override
  void initState() {
    super.initState();
  }

}