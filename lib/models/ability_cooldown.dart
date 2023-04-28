import '../enums/spells.dart';
import '../services/sound_manager.dart';

class AbilityCooldown {
  Spells spell;
  DateTime _lastPressedAt = DateTime.now().subtract(const Duration(minutes: 1));
  double get cooldownLeft => spell.cooldown - (DateTime.now().difference(_lastPressedAt).inSeconds);

  AbilityCooldown({required this.spell});

  bool onPressedAbility(double currentMana) {
    if (DateTime.now().difference(_lastPressedAt) > Duration(seconds: spell.cooldown.toInt())) {
      final bool canUseAbility = currentMana >= spell.mana;
      if (canUseAbility) {
        _lastPressedAt = DateTime.now();
        SoundManager.instance.spellCastTriggerSound(spell.combine);
        return true;
      }
      SoundManager.instance.playNoManaSound();
      return false;
    } else {
      SoundManager.instance.playAbilityOnCooldownSound();
      return false;
    }
  }

  void resetCooldown() {
    _lastPressedAt = DateTime.now().subtract(const Duration(minutes: 1));
  }

}
