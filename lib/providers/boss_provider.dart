import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../constants/app_strings.dart';
import '../enums/Bosses.dart';
import '../enums/items.dart';
import '../enums/spells.dart';
import '../extensions/number_extension.dart';
import '../models/Item.dart';
import '../models/ability_cooldown.dart';
import '../models/boss_round_result_model.dart';
import '../screens/profile/achievements/achievement_manager.dart';
import '../services/sound_manager.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/dialog_contents/boss_result_dialog_content.dart';
import 'user_manager.dart';

class BossProvider extends ChangeNotifier {
  Timer? _timer;
  final rng = math.Random();

  //Boss Game Values
  int elapsedTime = 0;
  int get getRemainingTime => timeUnits - elapsedTime;
  bool started = false;
  bool isHornSoundPlaying = false;
  bool hornSoundPlayed = false;
  bool hasHornSoundStopped = false;
  int baseDamage = (30 + (UserManager.instance.user.level * 4)) * (UserManager.instance.user.level >= 25 ? 2 : 1);
  double bonusDamage = 0;
  double damageMultiplier = 0;
  double spellDamage = 0; //Ability Damage
  double spellAmp = 0;
  double dps = 0; //Damage Per Seconds
  double averageDps = 0;
  double maxDps = 0;
  double physicalDamage = 0;
  double physicalPercentage = 0;
  double magicalDamage = 0;
  double magicalPercentage = 0;
  List<double> last5AttackDamage = [];
  //

  //Circle Values
  int roundUnit = Bosses.values.length;
  int healthUnit = 60;
  int timeUnits = 180;
  int roundProgress = -1;
  double healthProgress = 0;
  double timeProgress = 0;
  //

  //Boss Values
  final bossList = Bosses.values;
  Bosses currentBoss = Bosses.values.first;
  bool currentBossAlive = false;
  double currentBossHp = 0;
  bool isWraithKingReincarnated = false;

  ///--- Snap Boss ---///
  ///Boss shattering effect upon boss's death
  final snappableKey = GlobalKey<SnappableState>();
  bool snapIsDone = true;
  void changeSnapStatus () {
    snapIsDone = !snapIsDone;
    updateView();
  }

  Future<void> snapBoss() async {
    changeSnapStatus();
    await snappableKey.currentState?.snap();
    await Future.delayed(const Duration(milliseconds: 3000));
    changeSnapStatus();
    snappableKey.currentState?.reset();
  }
  //

  ///-----     Mana Bar Values     -----///
  double maxMana = (UserManager.instance.user.level * 27) + 1400 + (UserManager.instance.user.level >= 10 ? 400 : 0);
  double currentMana = 1400 + UserManager.instance.user.level * 27;
  double baseManaRegen = 3.6 + UserManager.instance.user.level * 0.27;
  double manaRegenMultiplier = 0;
  double get manaRegen => baseManaRegen + (baseManaRegen * manaRegenMultiplier);
  double get manaBarWidthMultiplier => ((currentMana / maxMana) * 100) / 100;

  ///Increases the player's current mana by the base mana regeneration rate per second.
  ///
  ///If the current mana is greater than the total mana, it sets currentMana to maxMana.
  ///
  ///this function is called inside the [_timer] object
  void _manaRegenFn() {
    if (currentMana < maxMana) {
      currentMana += baseManaRegen + (baseManaRegen * manaRegenMultiplier);
      if (currentMana > maxMana) {
        currentMana = maxMana;
      }
    }
  }

  ///Decreases the player's current mana by the specified amount.
  ///
  ///[val] The amount of mana to be spent.
  void _spendMana(double val) {
    currentMana -= val;
  }
  
  void _addMana(double val) {
    currentMana += val;
    if (currentMana > maxMana) {
      currentMana = maxMana;
    }
  }
  ///-----     End Mana Bar Values     -----///

  ///-----     Inventory - Items     -----///
  
  int _userGold = 1000;
  int get userGold => _userGold;
  int get gainedGold => ((getRemainingTime ~/ 8) * (roundProgress+1)) + ((roundProgress+1) * 460) + 400;

