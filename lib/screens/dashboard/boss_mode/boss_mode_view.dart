import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splash/splash.dart';
import 'package:tuple/tuple.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/locale_keys.g.dart';
import '../../../enums/elements.dart';
import '../../../enums/spells.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/string_extension.dart';
import '../../../extensions/widget_extension.dart';
import '../../../mixins/orb_mixin.dart';
import '../../../models/exit_dialog_message.dart';
import '../../../providers/boss_battle_provider.dart';
import '../../../services/sound_manager.dart';
import '../../../utils/game_save_handler.dart';
import '../../../utils/spell_combination_checker.dart';
import '../../../utils/value_notifier_listener.dart';
import '../../../widgets/app_dialogs.dart';
import '../../../widgets/app_outlined_button.dart';
import '../../../widgets/app_snackbar.dart';
import '../../../widgets/bouncing_button.dart';
import '../../../widgets/dialog_contents/load_game_dialog_content.dart';
import '../../../widgets/empty_box.dart';
import 'widgets/ability_slot.dart';
import 'widgets/attack_damage_widget.dart';
import 'widgets/background/background_sky.dart';
import 'widgets/background/background_weather.dart';
import 'widgets/boss_head.dart';
import 'widgets/circles/health_circle.dart';
import 'widgets/circles/round_circle.dart';
import 'widgets/circles/time_circle.dart';
import 'widgets/color_settings/color_settings_button.dart';
import 'widgets/dps_widget.dart';
import 'widgets/game_info/game_info_button.dart';
import 'widgets/inventory_hud.dart';
import 'widgets/mana_bar.dart';
import 'widgets/save_button.dart';
import 'widgets/shop/shop_button.dart';

class BossModeView extends StatefulWidget {
  const BossModeView({super.key});

  @override
  State<BossModeView> createState() => _BossModeViewState();
}

class _BossModeViewState extends State<BossModeView> with OrbMixin {
  late BossBattleProvider provider;

  @override
  void initState() {
    provider = context.read<BossBattleProvider>();
    provider.disposeGame();
    loadGameDialog();
    super.initState();
  }

  @override
  void dispose() {
    provider.disposeGame();
    super.dispose();
  }

  void loadGameDialog() async {
    await Future.microtask(() {});
    final savedGame = await GameSaveHandler.instance.loadGame();
    if (savedGame == null) return;
    AppSnackBar.showSnackBarMessage(
      text: LocaleKeys.snackbarMessages_sbLoadGameInfo.locale, 
      snackBartype: SnackBarType.info,
      duration: const Duration(seconds: 5),
    );
    AppDialogs.showSlidingDialog(
      height: 224,
      title: '${LocaleKeys.commonGeneral_loadGame.locale}?',
      content: LoadGameDialogContent(savedGame: savedGame), 
    );
  }


  void exitGameDialog() async { 
    if (context.read<BossBattleProvider>().roundProgress == -1 && mounted) {
      Navigator.pop(context);
      return;
    }
    final rndMessageNum = Random().nextInt(AppStrings.exitMessages.length);
    final message = AppStrings.exitMessages[rndMessageNum];
    final status = await AppDialogs.showSlidingDialog(
      dismissible: true,
      height: 352,
      title: message.title.locale,
      centerTitle: true,
      content: Column(
        children: [
          const EmptyBox.h12(),
          Text(
            message.body.locale,
            style: TextStyle(fontSize: context.sp(11)),
            textAlign: TextAlign.center,
          ),
          const EmptyBox.h32(),
          Text(
            message.word.locale,
            style: TextStyle(fontSize: context.sp(10)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      action: actButtons(message),
    );
    if (status == true && mounted) {
      Navigator.pop(context);
    }
  }

  Row actButtons(ExitDialogMessage message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        actButton(title: LocaleKeys.exitGameDialogMessages_yes.locale, callbackVal: true).wrapExpanded(),
        const EmptyBox.w8(),
        actButton(title: LocaleKeys.exitGameDialogMessages_no.locale,).wrapExpanded(),
      ],
    );
  }

  AppOutlinedButton actButton({required String title, dynamic callbackVal}) {
    return AppOutlinedButton(
      title: title,
      onPressed: () => Navigator.pop(context, callbackVal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (backButtonFn()) exitGameDialog();
          },
        ),
        actions: const [
          SaveButton(),
          GameInfoButton(),
          ColorSettingsButton(),
          ShopButton(),
        ],
      ),
      body: PopScope(
        canPop: false,
        child: bodyView(),
      ),
    );
  }

