extension NumberExtension on num {
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