  bool isAdWatched = false;
  void addGoldAfterWatchingAd(int goldAmount) {
    _addGold(goldAmount);
    isAdWatched = true;
    notifyListeners();
  }

  void _addGold(int val) {
    _userGold += val;
    SoundManager.instance.playItemSellingSound();
  }

  void _spendGold(int val) {
    _userGold -= val;
    SoundManager.instance.playItemBuyingSound();
  }

  final List<Item> _inventory = [];
  List<Item> get inventory => _inventory;

  bool _isActiveMidas = false;
  final int midasGold = 360;
  void _handOfMidasFn() {
    if (_isActiveMidas) {
      _addGold(midasGold);
      SoundManager.instance.playItemSound(Items.Hand_of_midas.name);
    }
  }

  void addItemToInventory(Item item) {
    _inventory.add(item);
    _buyItem(item);
    _spendGold(item.item.cost);
    currentMana = maxMana;
    updateView();
  }
  
  void removeItemToInventory(Item item) {
    _inventory.remove(item);
    _sellItem(item);
    _addGold((item.item.cost * 0.75).toInt());
    currentMana = maxMana;
    updateView();
  }

  void _buyItem(Item item) {
    switch (item.item) {
      case Items.Null_talisman:
        baseManaRegen += 0.80;
        maxMana += 60;
        break;
      case Items.Void_stone:
        baseManaRegen += 2.25;
        break;
      case Items.Arcane_boots:
        maxMana += 250;
        break;
      case Items.Power_treads:
        maxMana += 100;
        bonusDamage += 10;
        break;
      case Items.Phase_boots:
        bonusDamage += 16;
        break;
      case Items.Veil_of_discord: break;
      case Items.Kaya:
        spellAmp += 0.08;
        manaRegenMultiplier += 0.24;
        break;
      case Items.Aether_lens:
        baseManaRegen += 3;
        maxMana += 300;
        break;
      case Items.Meteor_hammer:
        baseManaRegen += 2.75;
        break;
      case Items.Hand_of_midas:
        _isActiveMidas = true;
        break;
      case Items.Vladmirs_offering:
        damageMultiplier += 0.24;
        break;
      case Items.Ethereal_blade:
        final len = _inventory.where((element) => element.item == Items.Ethereal_blade).toList().length;
        if (len < 2){
          spellAmp += 0.16;
          manaRegenMultiplier += 0.72;
          maxMana += 400;
        }
        break;
      case Items.Monkey_king_bar:
        bonusDamage += 36;
        break;
      case Items.Refresher_orb:
        baseManaRegen += 7;
        break;
      case Items.Daedalus:
        bonusDamage += 56;
        break;
      case Items.Eye_of_skadi:
        maxMana += 1600;
        break;
      case Items.Bloodthorn:
        bonusDamage += 40;
        maxMana += 400;
        baseManaRegen += 4;
        break;
      case Items.Dagon: break;
      case Items.Divine_rapier:
        bonusDamage += 128;
        break;
    }
  }

  void _sellItem(Item item) {
    switch (item.item) {
      case Items.Null_talisman:
        baseManaRegen -= 0.80;
        maxMana -= 60;
        break;
      case Items.Void_stone:
        baseManaRegen -= 2.25;
        break;
      case Items.Arcane_boots:
        maxMana -= 250;
        break;
      case Items.Power_treads:
        maxMana -= 100;
        bonusDamage -= 10;
        break;
      case Items.Phase_boots:
        bonusDamage -= 16;
        break;
      case Items.Veil_of_discord: break;
      case Items.Kaya:
        spellAmp -= 0.08;
        manaRegenMultiplier -= 0.24;
        break;
      case Items.Aether_lens:
        baseManaRegen -= 3;
        maxMana -= 300;
        break;
      case Items.Meteor_hammer:
        baseManaRegen -= 2.75;
        break;
      case Items.Hand_of_midas:
        final bool itemHasInventory = _inventory.any((element) => element.item == Items.Hand_of_midas);
        if (!itemHasInventory) {
          _isActiveMidas = false;
        }
        break;
      case Items.Vladmirs_offering:
        damageMultiplier -= 0.24;
        break;
      case Items.Ethereal_blade:
        final bool itemHasInventory = _inventory.any((element) => element.item == Items.Ethereal_blade);
        if (!itemHasInventory){
          spellAmp -= 0.16;
          manaRegenMultiplier -= 0.72;
          maxMana -= 400;
        }
        break;
      case Items.Monkey_king_bar:
        bonusDamage -= 36;
        break;
      case Items.Refresher_orb:
        baseManaRegen -= 7;
        break;
      case Items.Daedalus:
        bonusDamage -= 56;
        break;
      case Items.Eye_of_skadi:
        maxMana -= 1600;
        break;
      case Items.Bloodthorn:
        bonusDamage -= 40;
        maxMana -= 400;
        baseManaRegen -= 4;
        break;
      case Items.Dagon: break;
      case Items.Divine_rapier:
        bonusDamage -= 128;
        break;
    }
  }

