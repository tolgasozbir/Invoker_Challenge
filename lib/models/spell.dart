import 'package:flutter/foundation.dart';

class Spell {
  const Spell(this.image,this.combine);

  final String image;
  final List<String> combine;

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
