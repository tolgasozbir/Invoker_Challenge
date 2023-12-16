import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/boss_battle_provider.dart';
import '../../../../../services/sound_manager.dart';
import 'info_view.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final isClickable = !context.read<BossBattleProvider>().started && 
                             context.read<BossBattleProvider>().snapIsDone && 
                            !context.read<BossBattleProvider>().isHornSoundPlaying;
        if(isClickable)
          Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoView(),));
        else {
          SoundManager.instance.playMeepMerp();
        }
      },
      icon: const Icon(FontAwesomeIcons.circleQuestion),
    );
  }
}