  void onPressedItem(Item item) async {
    if (!started) { // If the started variable is false, play a meep merp sound and return from the function.
      SoundManager.instance.playMeepMerp();
      return;
    }
    final bool isItemUsed = item.onPressedItem(currentMana);
    if (isItemUsed) {
      _spendMana(item.item.mana ?? 0);
      if (item.item.hasSound) {
        SoundManager.instance.playItemSound(item.item.name);
      }
      updateView();
      switch (item.item) {
        case Items.Null_talisman:
        case Items.Void_stone:
        case Items.Power_treads:
        case Items.Phase_boots:
        case Items.Kaya:
        case Items.Aether_lens:
        case Items.Hand_of_midas:
        case Items.Vladmirs_offering:
        case Items.Monkey_king_bar:
        case Items.Daedalus:
        case Items.Eye_of_skadi:
        case Items.Divine_rapier:
        case Items.Bloodthorn:
          break;
        case Items.Arcane_boots:
          _addMana(175);
          break;
        case Items.Veil_of_discord:
          spellAmp += 0.20;
          await Future.delayed(Duration(seconds: item.item.duration?.toInt() ?? 0), () => spellAmp -= 0.20,);
          break;
        case Items.Meteor_hammer:
          spellDamage += 100;
          await Future.delayed(Duration(seconds: item.item.duration?.toInt() ?? 0), () => spellDamage -= 100,);
          break;
        case Items.Ethereal_blade:
          spellAmp += 0.40;
          await Future.delayed(Duration(seconds: item.item.duration?.toInt() ?? 0), () => spellAmp -= 0.40,);
          break;
        case Items.Refresher_orb:
          _resetCooldowns(withRefresherOrb: false);
          break;
        case Items.Dagon:
          spellDamage += 3200;
          await Future.delayed(Duration(seconds: item.item.duration?.toInt() ?? 0), () => spellDamage -= 3200,);
          break;
      }
      updateView();
    }
  }


  ///-----     End Inventory - Items     -----///



  //F-D Keys Casted Abilities
  //Creates a list of AbilityCooldown objects to hold the abilities casted with the F and D keys.
  final List<AbilityCooldown> _castedAbility = [];
  List<AbilityCooldown> get castedAbility => _castedAbility;

  ///Adds the selected ability to the castedAbility list and removes the old ability if it exists.
  ///
  ///If two abilities with the same combine property follow each other, the second one is not added.
  ///
  ///[abilityCooldown] An AbilityCooldown object representing the used ability.
  void switchAbility(AbilityCooldown abilityCooldown) {
    if (_castedAbility.isNotEmpty && abilityCooldown.spell.combine == _castedAbility.first.spell.combine) return;
    _castedAbility.insert(0, abilityCooldown);
    while (_castedAbility.length > 2) {
      _castedAbility.removeLast();
    }
    updateView();
  }

  //Creates a list of AbilityCooldown objects, each corresponding to a spell in the Spells enum.
  //Return A list of AbilityCooldown objects representing spell cooldowns.
  List<AbilityCooldown> spellCooldowns = Spells.values.map((e) => AbilityCooldown(spell: e)).toList();

