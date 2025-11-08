import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../../constants/locale_keys.g.dart';
import '../../../../../enums/Bosses.dart';
import '../../../../../enums/spells.dart';
import '../../../../../extensions/string_extension.dart';
import '../../../../../services/user_manager.dart';
import '../../../../../utils/ads_helper.dart';
import '../../../../../widgets/empty_box.dart';
import 'neon_circle_painter.dart';
import 'neon_info_card.dart';
import 'neon_section_title.dart';

class GameInfoView extends StatefulWidget {
  const GameInfoView({super.key});

  @override
  State<GameInfoView> createState() => _GameInfoViewState();
}

class _GameInfoViewState extends State<GameInfoView> {
  Bosses get _getRandomBoss {
    final random = Random();
    const bosses = Bosses.values;
    return bosses[random.nextInt(bosses.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _bodyView(),
      // body: Container(
      //   width: double.maxFinite,
      //   height: double.maxFinite,
      //   decoration: _bodyDecoration(),
      //   child: _bodyView(),
      // ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        LocaleKeys.bossBattleInfo_aboutTheGame.locale,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.arrow_back, size: 20),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  // BoxDecoration _bodyDecoration() {
  //   return BoxDecoration(
  //     gradient: LinearGradient(
  //       begin: Alignment.topCenter,
  //       end: Alignment.bottomCenter,
  //       colors: [
  //         const Color(0xFF1F1B24),
  //         Colors.black.withBlue(40),
  //       ],
  //     ),
  //   );
  // }

  Widget _bodyView() {
    return SafeArea(
      child: Column(
        children: [
          const AdBanner(adSize: AdSize.fullBanner),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  NeonSectionTitle(
                    title: LocaleKeys.bossBattleInfo_circlesMeaning.locale.toUpperCase(),
                    icon: Icons.radio_button_checked,
                    color: Colors.purpleAccent,
                  ),
                  const EmptyBox.h16(),
                  /// Circles With Boss Head
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const CustomPaint(
                        painter: NeonCirclesPainter(),
                        size: Size.square(220),
                      ),
                      Image.asset(_getRandomBoss.getImage, height: 80),
                    ],
                  ),
                  const EmptyBox.h24(),
                  NeonInfoCard(
                    color: Colors.red, 
                    title: LocaleKeys.ColorPicker_CircleLabels_outer.locale, 
                    description: LocaleKeys.bossBattleInfo_outerCircleInfo.locale,
                    icon: Icons.favorite,
                  ),
                  const EmptyBox.h12(),
                  NeonInfoCard(
                    color: Colors.amber, 
                    title: LocaleKeys.ColorPicker_CircleLabels_middle.locale, 
                    description: LocaleKeys.bossBattleInfo_middleCircleInfo.locale,
                    icon: Icons.refresh,
                  ),
                  const EmptyBox.h12(),
                  NeonInfoCard(
                    color: Colors.green, 
                    title: LocaleKeys.ColorPicker_CircleLabels_inner.locale, 
                    description: LocaleKeys.bossBattleInfo_innerCircleInfo.locale,
                    icon: Icons.hourglass_bottom,
                  ),
                  const EmptyBox.h12(),
                  NeonInfoCard(
                    color: Colors.blue, 
                    title: LocaleKeys.bossBattleInfo_roundInfoTitle.locale, 
                    description: LocaleKeys.bossBattleInfo_roundInfoDesc.locale,
                    icon: Icons.timer,
                  ),
                  const EmptyBox.h32(),
                  NeonSectionTitle(
                    title: LocaleKeys.bossBattleInfo_spellDamageSheet.locale.toUpperCase(),
                    icon: Icons.auto_fix_high,
                    color: Colors.tealAccent,
                  ),
                  const EmptyBox.h16(),
                  NeonInfoCard(
                    color: Colors.tealAccent, 
                    title: LocaleKeys.bossBattleInfo_noteTitle.locale, 
                    description: LocaleKeys.bossBattleInfo_noteDesc.locale,
                    icon: Icons.trending_up,
                  ),
                  const EmptyBox.h16(),
                  const SpellTable(),
                  const EmptyBox.h32(),
                ],
              ),
            ),
          ),
          const AdBanner(adSize: AdSize.fullBanner),
        ],
      ),
    );
  }

}

class SpellTable extends StatelessWidget {
  const SpellTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              SpellTableHeader(text: LocaleKeys.bossBattleInfo_spell.locale, flex: 2),
              SpellTableHeader(text: LocaleKeys.bossBattleInfo_dps.locale, flex: 3),
              SpellTableHeader(text: LocaleKeys.bossBattleInfo_duration.locale, flex: 3),
              SpellTableHeader(text: LocaleKeys.bossBattleInfo_totalBaseDamage.locale, flex: 4),
              SpellTableHeader(text: LocaleKeys.bossBattleInfo_currentTotalDamage.locale, flex: 4),
            ],
          ),
        ),
        const EmptyBox.h8(),
        ...Spell.values.map((spell) => SpellItem(
          spellName: spell.name,
          spellColor: spell.spellColor, 
          spellImage: spell.image, 
          sbh: spell.duration == 1 ? '-' : spell.damage.toStringAsFixed(0), 
          sure: spell.duration == 1 ? '-' : spell.duration.toString(), 
          tabanHasar: (spell.damage * spell.duration).toStringAsFixed(0), 
          mevcutHasar: ((spell.damage*spell.duration) + ((spell.damage*spell.duration) * UserManager.instance.user.level * 0.02)).toStringAsFixed(0),
        ),),
      ],
    );
  }
}

class SpellTableHeader extends StatelessWidget {
  const SpellTableHeader({super.key, required this.text, required this.flex});

  final String text;
  final int flex;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.tealAccent.shade100,
        ),
      ),
    );
  }
}

class SpellItem extends StatelessWidget {
  const SpellItem({
    super.key, 
    required this.spellName, 
    required this.spellColor, 
    required this.spellImage, 
    required this.sbh, 
    required this.sure, 
    required this.tabanHasar, 
    required this.mevcutHasar,
  });

  final String spellName;
  final Color spellColor;
  final String spellImage;
  final String sbh;
  final String sure;
  final String tabanHasar;
  final String mevcutHasar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: spellColor.withValues(alpha: 0.32),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: spellColor.withValues(alpha: 0.32),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image(image: AssetImage(spellImage)),
              ),
            ),
          ),
          
          // SBH
          Expanded(
            flex: 3,
            child: Text(
              sbh,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          
          // Süre
          Expanded(
            flex: 3,
            child: Text(
              sure,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          
          // Taban Hasar
          Expanded(
            flex: 4,
            child: Text(
              tabanHasar,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          
          // Mevcut Hasar
          Expanded(
            flex: 4,
            child: Text(
              mevcutHasar,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: spellColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
