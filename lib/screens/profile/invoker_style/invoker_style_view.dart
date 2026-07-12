import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_image_paths.dart';
import '../../../constants/locale_keys.g.dart';
import '../../../extensions/context_extension.dart';
import '../../../extensions/string_extension.dart';
import '../../../mixins/screen_state_mixin.dart';
import '../../../models/invoker.dart';
import '../../../services/sound_manager.dart';
import '../../../services/user_manager.dart';
import '../../../utils/asset_manager.dart';
import '../../../widgets/crownfall_button.dart';
import '../../../widgets/empty_box.dart';

class InvokerStyleView extends StatefulWidget {
  const InvokerStyleView({super.key});

  @override
  State<InvokerStyleView> createState() => _InvokerStyleViewState();
}

class _InvokerStyleViewState extends State<InvokerStyleView> with ScreenStateMixin {
  late final List<String> _icons;

  @override
  void initState() {
    super.initState();
    _initializeIcons();
  }

  void _initializeIcons() {
    const invokerSet = InvokerSet.personaSet;
    _icons = [
      invokerSet.type.miniMapIcon,
      ...invokerSet.type.skills.values,
      ...invokerSet.type.spells.values,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.InvokerPersona_invokerPersona.locale),
        centerTitle: true,
      ),
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return Column(
      children: [
        _buildSkillGrid(),
        _buildShowcaseSection(),
      ],
    );
  }

  Widget _buildSkillGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      itemCount: _icons.length,
      itemBuilder: (context, index) {
        const crossAxisCount = 5;
        final row = index ~/ crossAxisCount;
        final col = index % crossAxisCount;
        final diagonalIndex = row + col;
        final delay = (diagonalIndex * 80).ms;
        final duration = 600.ms;

        return _buildIconTile(_icons[index])
            .animate()
            .fadeIn(
              delay: delay,
              duration: duration,
              curve: Curves.easeOutCubic,
            ).slideY(
              delay: delay,
              begin: 0.4,
              end: 0,
              duration: duration,
              curve: Curves.easeOutCubic,
            )
            .scale(
              delay: delay,
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              duration: duration,
              curve: Curves.easeOutBack,
            )
            .then()
            .animate()
            .shimmer(
              delay: 600.ms,
              duration: 800.ms,
              size: 0.4,
              angle: pi / 4,
            );
      },
    );
  }

  Widget _buildIconTile(String iconPath) {
    final isPersonaIcon = iconPath.contains('persona');

    return Opacity(
      opacity: isPersonaIcon ? 1 : 0.5,
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(width: 1.6, color: AppColors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image(image: AssetManager.getIcon(iconPath), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildShowcaseSection() {
    return Expanded(
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetManager.getIcon(ImagePaths.invokerPersonaShowcase),
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: const Border(top: BorderSide(color: Colors.white, width: 2)),
        ),
        child: Column(
          children: [
            const Spacer(),
            _buildUnlockButton(),
            const EmptyBox.h16(),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockButton() {
    final isPersonaActive = UserManager.instance.invokerType == InvokerSet.personaSet.type;

    return CrownfallButton(
      buttonType: isPersonaActive 
          ? CrownfallButtonTypes.Ruby 
          : CrownfallButtonTypes.Jade,
      width: context.dynamicWidth(0.64),
      height: 64,
      onTap: () {
        final invokerSet = isPersonaActive 
            ? InvokerSet.defaultSet 
            : InvokerSet.personaSet;
        UserManager.instance.changeInvokerType(invokerSet);

        if (!isPersonaActive) {
          SoundManager.instance.playPersonaPickedSound();
        }

        updateScreen();
      },
      child: Text(
        isPersonaActive 
            ? LocaleKeys.InvokerPersona_unequipPersona.locale 
            : LocaleKeys.InvokerPersona_equipPersona.locale,
        style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(size: 0.6, duration: 800.ms, delay: 3000.ms);
  }
}
