import 'dart:math';

import 'package:dota2_invoker_game/constants/app_colors.dart';
import 'package:dota2_invoker_game/constants/app_image_paths.dart';
import 'package:dota2_invoker_game/constants/locale_keys.g.dart';
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:dota2_invoker_game/mixins/screen_state_mixin.dart';
import 'package:dota2_invoker_game/services/user_manager.dart';
import 'package:dota2_invoker_game/widgets/crownfall_button.dart';
import 'package:dota2_invoker_game/widgets/empty_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../models/invoker.dart';
import '../../../utils/asset_manager.dart';

class InvokerStyleView extends StatefulWidget {
  const InvokerStyleView({super.key});

  @override
  State<InvokerStyleView> createState() => _InvokerStyleViewState();
}

class _InvokerStyleViewState extends State<InvokerStyleView> with ScreenStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.InvokerForm_invokerForm.locale),
        centerTitle: true,
      ),
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return Column(
      children: [
        _buildSkillGrid(InvokerSet.personaSet),
        _buildShowcaseSection(),
      ],
    );
  }

  Widget _buildSkillGrid(InvokerSet invokerSet) {
    final icons = [
      invokerSet.type.miniMapIcon,
      ...invokerSet.type.skills.values,
      ...invokerSet.type.spells.values,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        itemCount: icons.length,
        itemBuilder: (context, index) => _buildIconTile(icons[index]),
      ),
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
    ).animate().shimmer(size: 0.4, duration: 800.ms, delay: 400.ms, angle: pi / 4, padding: 0);
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
            // const EmptyBox.h24(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 48),
            //   child: BlurWidget(
            //     borderRadius: const BorderRadius.all(Radius.circular(8)),
            //     child: Container(
            //       padding: const EdgeInsets.all(8),
            //       decoration: BoxDecoration(
            //         color: Colors.black26,
            //         borderRadius: const BorderRadius.all(Radius.circular(8)),
            //         border: Border.all(color: Colors.white54),
            //       ),
            //       child: const Text(
            //         'Embrace the power within and don the Persona. Let its essence shape your identity, unlocking a new path filled with unseen potential and mastery.',
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //   ),
            // ),
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
      buttonType: isPersonaActive ? CrownfallButtonTypes.Ruby : CrownfallButtonTypes.Jade,
      width: context.dynamicWidth(0.64),
      height: 64,
      onTap: () {
        UserManager.instance.changeInvokerType(
          isPersonaActive ? InvokerSet.defaultSet : InvokerSet.personaSet,
        );
        updateScreen();
      },
      child: Text(
        isPersonaActive ? LocaleKeys.InvokerForm_unequipPersona.locale : LocaleKeys.InvokerForm_equipPersona.locale,
        style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(size: 0.6, duration: 800.ms, delay: 3000.ms);
  }
}


// class BlurWidget extends StatelessWidget {
//   final Widget child;
//   final double sigmaXY;
//   final BorderRadius borderRadius;

//   const BlurWidget({
//     super.key,
//     required this.child,
//     this.sigmaXY = 8,
//     this.borderRadius = BorderRadius.zero,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: borderRadius,
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: sigmaXY, sigmaY: sigmaXY),
//         child: child,
//       ),
//     );
//   }
// }
