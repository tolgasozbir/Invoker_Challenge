import '../enums/spells.dart';
import '../services/sound_manager.dart';

class AbilityCooldown {
  Spells spell;
  DateTime _lastPressedAt = DateTime.now().subtract(Duration(minutes: 1));
  double get cooldownLeft => spell.cooldown - (DateTime.now().difference(_lastPressedAt).inSeconds);

  AbilityCooldown({required this.spell});

  bool onPressedAbility(double currentMana) {
    if (DateTime.now().difference(_lastPressedAt) > Duration(seconds: spell.cooldown.toInt())) {
      _lastPressedAt = DateTime.now();
      bool canUseAbility = currentMana >= spell.mana;
      if (canUseAbility) {
        SoundManager.instance.spellCastTriggerSound(spell.combine);
        return true;
      }
      //no mana
      return false;
    } else {
      //TODO: not time yet
      return false;
    }
  }

}