// ignore_for_file: unnecessary_getters_setters

import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../constants/locale_keys.g.dart';
import '../enums/Bosses.dart';
import '../enums/items.dart';
import '../enums/spells.dart';
import '../models/Item.dart';
import '../models/ability.dart';
import '../models/score_models/boss_battle.dart';
import '../services/achievement_manager.dart';
import '../services/sound_manager.dart';
import '../utils/game_save_handler.dart';
import '../widgets/app_dialogs.dart';
import '../widgets/dialog_contents/boss_result_dialog_content.dart';
import '../services/user_manager.dart';

class BossBattleProvider extends ChangeNotifier {
  Timer? _timer;
  final rng = math.Random();

  //Boss Game Values
  int elapsedTime = 0;
  int get getRemainingTime => timeUnits - elapsedTime;
  bool started = false;
  bool isHornSoundPlaying = false;
  bool hornSoundPlayed = false;
  bool hasHornSoundStopped = false;
  int baseDamage = (40 + (UserManager.instance.user.level * 4)) * (UserManager.instance.user.level >= 25 ? 2 : 1);
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
  bool isSavingEnabled = false;
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
  double maxMana = (UserManager.instance.user.level * 27) + 1590 + (UserManager.instance.user.level >= 10 ? 400 : 0);
  double currentMana = 1590 + UserManager.instance.user.level * 27;
  double baseManaRegen = 3.9 + UserManager.instance.user.level * 0.27;
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
  set userGold(int gold) => _userGold = gold;
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

