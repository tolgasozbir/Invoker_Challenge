import '../enums/spells.dart';
import '../services/sound_manager.dart';
import 'base_models/base_cooldown_model.dart';

class Ability extends ICooldownModel {
  Spell spell;
  Ability({required this.spell});

  @override
  double get getRemainingCooldownTime => spell.cooldown - (DateTime.now().difference(lastPressedAt).inSeconds);

  @override
  bool onPressed(double currentMana) {
    final cooldown = Duration(seconds: spell.cooldown.toInt());
    final isCooldownOver = DateTime.now().difference(lastPressedAt) > cooldown;

    if (!isCooldownOver) {
      SoundManager.instance.playCooldownSound();
      return false;
    }

    if (currentMana < spell.mana) {
      SoundManager.instance.playNoManaSound();
      return false;
    }

    lastPressedAt = DateTime.now();
    SoundManager.instance.spellCastTriggerSound(spell);
    return true;
  }

}