  //Executed when a spell button is pressed.
  void onPressedAbility(Spells spell) async {
    if (!started) { // If the started variable is false, play a meep merp sound and return from the function.
      SoundManager.instance.playMeepMerp();
      return;
    }
    final index = Spells.values.indexOf(spell); // Gets the index number of the selected spell.
    final bool spellUsed = spellCooldowns[index].onPressedAbility(currentMana); // Checks if the selected spell can be used, and assigns true to the spellUsed variable if it can.
    if (spellUsed) { // If the selected spell was used
      _spendMana(spell.mana); // Mana is spent equal to the mana value of the chosen spell.
      final double abilityDamageMultiplier = spell.damage * (UserManager.instance.user.level * 0.02); //max level 0.6 - %60
      final double fullDamage = spell.damage + abilityDamageMultiplier;
      spellDamage += fullDamage; // Adds the spell damage to the spellDamage variable.
      updateView(); // Update the player's view.
      await Future.delayed(Duration(seconds: spell.duration), () => spellDamage -= fullDamage); // Wait for the spell's duration and subtract the spell damage from the spellDamage variable.
    }
  }
  //

  //-----     Game Functions    -----//

  ///Bu fonksiyon, karakter seviyesi arttığında baz hasar değerini ve manasını günceller.
  void _updateManaAndBaseDamage({bool updateUI = true}) {
    //Reset Values
    bonusDamage = 0;
    damageMultiplier = 0;
    manaRegenMultiplier = 0;
    spellAmp = 0;
    baseDamage = (30 + (UserManager.instance.user.level * 4)) * (UserManager.instance.user.level >= 25 ? 2 : 1);
    maxMana = (UserManager.instance.user.level * 27) + 1400 + (UserManager.instance.user.level >= 10 ? 400 : 0);
    baseManaRegen = 3.6 + UserManager.instance.user.level * 0.27;
    //Re-added item buffs
    for (final item in inventory) {
      _buyItem(item);
    }
    currentMana = maxMana;
    if (updateUI) {
      updateView();
    }
  }

  void _calcDPS() {
    final lastHit = dps;
    last5AttackDamage.insert(0, lastHit);
    if (last5AttackDamage.length > 5) {
      last5AttackDamage.removeLast();
    }
    final total = last5AttackDamage.fold<double>(0, (a, b) => a + b);
    averageDps = total/last5AttackDamage.length;
    if (maxDps < averageDps) maxDps = averageDps;
    dps = averageDps;
    _calcDamagePercentage();
  }

  void _calcDamagePercentage() {
    final double totalDamage = physicalDamage + magicalDamage;
    physicalPercentage = (physicalDamage / totalDamage) * 100;
    magicalPercentage = (magicalDamage / totalDamage) * 100;
  }

  /// This function is triggered to perform an auto-hit every second.
  /// ```dart
  /// double baseDamage = level * 5 + (0-15)
  /// ```
  /// The [health] variable is the quotient of the boss's health value divided by [healthUnit].
  /// 
  /// The [totalDamage] variable is the ratio of the base damage to the boss's health.
  /// 
  /// [healthProgress] is added as the boss's health reduction progress.
  /// 
  /// [dps] adds the damage per second as DPS.
  /// 
  /// [currentBossHp] is updated as the boss's new health value.
  /// 
  /// this function is called inside the [_timer] object
  void _autoHit(){
    final double fullDamage = (baseDamage+bonusDamage) + (damageMultiplier * (baseDamage+bonusDamage)) + rng.nextInt(16);
    final double health = currentBoss.getHp / healthUnit;
    final double totalDamage = fullDamage /health;
    healthProgress += totalDamage;
    physicalDamage += fullDamage;
    dps += fullDamage;
    currentBossHp = currentBoss.getHp - (healthProgress * health);
  }


  /// This function calculates the damage when a spell is used.
  /// ```dart
  /// double spellDamage = Spells.any.damage
  /// ```
  /// [damage] is the amount of damage itself, referred to as [spellDamage].
  /// 
  /// The [health] variable is the quotient of the boss's health value divided by [healthUnit].
  /// 
  /// The [totalDamage] variable is the ratio of the total damage to the boss's health.
  /// 
  /// [healthProgress] is added as the boss's health reduction progress.
  /// 
  /// [dps] adds the damage per second as DPS.
  /// 
  /// [currentBossHp] is updated as the boss's new health value.
  /// 
  ///this function is called inside the [_timer] object
  void _hitWithSpell() {
    final double damage = spellDamage + (spellDamage * spellAmp); //
    dps += damage;
    magicalDamage += damage;

    final double health = currentBoss.getHp / healthUnit;
    healthProgress += damage/health;
    currentBossHp = currentBoss.getHp - (healthProgress * health);
  }

