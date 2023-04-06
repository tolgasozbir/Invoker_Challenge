extension NumberExtension on int {
  String getOrdinal() {
    if (this >= 11 && this <= 13) {
      return '${this}th';
    } else if (this % 10 == 1) {
      return '${this}st';
    } else if (this % 10 == 2) {
      return '${this}nd';
    } else if (this % 10 == 3) {
      return '${this}rd';
    } else {
      return '${this}th';
    }
  }
}