import '../enums/spells.dart';
import '../services/sound_manager.dart';

class Ability {
  Spells spell;
  DateTime _lastPressedAt = DateTime.now().subtract(const Duration(minutes: 1));
  double get cooldownLeft => spell.cooldown - (DateTime.now().difference(_lastPressedAt).inSeconds);

  Ability({required this.spell});

  bool useSpell(double currentMana) {
    final cooldown = Duration(seconds: spell.cooldown.toInt());
    final isCooldownOver = DateTime.now().difference(_lastPressedAt) > cooldown;

    if (!isCooldownOver) {
      SoundManager.instance.playAbilityOnCooldownSound();
      return false;
    }

    if (currentMana < spell.mana) {
      SoundManager.instance.playNoManaSound();
      return false;
    }

    _lastPressedAt = DateTime.now();
    SoundManager.instance.spellCastTriggerSound(spell.combine);
    return true;
  }

  void resetCooldown() {
    _lastPressedAt = DateTime.now().subtract(const Duration(minutes: 1));
  }

}
