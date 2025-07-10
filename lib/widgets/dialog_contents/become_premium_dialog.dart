import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dota2_invoker_game/screens/profile/premium/paywall.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PremiumOfferDialog extends StatefulWidget {
  const PremiumOfferDialog({super.key});

  @override
  State<PremiumOfferDialog> createState() => _PremiumOfferDialogState();
}

class _PremiumOfferDialogState extends State<PremiumOfferDialog> {
  late String selectedDialogKey;

  @override
  void initState() {
    super.initState();
    // Dialoglar 1-4 arası, rastgele birini seç
    selectedDialogKey = (Random().nextInt(4) + 1).toString();
  }

  @override
  Widget build(BuildContext context) {
    final title = tr('premiumDialogs.$selectedDialogKey.title');
    final description = tr('premiumDialogs.$selectedDialogKey.description');
    final buttonAccept = tr('premiumDialogs.$selectedDialogKey.button_accept');
    final buttonDecline = tr('premiumDialogs.$selectedDialogKey.button_decline');

    return Dialog(
      backgroundColor: const Color(0xFF1C1C1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.rocket_launch_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.maybePop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PaywallScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: AutoSizeText(
                  buttonAccept,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.maybePop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: AutoSizeText(
                  buttonDecline,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
