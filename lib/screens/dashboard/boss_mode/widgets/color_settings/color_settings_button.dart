import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/boss_battle_provider.dart';
import '../../../../../services/sound_manager.dart';
import 'circle_color_customizer.dart';

class ColorSettingsButton extends StatelessWidget {
  const ColorSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final isClickable = !context.read<BossBattleProvider>().started && 
                             context.read<BossBattleProvider>().snapIsDone && 
                            !context.read<BossBattleProvider>().isHornSoundPlaying;
        if(isClickable)
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CircleColorCustomizer(),));
        else {
          SoundManager.instance.playMeepMerp();
        }
      },
      icon: const Icon(Icons.color_lens_outlined, size: 28),
    );
  }
}