  ///This function increments the time variable by one to increase the game time.
  ///
  ///this function is called inside the [_timer] object
  void _increaseTime() {
    timeProgress++;
    elapsedTime++;
  }

  ///This function prepares the game for the next round by setting various variables.
  Future<void> nextRound() async {
    if (!hornSoundPlayed) {
      SoundManager.instance.playHorn();
      isHornSoundPlaying = true;
      hornSoundPlayed = true;
      updateView();
      await Future.delayed(const Duration(seconds: 8));
      hasHornSoundStopped = true;
      isHornSoundPlaying = false;
    }
    if (hasHornSoundStopped == false) return;
    started = true;
    currentBossAlive = true;
    roundProgress++;
    currentBoss = bossList[roundProgress];
    currentBossHp = currentBoss.getHp;
    SoundManager.instance.playBossEnteringSound(currentBoss);
    healthProgress = 0;
    timeProgress = 0;
    elapsedTime = 0;
    last5AttackDamage.clear();
    maxDps = 0;
    physicalDamage = 0;
    physicalPercentage = 0;
    magicalDamage = 0;
    magicalPercentage = 0;
    isAdWatched = false;
    updateView();
  }

  ///is boss dead or time's up
  ///
  ///This expression queries whether the game should be terminated by checking,
  ///if either the boss is dead or the time limit has been reached, 
  ///both of which are termination conditions.
  ///
  ///this function is called inside the [_timer] object
  void _isGameFinished() async {
    if (healthProgress >= healthUnit) {
      if (currentBoss == Bosses.wraith_king && !isWraithKingReincarnated) {
        await wraithKingReincarnation();
        return;
      }
      log('Boss down');
      _timer?.cancel();
      _timer = null;
      started = false;
      currentBossHp = 0; // eksi değer göstermemesi için
      dps = 0;
      _addGold(gainedGold);
      await Future.delayed(const Duration(milliseconds: 100)); //snap işleminde 100 ms sonrasını baz almak için
      SoundManager.instance.playBossDyingSound(currentBoss);
      await snapBoss();
      currentBossAlive = false;
      _handOfMidasFn();
      updateView();
      _showRoundResultDialog();
      if (roundProgress+1 == Bosses.values.length)  _reset();
      return;
    }

    if (timeProgress >= timeUnits) {
      log('Time out');
      SoundManager.instance.playBossTauntSound(currentBoss);
      _showRoundResultDialog(timeUp: true);
      _reset();
      return;
    }
  }

  Future<void> wraithKingReincarnation() async {
    currentBossHp = 0;
    SoundManager.instance.playWkReincarnation();
    isWraithKingReincarnated = true;
    _timer?.cancel();
    _timer = null;
    started = false;
    await Future.delayed(const Duration(seconds: 3),() {
      healthProgress = 30;
      started = true;
      timerFn();
    });
  }

