import '../enums/items.dart';
import '../services/sound_manager.dart';

class Item {
  Items item;
  DateTime _lastPressedAt = DateTime.now().subtract(Duration(minutes: 3)); //3 minutes because the refresher orb item cooldown is 3 minutes
  double get cooldownLeft => (item.cooldown ?? 0) - (DateTime.now().difference(_lastPressedAt).inSeconds);

  Item({required this.item});

  bool onPressedItem(double currentMana) {
    if (item.cooldown == null) return false;
    if (DateTime.now().difference(_lastPressedAt) > Duration(seconds: item.cooldown!.toInt())) {
      bool canUseItem = currentMana >= (item.mana ?? 0);
      if (canUseItem) {
        _lastPressedAt = DateTime.now();
        //TODO: İTEM SOUND //BOSS PROVİDER'DAN BURAYA TAŞIYABİLİRSİN- SWİTCH-CASE'DE DAHİL
        return true;
      } else {
        SoundManager.instance.playNoManaSound();
        return false;
      }
    } else {
      SoundManager.instance.playAbilityOnCooldownSound();
      return false;
    }
  }

  void resetCooldown() {
    _lastPressedAt = DateTime.now().subtract(Duration(minutes: 3));
  }

}