import '../enums/items.dart';
import '../services/sound_manager.dart';
import 'base_cooldown_model.dart';

class Item extends ICooldownModel {
  Items item;
  Item({required this.item});

  @override
  double get getRemainingCooldownTime => (item.cooldown ?? 0) - (DateTime.now().difference(lastPressedAt).inSeconds);

  @override
  bool onPressed(double currentMana) {
    if (item.cooldown == null) return false;
    final cooldown = Duration(seconds: item.cooldown!.toInt());
    final isCooldownOver = DateTime.now().difference(lastPressedAt) > cooldown;

    if (!isCooldownOver) {
      SoundManager.instance.playCooldownSound();
      return false;
    }

    if (currentMana < (item.manaCost ?? 0)) {
      SoundManager.instance.playNoManaSound();
      return false;
    }

    lastPressedAt = DateTime.now();
    return true;
    //TODO: İTEM SOUND //BOSS PROVİDER'DAN BURAYA TAŞIYABİLİRSİN- SWİTCH-CASE'DE DAHİL
  }

}
