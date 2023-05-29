abstract class IBaseModel<T> {
  Map<String, dynamic> toMap();
  T fromMap(Map<String, dynamic> map);
}

abstract class ICommonProperties {
  String? uid;
  String? name;
  int? score;
}
