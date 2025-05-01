// import 'package:flutter/material.dart';
// import 'package:dota2_invoker_game/services/sound_manager.dart';
// import 'package:dota2_invoker_game/enums/spells.dart';

// import 'enums/Bosses.dart';

// class SoundTestPage extends StatelessWidget {
//   const SoundTestPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const bossList = Bosses.values;
//     const spellList = Spell.values;

//     return Scaffold(
//       appBar: AppBar(title: const Text('🔊 Sound Test Menu')),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _buildSectionTitle('Spells'),
//           ...spellList.map((s) => _buildButton(s.name.toUpperCase(), () {
//                 SoundManager.instance.spellCastTriggerSound(s);
//               }),),

//           const SizedBox(height: 16),
//           _buildSectionTitle('Generic Sounds'),
//           _buildButton('Cooldown', SoundManager.instance.playCooldownSound),
//           _buildButton('No Mana', SoundManager.instance.playNoManaSound),
//           _buildButton('Fail Combo', SoundManager.instance.playFailCastSound),
//           _buildButton('Game Over', SoundManager.instance.playGameOverSound),
//           _buildButton('Invoke', SoundManager.instance.playInvoke),
//           _buildButton('Meep Merp', SoundManager.instance.playMeepMerp),
//           _buildButton('Loading', SoundManager.instance.playLoadingSound),

//           const SizedBox(height: 16),
//           _buildSectionTitle('Shop Sounds'),
//           _buildButton('Enter Shop', SoundManager.instance.playShopEnterSound),
//           _buildButton('Exit Shop', SoundManager.instance.playShopExitSound),
//           _buildButton('Buy Item', SoundManager.instance.playItemBuySound),
//           _buildButton('Sell Item', SoundManager.instance.playItemSellSound),
//           _buildButton('Play Tango', () => SoundManager.instance.playItemSound('tango')), //TODO:

//           const SizedBox(height: 16),
//           _buildSectionTitle('Boss Sounds'),
//           ...bossList.map((b) => _buildBossRow(b)),

//           const SizedBox(height: 16),
//           _buildSectionTitle('Specials'),
//           _buildButton('Persona Select Sound', SoundManager.instance.playPersonaPickedSound),
//           _buildButton('Wraith King Reincarnation', SoundManager.instance.playWraithKingReincarnation),
//         ],
//       ),
//     );
//   }

//   Widget _buildBossRow(Bosses boss) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(boss.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: [
//             _buildMiniButton('Enter', () => SoundManager.instance.playBossEnteringSound(boss)),
//             _buildMiniButton('Die', () => SoundManager.instance.playBossDeathSound(boss)),
//             _buildMiniButton('Taunt', () => SoundManager.instance.playBossTauntSound(boss)),
//           ],
//         ),
//         const Divider(),
//       ],
//     );
//   }

//   Widget _buildButton(String text, VoidCallback onTap) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: ElevatedButton(
//         onPressed: onTap,
//         child: Text(text),
//       ),
//     );
//   }

//   Widget _buildMiniButton(String label, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
//       child: Text(label),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Text(
//         title,
//         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
//       ),
//     );
//   }
// }


/*

import 'package:dota2_invoker_game/enums/spells.dart';
import 'package:flutter/material.dart';
import '../enums/Bosses.dart';
import '../services/sound_manager.dart';
import '../extensions/string_extension.dart';
import 'services/sound_player/audioplayer_wrapper.dart';
import 'services/sound_player/soloud_wrapper.dart';

class SoundTestPage extends StatefulWidget {
  const SoundTestPage({super.key});

  @override
  State<SoundTestPage> createState() => _SoundTestPageState();
}

class _SoundTestPageState extends State<SoundTestPage> {
  final SoundManager _soundManager = SoundManager.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ses Test Sayfası'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text('Genel Sesler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ElevatedButton(onPressed: _soundManager.playInvoke, child: const Text('Invoke')),
            ElevatedButton(onPressed: _soundManager.playMeepMerp, child: const Text('Meep Merp')),

            const SizedBox(height: 20),
            const Text('Büyü Sesleri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ...Spell.values.map((spell) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () => _soundManager.playSpellSound(spell),
                      child: Text('${spell.name.toSpacedTitle()} Oynat'),
                    ),
                    ElevatedButton(
                      onPressed: () => _soundManager.spellCastTriggerSound(spell),
                      child: Text('${spell.name.toSpacedTitle()} Cast Tetikle'),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),
            const Text('Invoker Cevap Sesleri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ElevatedButton(onPressed: _soundManager.playFailCastSound, child: const Text('Başarısız Cast')),
            ElevatedButton(onPressed: _soundManager.playGameOverSound, child: const Text('Oyun Bitti')),
            ElevatedButton(onPressed: _soundManager.playLoadingSound, child: const Text('Yükleniyor')),
            ElevatedButton(onPressed: _soundManager.playCooldownSound, child: const Text('Cooldown')),
            ElevatedButton(onPressed: _soundManager.playNoManaSound, child: const Text('Mana Yok')),
            ElevatedButton(onPressed: _soundManager.playPersonaPickedSound, child: const Text('Persona Seçildi')),

            const SizedBox(height: 20),
            const Text('Eşya & Dükkan Sesleri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ElevatedButton(onPressed: () => _soundManager.playItemSound('branches'), child: const Text('Item Branches Oynat')),
            ElevatedButton(onPressed: _soundManager.playItemBuySound, child: const Text('Eşya Satın Al')),
            ElevatedButton(onPressed: _soundManager.playItemSellSound, child: const Text('Eşya Sat')),
            ElevatedButton(onPressed: _soundManager.playShopEnterSound, child: const Text('Dükkana Gir')),
            ElevatedButton(onPressed: _soundManager.playShopExitSound, child: const Text('Dükkandan Çık')),

            const SizedBox(height: 20),
            const Text('Boss Sesleri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ElevatedButton(onPressed: _soundManager.playHorn, child: const Text('Boynuz Çal')),
            ...Bosses.values.map((boss) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(boss.getReadableName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: () => _soundManager.playBossEnteringSound(boss),
                      child: const Text('Giriş Sesi Çal'),
                    ),
                    ElevatedButton(
                      onPressed: () => _soundManager.playBossDeathSound(boss),
                      child: const Text('Ölüm Sesi Çal'),
                    ),
                    ElevatedButton(
                      onPressed: () => _soundManager.playBossTauntSound(boss),
                      child: const Text('Alay Sesi Çal'),
                    ),
                    if (boss == Bosses.wraith_king)
                      ElevatedButton(
                        onPressed: _soundManager.playWraithKingReincarnation,
                        child: const Text('Diriliş Sesi Çal'),
                      ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),
            const Text('Ses Ayarları', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Row(
              children: [
                const Text('Ses Seviyesi: '),
                Expanded(
                  child: Slider(
                    value: _soundManager.appVolume,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${_soundManager.appVolume.round()}',
                    onChanged: (double value) {
                      setState(() {
                        _soundManager.setVolume(value);
                      });
                    },
                  ),
                ),
                Text('${_soundManager.appVolume.round()}%'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Ses Motoru Seçimi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _soundManager.switchPlayer(SoLoudWrapper.instance);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('SoLoud motoruna geçildi.')),
                    );
                  },
                  child: const Text('SoLoud'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _soundManager.switchPlayer(AudioPlayerWrapper.instance);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('AudioPlayer motoruna geçildi.')),
                    );
                  },
                  child: const Text('AudioPlayer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



*/
