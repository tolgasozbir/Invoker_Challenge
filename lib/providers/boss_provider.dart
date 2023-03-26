import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import 'package:dota2_invoker_game/enums/Bosses.dart';
import 'package:dota2_invoker_game/enums/spells.dart';

import '../models/ability_cooldown.dart';
import '../services/sound_manager.dart';
import 'user_manager.dart';

class BossProvider extends ChangeNotifier {
  Timer? _timer;
  final rng = math.Random();

  //Boss Game Values
  bool started = false;
  double get baseDamage => UserManager.instance.user.level * 5 + rng.nextDouble() * 16;
  double dps = 0; //Damage Per Seconds
  double spellDamage = 0; //Ability Damage
  //

  //Circle Values
  int get roundUnit => Bosses.values.length;
  int get healthUnit => 60;
  int get timeUnits => 180;
  int roundProgress = -1;
  double healthProgress = 0;
  double timeProgress = 0;
  //

  //Boss Values
  final bossList = Bosses.values;
  var currentBoss = Bosses.values.first;
  bool currentBossAlive = false;
  double currentBossHp = 0;

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
    await Future.delayed(Duration(milliseconds: 3000));
    changeSnapStatus();
  }
  //

  ///-----     Mana Bar Values     -----///
  final double totalMana = 200 + UserManager.instance.user.level * 67;
  double currentMana = 200 + UserManager.instance.user.level * 67;
  final double baseManaRegen = UserManager.instance.user.level * 0.27;
  double get manaBarWidthMultiplier => ((currentMana / totalMana) * 100) / 100;

  ///Increases the player's current mana by the base mana regeneration rate per second.
  ///
  ///If the current mana is greater than the total mana, it sets currentMana to totalMana.
  ///
  ///this function is called inside the [_timer] object
  void _manaRegenFn() {
    if (currentMana < totalMana) {
      currentMana += baseManaRegen;
      if (currentMana > totalMana) {
        currentMana = totalMana;
      }
    }
  }

  ///Decreases the player's current mana by the specified amount.
  ///
  ///[val] The amount of mana to be spent.
  _spendMana(double val) {
    currentMana -= val;
  }
///-----     End Mana Bar Values     -----///


  //F-D Keys Casted Abilities
  //Creates a list of AbilityCooldown objects to hold the abilities casted with the F and D keys.
  List<AbilityCooldown> _castedAbility = [];
  List<AbilityCooldown> get castedAbility => _castedAbility;

  ///Adds the selected ability to the castedAbility list and removes the old ability if it exists.
  ///
  ///If two abilities with the same combine property follow each other, the second one is not added.
  ///
  ///[abilityCooldown] An AbilityCooldown object representing the used ability.
  void switchAbility(AbilityCooldown abilityCooldown) {
    if (_castedAbility.length > 1 && abilityCooldown.spell.combine == _castedAbility.first.spell.combine) return;
    _castedAbility.insert(0, abilityCooldown);
    while (_castedAbility.length > 2) {
      _castedAbility.removeLast();
    }
    updateView();
  }

  //Creates a list of AbilityCooldown objects, each corresponding to a spell in the Spells enum.
  //Return A list of AbilityCooldown objects representing spell cooldowns.
  List<AbilityCooldown> SpellCooldowns = Spells.values.map((e) => AbilityCooldown(spell: e)).toList();

  //Executed when a spell button is pressed.
  void onPressedAbility(Spells spell) async {
    if (!started) { // If the started variable is false, play a meep merp sound and return from the function.
      SoundManager.instance.playMeepMerp();
      return;
    }
    var index = Spells.values.indexOf(spell); // Gets the index number of the selected spell.
    var spellUsed = SpellCooldowns[index].onPressedAbility(currentMana); // Checks if the selected spell can be used, and assigns true to the spellUsed variable if it can.
    if (spellUsed) { // If the selected spell was used
      _spendMana(spell.mana); // Mana is spent equal to the mana value of the chosen spell.
      spellDamage += spell.damage; // Adds the spell damage to the spellDamage variable.
      updateView(); // Update the player's view.
      spell.duration == 0 // If the spell has no effect;
        ? await Future.delayed(Duration(seconds: 1), () => spellDamage -= spell.damage) // Wait for a second and subtract the spell damage from the spellDamage variable.
        : await Future.delayed(Duration(seconds: spell.duration), () => spellDamage -= spell.damage); // Wait for the spell's duration and subtract the spell damage from the spellDamage variable.
    }
  }
  //

  //-----     Game Functions    -----//

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
    var health = currentBoss.getHp / healthUnit;
    var totalDamge = baseDamage/health;
    healthProgress += totalDamge;
    dps += baseDamage;
    currentBossHp = currentBoss.getHp - (healthProgress * health);
    //print(currentBoss.name + " Hp : " + (currentBoss.getHp - (healthProgress * health)).toStringAsFixed(0));
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
  void _hitWithSpell(double damage) {
    var health = currentBoss.getHp / healthUnit;
    var totalDamge = damage/health;
    healthProgress += totalDamge;
    dps += damage;
    currentBossHp = currentBoss.getHp - (healthProgress * health);
  }

  ///This function increments the time variable by one to increase the game time.
  ///
  ///this function is called inside the [_timer] object
  void _increaseTime() {
    timeProgress++;
  }

  ///This function prepares the game for the next round by setting various variables.
  void nextRound() {
    started = true;
    currentBossAlive = true;
    snappableKey.currentState?.reset();
    roundProgress++;
    currentBoss = bossList[roundProgress];
    currentBossHp = currentBoss.getHp;
    healthProgress = 0;
    timeProgress = 0;
    currentMana = totalMana;
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
      log("Boss down");
      _timer?.cancel();
      _timer = null;
      started = false;
      currentBossHp = 0; // eksi değer göstermemesi için
      dps = 0;
      await Future.delayed(Duration(milliseconds: 100)); //snap işleminde 100 ms sonrasını baz almak için
      await snapBoss();
      currentBossAlive = false;
      updateView();
      return;
    }

    if (timeProgress >= timeUnits) {
      log("Time out");
      _timer?.cancel();
      started = false;
      return;
    }
  }

  /// Function that starts the game. Creates a timer that repeats every second and initiates the game loop.
  // When the button that uses this function is clicked, it disappears until the next round.
  // Calculates the damage that the player deals to the bosses, manages the bosses' health, and the player's mana.
  // If the timer is already active, the function returns.
  // Also stops the timer depending on whether the boss is dead or the time is up.
  // Calls the updateView() function to update the display.
  void startGame() {
    nextRound();
    if (_timer != null) return;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      dps = 0;
      _increaseTime();
      _autoHit();
      _hitWithSpell(spellDamage);
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
    started = false;
    dps = 0;
    roundProgress = -1;
    healthProgress = 0;
    timeProgress = 0;
    _castedAbility.clear();
    snapIsDone = true;
    currentBossAlive = false;
    currentBoss = Bosses.values.first;
    currentMana = totalMana;
  }

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