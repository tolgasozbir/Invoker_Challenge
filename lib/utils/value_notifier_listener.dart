import 'package:flutter/material.dart';
//ValueNotifier<int> _counter = ValueNotifier<int>(0);
class ValueNotifierListener<T> extends StatelessWidget {
  final ValueNotifier<T> valueNotifier;
  final Widget Function(T) builder;

  const ValueNotifierListener({super.key, 
    required this.valueNotifier,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return builder(value);
      },
    );
  }
}
