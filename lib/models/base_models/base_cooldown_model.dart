abstract class ICooldownModel {
  DateTime lastPressedAt = DateTime.now().subtract(const Duration(minutes: 3));
  double get getRemainingCooldownTime;
  bool onPressed(double currentMana);
  void resetCooldown() {
    lastPressedAt = DateTime.now().subtract(const Duration(minutes: 3));
  }
}
