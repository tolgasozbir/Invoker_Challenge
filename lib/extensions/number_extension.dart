extension NumberExtension on num {
  String get getOrdinal {
    final val = this.toInt();
    if (val >= 11 && val <= 13) return '${val}th';
    switch (val % 10) {
      case 1: return '${val}st';
      case 2: return '${val}nd';
      case 3: return '${val}rd';
      default: return '${val}th';
    }
  }

  String get numberFormat {
    final numberString = this.toStringAsFixed(0);
    final numberDigits = List.from(numberString.split(''));
    int index = numberDigits.length - 3;
    while (index > 0) {
      numberDigits.insert(index, '.');
      index -= 3;
    }
    return numberDigits.join();
  }
}