  void _showRoundResultDialog({bool timeUp = false}) {
    final model = BossRoundResultModel(
      uid: UserManager.instance.user.uid ?? 'null',
      name: UserManager.instance.user.username,
      round: roundProgress+1, 
      boss: currentBoss.name, 
      time: elapsedTime, 
      averageDps: averageDps, 
      maxDps: maxDps, 
      physicalDamage: physicalDamage, 
      magicalDamage: magicalDamage, 
      items: inventory.map((e) => e.item.getName).toList(),
    );

    if (currentBossHp <= 0) {
      UserManager.instance.updateBestBossTimeScore(currentBoss.name, elapsedTime, model);
    }
    AchievementManager.instance.updateBoss();
    AchievementManager.instance.updateMiscGold(userGold);
    if (currentBoss == Bosses.wraith_king && currentBossHp <= 0) {
      AchievementManager.instance.updateMiscKillWk();
    }
    if (currentBoss == Bosses.wraith_king || timeProgress >= timeUnits) {
      AchievementManager.instance.updatePlayedGame();
    }

    final int expGain = ((roundProgress+1) * 6) + (getRemainingTime ~/ 8);
    UserManager.instance.addExp(expGain);
    _updateManaAndBaseDamage();
    _resetCooldowns();

    final String lastBossText = roundProgress+1 == Bosses.values.length ? AppStrings.last : '';

    AppDialogs.showSlidingDialog(
      dismissible: false,
      showBackButton: false,
      height: 540,
      title: '${(roundProgress+1).getOrdinal()} $lastBossText${AppStrings.stageResults}',
      content: BossResultRoundDialogContent(
        model: model, 
        earnedGold: gainedGold + (_isActiveMidas ? midasGold : 0), 
        earnedExp: UserManager.instance.expCalc(expGain),
        timeUp: timeUp,
        isLast: model.round != Bosses.values.length,
        bossHpLeft: currentBossHp,
      ),
      action: BossResultRoundDialogAction(model: model),
    );
  }

  /// Function that starts the game. Creates a timer that repeats every second and initiates the game loop.
  // When the button that uses this function is clicked, it disappears until the next round.
  // Calculates the damage that the player deals to the bosses, manages the bosses' health, and the player's mana.
  // If the timer is already active, the function returns.
  // Also stops the timer depending on whether the boss is dead or the time is up.
  // Calls the updateView() function to update the display.
  void startGame() async {
    await nextRound();
    if (!hasHornSoundStopped) return;
    timerFn();
  }

  void timerFn() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      dps = 0;
      _increaseTime();
      _autoHit();
      _hitWithSpell();
      _calcDPS();
      _manaRegenFn();
      _isGameFinished();
      //if (!started) timer.cancel();
      updateView();
    });
  }

  ///Update listened variables
  void updateView() {
    notifyListeners();
  }

  ///Reset progress values
  void _reset() {
    _timer?.cancel();
    _timer = null;
    started = false;
    isHornSoundPlaying = false;
    hornSoundPlayed = false;
    hasHornSoundStopped = false;
    dps = 0;
    averageDps = 0;
    maxDps = 0;
    physicalDamage = 0;
    physicalPercentage = 0;
    magicalDamage = 0;
    magicalPercentage = 0;
    last5AttackDamage.clear();
    elapsedTime = 0;
    roundProgress = -1;
    healthProgress = 0;
    timeProgress = 0;
    _resetCooldowns();
    _castedAbility.clear();
    _inventory.clear();
    snapIsDone = true;
    currentBossAlive = false;
    currentBoss = Bosses.values.first;
    isWraithKingReincarnated = false;
    _updateManaAndBaseDamage(updateUI: false);
    _isActiveMidas = false;
    _userGold = 1000;
  }

  void _resetCooldowns({bool withRefresherOrb = true}) {
    for (final element in spellCooldowns) {
      element.resetCooldown();
    }
    if (withRefresherOrb) {
      for (final element in inventory) {
        element.resetCooldown();
      }
      return;
    }
    //refresher orb dışındaki bütün eşyaların cooldown'larını sıfırla
    for (final element in inventory) {
      final bool isItemRefresherOrb = element.item == Items.Refresher_orb;
      if (!isItemRefresherOrb) element.resetCooldown(); 
      else element.onPressedItem(currentMana); //fazladan refresher orb alınmışsa tıklanma fonksiyonunu çağırarak hepsini cooldown'a sok
    }}

  ///Resets the game values and stops the timer object. 
  ///Otherwise, when re-entering the mode, 
  ///it would continue to work with the old values, 
  ///and the timer would keep running in the background. 
  ///
  ///That's why we call this function in the dispose method of the view."
  /// ```dart
  /// late BossProvider provider;
  /// 
  ///@override
  ///void initState() {
  ///  provider = context.read<BossProvider>();
  ///  super.initState();
  ///}
  ///
  /// @override
  ///void dispose() {
  ///  provider.disposeGame(); //we used here
  ///  super.dispose();
  ///}
  /// ```
  void disposeGame() {
    _reset();
    if (_timer == null) return;
    _timer?.cancel();
    _timer = null;
  }

}
