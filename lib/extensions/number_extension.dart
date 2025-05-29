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

  /// Converts a double value in the range 0-1 to 0-255 integer color byte.
  int toColorByte() => (this.clamp(0.0, 1.0) * 255).round();
}