  bool backButtonFn() {
    final canPop = context.read<BossBattleProvider>().snapIsDone && !context.read<BossBattleProvider>().isHornSoundPlaying;
    if (!canPop) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      AppSnackBar.showSnackBarMessage(
        text: LocaleKeys.snackbarMessages_sbWaitAnimation.locale, 
        snackBartype: SnackBarType.info,
      );
    }
    return canPop;
  }

  Widget bodyView() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              const BackgroundSky(),
              /// -- Circles -- ///
              const HealthCircle(), //outer
              const RoundCircle(),  //middle
              const TimeCircle(),   //inner
              /// -- Circles End -- ///
              const BossHead(),
              const BackgroundWeather(),
              const DpsWidget(),
              const AttackDamageWidget(),
              startBtn(),
            ],
          ),
        ),
        selectedElementOrbs(),
        skills(),
        const EmptyBox.h12(),
        const ManaBar(),
        const EmptyBox.h8(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InventoryHud(),
            Expanded(child: AbilitySlot()),
          ],
        ),
        const EmptyBox.h16(),
        //
      ],
    );
  }

  Widget startBtn() {
    return Selector<BossBattleProvider, Tuple4<bool,bool,bool,bool>>(
      selector: (_, provider) => Tuple4(provider.started, provider.snapIsDone, provider.isHornSoundPlaying,  provider.isWraithKingReincarnated),
      builder: (_, value, __) {
        final bool status = value.item1 || !value.item2 || value.item4;
        return InkWell(
          splashFactory: WaveSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: () {
            if (status) return;
            provider.startGame();
          },
          child: SizedBox.expand(
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: status 
                ? const EmptyBox() 
                : Text(
                    value.item3 
                      ? LocaleKeys.commonGeneral_starting.locale 
                      : LocaleKeys.commonGeneral_start.locale,
                    style: const TextStyle(
                      fontSize: 20,
                      color: AppColors.amberAccent, 
                      fontFamily: 'Virgil', 
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),

            ),
          ),
        );
      },
    );
  }

  Widget selectedElementOrbs() {
    return SizedBox(
      width: context.dynamicWidth(0.25),
      height: context.dynamicHeight(0.08),
      child: ValueNotifierListener<List<Widget>>(
        valueNotifier: selectedOrbs,
        builder: (value) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: value,
        ),
      ),
    );
  }

  //QWER Ability Hud
  Row skills() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Elements.values.map((e) => skill(e).wrapPadding(const EdgeInsets.symmetric(horizontal: 8))).toList(),
    );
  }

  BouncingButton skill(Elements element) {
    return BouncingButton(
      child: Stack(
        children: [
          DecoratedBox(
            decoration: qwerAbilityDecoration(element.getColor),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Image.asset(
                element.getImage,
                width: context.dynamicWidth(0.18),
              ),
            ),
          ),
          Text(
            element.getKey.toUpperCase(),
            style: TextStyle(
              color: element.getColor,
              fontSize: context.sp(16),
              fontWeight: FontWeight.w500,
              shadows: List.generate(3, (index) => const Shadow(blurRadius: 8)),
            ),
          ).wrapPadding(const EdgeInsets.only(left: 2)),
        ],
      ),
      onPressed: () {
        switch (element) {
          case Elements.quas:
          case Elements.wex:
          case Elements.exort:
            return switchOrb(element);
          case Elements.invoke:
            SoundManager.instance.playInvoke();
            Spell? castedSpell;
            for(final spell in Spell.values) {
              if (SpellCombinationChecker.checkEquality(spell.combination, currentCombination)) {
                castedSpell = spell;
                break;
              }
            }
            if (castedSpell == null) {
              SoundManager.instance.playFailCastSound();
              return;
            }
            final index = Spell.values.indexOf(castedSpell);
            final spell = context.read<BossBattleProvider>().spellCooldowns[index];
            context.read<BossBattleProvider>().switchAbility(spell);
        }
      },
    );
  }

}
