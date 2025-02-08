import 'package:auto_size_text/auto_size_text.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/locale_keys.g.dart';
import '../enums/local_storage_keys.dart';
import '../enums/sound_players.dart';
import '../mixins/screen_state_mixin.dart';
import '../services/app_services.dart';
import '../services/sound_manager.dart';
import '../services/sound_player/audioplayer_wrapper.dart';
import '../services/sound_player/soloud_wrapper.dart';

class SoundPlayerSwitch extends StatefulWidget {
  const SoundPlayerSwitch({super.key});

  @override
  State<SoundPlayerSwitch> createState() => _SoundPlayerSwitchState();
}

class _SoundPlayerSwitchState extends State<SoundPlayerSwitch> with ScreenStateMixin {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                LocaleKeys.settings_playerInfoTitle.locale,
                minFontSize: 10,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              AutoSizeText(
                LocaleKeys.settings_playerInfoDesc.locale,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                minFontSize: 8,
                maxLines: 1,
              ),
            ],
          ),
        ),
        Switch(
          activeColor: AppColors.wexColor,
          value: SoundManager.instance.player is SoLoudWrapper,
          onChanged: (isSoLoud) async {
            final newPlayer = isSoLoud ? SoLoudWrapper.instance : AudioPlayerWrapper.instance;
            SoundManager.instance.switchPlayer(newPlayer);
            await AppServices.instance.localStorageService.setValue<String>(
              LocalStorageKey.soundPlayer, 
              isSoLoud ? SoundPlayers.SoLoud.name: SoundPlayers.AudioPlayers.name,
            );
            SoundManager.instance.playLoadingSound();
            updateScreen();
          },
        ),
      ],
    );
  }
}
