import 'package:easy_localization/easy_localization.dart';

extension StringExtension on String {
  /// Underscore'ları kaldırıp kelimelerin baş harflerini büyüt
  /// 
  /// anti_mage -> Anti Mage
  /// 
  /// riki -> Riki
  String toSpacedTitle() {
    if (this.isEmpty) return this;
    return this.split('_').map((word) => word.capitalize()).join(' ');
  }

  /// Underscore'ları koruyarak kelimelerin baş harflerini büyüt
  /// 
  /// anti_mage -> Anti_Mage
  /// 
  /// riki -> Riki
  String toSnakeTitle() {
    if (this.isEmpty) return this;
    return this.split('_').map((word) => word.capitalize()).join('_');
  }

  /// İlk harfi büyük yap
  /// 
  /// capitalize firt letter
  String capitalize() {
    if (this.isEmpty) return this;
    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }

  String get locale => this.tr();
  String localeWithArgs({List<String>? args}) => this.tr(args: args);
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? false;
  bool get isNotNullOrNoEmpty => this?.isNotEmpty ?? false;
}
