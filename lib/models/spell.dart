import 'package:flutter/foundation.dart';

class Spell {
  final String image;
  final List<String> combine;

  Spell(this.image,this.combine);

  @override
  bool operator ==(covariant Spell other) {
    if (identical(this, other)) return true;
  
    return 
      other.image == image &&
      listEquals(other.combine, combine);
  }

  @override
  int get hashCode => image.hashCode ^ combine.hashCode;
}
