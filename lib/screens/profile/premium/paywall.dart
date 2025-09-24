import 'package:dota2_invoker_game/constants/app_colors.dart';
import 'package:dota2_invoker_game/constants/locale_keys.g.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:dota2_invoker_game/mixins/screen_state_mixin.dart';
import 'package:dota2_invoker_game/services/iap/revenuecat_service.dart';
import 'package:dota2_invoker_game/widgets/empty_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> with ScreenStateMixin {
  final revenueCatService = RevenueCatService.instance;
  int _selectedPlan = 0; // 0: consumable_premium, 1: monthly
  bool _isPurchasing = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    changeLoadingState();
    await RevenueCatService.instance.loadDataWithRetry(forceReload: true);
    changeLoadingState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ValueListenableBuilder<CustomerInfo?>(
        valueListenable: revenueCatService.customerInfo,
        builder: (context, customerInfo, child) {
          final offerings = revenueCatService.offerings;

          // for (final element in offerings!.current!.availablePackages) {
          //   print(element.identifier);
          //   print(element.storeProduct.identifier);
          //   print(element.storeProduct.priceString);
          // }

          if (isLoading) {
            return _buildLoadingIndicator();
          }

          if (offerings == null || offerings.current == null || offerings.current!.availablePackages.isEmpty) {
            return _buildError();
          }

          return _bodyView();
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  
  Widget _buildError() {
    return Center(
      child: Text(LocaleKeys.paywall_offerings_not_fetched.locale),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(LocaleKeys.paywall_premium_features.locale, style: const TextStyle(fontSize: 18)),
      centerTitle: true,
    );
  }

  Widget _bodyView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildGameExperienceText(),
            const EmptyBox.h12(),
            _buildFeaturesContainer(),
            const EmptyBox.h16(),
            _buildPlans(),
            const EmptyBox.h16(),
            _buildPurchaseButton(),
            const EmptyBox.h16(),
            _buildBottomInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameExperienceText() {
    return Text(
      LocaleKeys.paywall_intro_text.locale,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color(0xFF8E8E93),
        fontSize: 14,
      ),
    );
  }

  Widget _buildFeaturesContainer() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.yellow.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.paywall_features_features_title.locale,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const EmptyBox.h16(),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildFeatureItem(
                      Icons.block_rounded,
                      LocaleKeys.paywall_features_feature_ad_free_title.locale,
                      LocaleKeys.paywall_features_feature_ad_free_desc.locale,
                    ),
                    _buildFeatureItem(
                      Icons.lock_open_rounded,
                      LocaleKeys.paywall_features_feature_reach_max_level_title.locale,
                      LocaleKeys.paywall_features_feature_reach_max_level_desc.locale,
                    ),
                    _buildFeatureItem(
                      Icons.monetization_on_rounded,
                      LocaleKeys.paywall_features_feature_bonus_gold_title.locale,
                      LocaleKeys.paywall_features_feature_bonus_gold_desc.locale,
                    ),
                    _buildFeatureItem(
                      Icons.favorite_rounded,
                      LocaleKeys.paywall_features_feature_challenger_life_title.locale,
                      LocaleKeys.paywall_features_feature_challenger_life_desc.locale,
                    ),
                    _buildFeatureItem(
                      Icons.timer_rounded,
                      LocaleKeys.paywall_features_feature_time_title.locale,
                      LocaleKeys.paywall_features_feature_time_desc.locale,
                    ),
                    _buildFeatureItem(
                      Icons.flash_on_rounded,
                      LocaleKeys.paywall_features_feature_combo_title.locale,
                      LocaleKeys.paywall_features_feature_combo_desc.locale,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.yellow.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppColors.yellow,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF8B949E),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlans() {
    final monthlyPackage = revenueCatService.monthlyOffering;
    final consumablePackage = revenueCatService.consumablePremiumOffering;
    return Row(
      children: [
        if (consumablePackage != null)
          Expanded(
            child: _buildPlanCard(
              title: LocaleKeys.paywall_plans_premium.locale,
              subtitle: LocaleKeys.paywall_plans_one_time.locale,
              price: RevenueCatService.instance.consumablePremiumOfferingPrice,
              isSelected: _selectedPlan == 0,
              onTap: () => setState(() => _selectedPlan = 0),
              badge: LocaleKeys.paywall_plans_most_popular.locale,
            ),
          ),
        if (consumablePackage != null && monthlyPackage != null)
          const SizedBox(width: 12),
        if (monthlyPackage != null)
          Expanded(
            child: _buildPlanCard(
              title: LocaleKeys.paywall_plans_monthly.locale,
              subtitle: LocaleKeys.paywall_plans_subscription.locale,
              price: RevenueCatService.instance.monthlyOfferingPrice,
              isSelected: _selectedPlan == 1,
              onTap: () => setState(() => _selectedPlan = 1),
            ),
          ),
      ],
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String subtitle,
    required String price,

    required bool isSelected,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF21262D) : const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.yellow : const Color(0xFF21262D),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF8B949E),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(
                color: AppColors.yellow,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.amber, AppColors.yellow],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.yellow.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        onPressed: _isPurchasing ? null : () => _handlePurchase(),
        child: _isPurchasing
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                _selectedPlan == 0 
                    ? LocaleKeys.paywall_plans_purchase_premium_version.locale 
                    : LocaleKeys.paywall_plans_start_monthly_subscription.locale,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [BoxShadow(blurRadius: 16), BoxShadow(blurRadius: 2)],
                ),
              ),
      ),
    );
  }

  Future<void> _handlePurchase() async {
    if (_isPurchasing) return;

    final package = _selectedPlan == 0
        ? revenueCatService.consumablePremiumOffering
        : revenueCatService.monthlyOffering;

    if (package == null) return;

    updateScreen(fn: () => _isPurchasing = true);

    try {
      //await Purchases.purchasePackage(package); //deprecated
      await Purchases.purchase(PurchaseParams.package(package));
      if (context.mounted) {
        _showPurchaseDialog(
          title: LocaleKeys.paywall_transaction_messages_purchase_success_title.locale, 
          desc: LocaleKeys.paywall_transaction_messages_purchase_success_desc.locale,
        );
      }
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (context.mounted) {
        if (errorCode == PurchasesErrorCode.paymentPendingError) {
          _showPurchaseDialog(
            title: LocaleKeys.paywall_transaction_messages_transaction_initiated_title.locale,
            desc: LocaleKeys.paywall_transaction_messages_transaction_initiated_desc.locale,
          );
        } else if (errorCode == PurchasesErrorCode.purchaseCancelledError || errorCode == PurchasesErrorCode.productAlreadyPurchasedError) {
          //User Cancel or Already Purchased
        } else {
          _showPurchaseDialog(
            title: LocaleKeys.paywall_transaction_messages_purchase_failed_title.locale, 
            desc: LocaleKeys.paywall_transaction_messages_purchase_failed_desc.locale,
          );
        }
      }
    } finally {
      updateScreen(fn: () => _isPurchasing = false);
    }
  }

  void _showPurchaseDialog({required String title, required String desc}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                desc,
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
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    LocaleKeys.commonGeneral_ok.locale,
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
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Text(
      _selectedPlan == 0 
        ? LocaleKeys.paywall_plans_one_time_payment_unlimited_use.locale
        : LocaleKeys.paywall_plans_cancel_anytime.locale,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color(0xFF8B949E),
        fontSize: 12,
      ),
    );
  }

}
