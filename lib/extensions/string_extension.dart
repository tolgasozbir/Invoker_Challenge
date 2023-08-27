import 'package:easy_localization/easy_localization.dart';

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    else return this.split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  String get locale => this.tr();
  String localeWithArgs({List<String>? args}) => this.tr(args: args);
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? false;
  bool get isNotNullOrNoEmpty => this?.isNotEmpty ?? false;
}
