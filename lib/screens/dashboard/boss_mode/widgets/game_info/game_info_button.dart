import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/boss_battle_provider.dart';
import '../../../../../services/sound_manager.dart';
import 'game_info_view.dart';

class GameInfoButton extends StatelessWidget {
  const GameInfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final isClickable = !context.read<BossBattleProvider>().started && 
                             context.read<BossBattleProvider>().snapIsDone && 
                            !context.read<BossBattleProvider>().isHornSoundPlaying;
        if(isClickable)
          Navigator.push(context, MaterialPageRoute(builder: (context) => const GameInfoView()));
        else {
          SoundManager.instance.playMeepMerp();
        }
      },
      icon: const Icon(Icons.help_outline, size: 28),
    );
  }
}