  final List<Item> _consumableItems = [];
  List<Item> get consumableItems => _consumableItems;
  ///Her Yeteneğe %6 hasar ekler + SS 2x damage
  bool get hasAghanimScepter => _consumableItems.any((element) => element.item == Items.Aghanims_scepter);
  ///EMP mana çalar
  bool get hasAghanimShard => _consumableItems.any((element) => element.item == Items.Aghanims_shard);

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
    item.item.consumable 
      ? _consumableItems.add(item) 
      : _inventory.add(item);
    _updateStats(item: item, isBuying: true); //buy item
    _spendGold(item.item.cost);
    currentMana = maxMana;
    updateView();
  }
  
  void removeItemToInventory(Item item) {
    _inventory.remove(item);
    _updateStats(item: item, isBuying: false); //sell item
    _addGold((item.item.cost * 0.75).toInt());
    currentMana = maxMana;
    updateView();
  }

  void _updateStats({required Item item, required bool isBuying}) {
    final itemBonus = item.item.bonuses;
    final int multiplier = isBuying ? 1 : -1;

    if (item.item == Items.Hand_of_midas) {
      final itemHasInventory = _inventory.any((element) => element.item == Items.Hand_of_midas);
      _isActiveMidas = itemHasInventory;
      return;
    } 
    else if (item.item == Items.Ethereal_blade) {
      final eBladeCount = _inventory.where((element) => element.item == Items.Ethereal_blade).length;
      final itemHasInventory = eBladeCount > 0;
      if ((eBladeCount > 1 && isBuying) || (!isBuying && itemHasInventory)) {
        return;
      }
    } 
    maxMana += itemBonus.mana * multiplier;
    baseManaRegen += itemBonus.manaRegen * multiplier;
    manaRegenMultiplier += itemBonus.manaRegenAmp * multiplier;
    bonusDamage += itemBonus.damage * multiplier;
    damageMultiplier += itemBonus.damageMultiplier * multiplier;
    spellAmp += itemBonus.spellAmp * multiplier;
  }

  void onPressedItem(Item item) async {
    if (!started) { // If the started variable is false, play a meep merp sound and return from the function.
      SoundManager.instance.playMeepMerp();
      return;
    }

    final bool isItemUsed = item.onPressed(currentMana);

    if (isItemUsed) {
      _spendMana(item.item.activeProps.manaCost ?? 0);

      if (item.item.hasSound) {
        SoundManager.instance.playItemSound(item.item.name);
      }

      if (item.item == Items.Arcane_boots) {
        _useArcaneBoots(item);
        return;
      } else if (item.item == Items.Refresher_orb) {
        _useRefresherOrb(item);
        return;
      }
      _modifyBonuses(item, true);
      await Future.delayed(
        Duration(seconds: item.item.activeProps.duration?.toInt() ?? 0), 
        () => _modifyBonuses(item, false),
      );
    }
  }

  void _useArcaneBoots(Item item) {
    _addMana(item.item.activeProps.activeBonuses.mana);
    updateView();
  }

  void _useRefresherOrb(Item item) {
    _resetCooldowns(withRefresherOrb: false);
    updateView();
  }

  void _modifyBonuses(Item item, bool apply) {
    final activeBonuses = item.item.activeProps.activeBonuses;

    final multiplier = apply ? 1 : -1;

    //bonusDamage += multiplier * activeBonuses.physicalDamage; // TODO: Orchid 1.5x damage bonusDamage yerine multiplier olabilir
    spellDamage += multiplier * activeBonuses.magicalDamage;
    spellAmp    += multiplier * activeBonuses.spellAmp;

    ///Boss öldükten sonra spellAmp _updateManaAndBaseDamage() fonksiyonunda sıfırlanıyor.
    ///Bu sebeble e.blade veil gibi itemlerin durationları bittikten sonra çıkarma işlemi yapıldığından eksiye düşüyor
    ///Bunun önüne geçmek için aşşağıdaki kodu yazdık
    if (spellAmp < cSpellAmp) {
      spellAmp = cSpellAmp;
    }
    updateView();
  }

  double cSpellAmp = 0;
  void calculateSpellAmp() {
    cSpellAmp = 0;
    for (final item in inventory) {
      cSpellAmp += item.item.bonuses.spellAmp;
    }
  }

  ///-----     End Inventory - Items     -----///



  //F-D Keys Casted Abilities
  //Creates a list of Ability objects to hold the abilities casted with the F and D keys.
  final List<Ability> _castedAbility = [];
  List<Ability> get castedAbility => _castedAbility;

  ///Adds the selected ability to the castedAbility list and removes the old ability if it exists.
  ///
  ///If two abilities with the same combine property follow each other, the second one is not added.
  ///
  ///[ability] An Ability object representing the used ability.
  void switchAbility(Ability ability) {
    if (_castedAbility.isNotEmpty && ability.spell.combination == _castedAbility.first.spell.combination) return;
    _castedAbility.insert(0, ability);
    while (_castedAbility.length > 2) {
      _castedAbility.removeLast();
    }
    updateView();
  }

  //Creates a list of Ability objects, each corresponding to a spell in the Spells enum.
  //Return A list of Ability objects representing spell cooldowns.
  List<Ability> spellCooldowns = Spell.values.map((e) => Ability(spell: e)).toList();

  //Executed when a spell button is pressed.
  void onPressedAbility(Spell spell) async {
    if (!started) { // If the started variable is false, play a meep merp sound and return from the function.
      SoundManager.instance.playMeepMerp();
      return;
    }
    final index = Spell.values.indexOf(spell); // Gets the index number of the selected spell.
    final bool isAbilityUsed = spellCooldowns[index].onPressed(currentMana); // Checks if the selected spell can be used, and assigns true to the isAbilityUsed variable if it can.
    if (isAbilityUsed) { // If the selected spell was used
      _spendMana(spell.mana); // Mana is spent equal to the mana value of the chosen spell.
      final double abilityDamageMultiplier = spell.damage * ((UserManager.instance.user.level + (hasAghanimScepter ? 1 : 0)) * 0.02); //max level 0.6 - %60
      double fullDamage = spell.damage + abilityDamageMultiplier;
      updateView(); // Update the player's view.
      await Future.delayed(spell.effectDelay);
      if (spell == Spell.emp && hasAghanimShard) {
        _addMana(225);
        updateView();
      } 
      else if (spell == Spell.sun_strike && hasAghanimScepter) {
        fullDamage *= 2;
      }
      spellDamage += fullDamage; // Adds the spell damage to the spellDamage variable.
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
    baseDamage = (40 + (UserManager.instance.user.level * 4)) * (UserManager.instance.user.level >= 25 ? 2 : 1);
    maxMana = (UserManager.instance.user.level * 27) + 1590 + (UserManager.instance.user.level >= 10 ? 400 : 0);
    baseManaRegen = 3.9 + UserManager.instance.user.level * 0.27;
    //Re-added item buffs
    for (final item in inventory) {
      _updateStats(item: item, isBuying: true);
    }
    for (final consumableItem in consumableItems) {
      _updateStats(item: consumableItem, isBuying: true);
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
    calculateSpellAmp();
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
      isSavingEnabled = true;
      if (roundProgress+1 == Bosses.values.length)  _reset();
      return;
    }

    if (timeProgress >= timeUnits) {
      log('Time out');
      SoundManager.instance.playBossTauntSound(currentBoss);
      _showRoundResultDialog(timeUp: true);
      GameSaveHandler.instance.deleteSavedGame();
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
    final model = BossBattle(
      uid: UserManager.instance.user.uid,
      name: UserManager.instance.user.username,
      round: roundProgress+1, 
      boss: currentBoss.getName, 
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

    final int expGain = ((roundProgress+1) * 5) + (getRemainingTime ~/ 10);
    UserManager.instance.addExp(expGain);
    _updateManaAndBaseDamage();
    _resetCooldowns();

    final String lastBossText = roundProgress+1 == Bosses.values.length ? LocaleKeys.commonGeneral_last.locale : '';

    AppDialogs.showSlidingDialog(
      dismissible: false,
      showBackButton: false,
      height: 540,
      title: '${roundProgress+1}. $lastBossText${LocaleKeys.commonGeneral_stageResults.locale}',
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
    isSavingEnabled = false;
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
    _consumableItems.clear();
    snapIsDone = true;
    currentBossAlive = false;
    currentBoss = Bosses.values.first;
    isWraithKingReincarnated = false;
    _updateManaAndBaseDamage(updateUI: false);
    _isActiveMidas = false;
    isSavingEnabled = false;
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
      else element.onPressed(currentMana); //fazladan refresher orb alınmışsa tıklanma fonksiyonunu çağırarak hepsini cooldown'a sokar
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
