import '../constants/app_strings.dart';

enum Elements {quas, wex, exort, invoke}

extension elementsExtension on Elements {
  String get getImage => '${ImagePaths.elements}$name.png';
  String get getKey => name[0];
}
