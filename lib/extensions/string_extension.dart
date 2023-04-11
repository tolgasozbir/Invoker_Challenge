extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    else return this.split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}