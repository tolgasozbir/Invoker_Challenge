import '../enums/spells.dart';
import '../services/sound_manager.dart';

class AbilityCooldown {
  Spells spell;
  DateTime _lastPressedAt = DateTime.now().subtract(Duration(minutes: 1));
  double get cooldownLeft => spell.cooldown - (DateTime.now().difference(_lastPressedAt).inSeconds);

  AbilityCooldown({required this.spell});

  void onPressedAbility() {
    if (DateTime.now().difference(_lastPressedAt) > Duration(seconds: spell.cooldown.toInt())) {
      _lastPressedAt = DateTime.now();
      SoundManager.instance.spellCastTriggerSound(spell.combine);
      //todo : check mana control if has mana use spell
    } else {
      //TODO: not time yet
      SoundManager.instance.playMeepMerp();
    }
  }

}