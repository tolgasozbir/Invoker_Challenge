import 'dart:developer';
import 'dart:io';

import 'package:dota2_invoker_game/enums/local_storage_keys.dart';
import 'package:dota2_invoker_game/services/local_storage/local_storage_service.dart';
import 'package:dota2_invoker_game/services/user_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum RevenuecatIdentifiers {
  premiumEntitlement(id: 'monthly', transactionProductId: 'com.dota2.invoker.game.supporterpass:supporter-monthly'),
  consumablePackage(id: 'consumable_premium', transactionProductId: 'com.dota2.invoker.game.premium');

  // Offering Id
  final String id;
  //Store Product Id
  final String transactionProductId;

  const RevenuecatIdentifiers({required this.id, required this.transactionProductId});
}

class RevenueCatService {
  RevenueCatService._();

  static final RevenueCatService _instance = RevenueCatService._();
  static RevenueCatService get instance => _instance;

  Offerings? _offerings;
  Offerings? get offerings => _offerings;
  
  final ValueNotifier<CustomerInfo?> _customerInfo = ValueNotifier(null);
  ValueNotifier<CustomerInfo?> get customerInfo => _customerInfo;
  bool get isSubscribed => _customerInfo.value?.entitlements.active.containsKey(RevenuecatIdentifiers.premiumEntitlement.id) ?? false;

  Package? get monthlyOffering => _offerings?.current?.monthly;
  String get monthlyOfferingPrice => monthlyOffering?.storeProduct.priceString ?? '';

  Package? get consumablePremiumOffering => _offerings?.current?.getPackage(RevenuecatIdentifiers.consumablePackage.id);
  String get consumablePremiumOfferingPrice => consumablePremiumOffering?.storeProduct.priceString ?? '';

  Future<void> initialize() async {
    if (kDebugMode) {
      await Purchases.setLogLevel(LogLevel.debug);
    }

    late final PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      final apiKey = dotenv.env['REVENUECAT_ANDROID_API_KEY'];
      if (apiKey == null) {
        log('RevenueCat API Key not found.', name: 'PurchaseService');
        return;
      }

      // --- Listen for customer info updates ---
      Purchases.addCustomerInfoUpdateListener((updatedInfo) async {
        _customerInfo.value = updatedInfo;
        log('Customer info updated!', name: 'PurchaseService');
        
        await _processCustomerInfo(updatedInfo);
      });

      configuration = PurchasesConfiguration(apiKey);
      await Purchases.configure(configuration);
    } else {
      log('PurchaseService is not supported on this platform.', name: 'PurchaseService');
    }

  }

  Future<void> _processCustomerInfo(CustomerInfo customerInfo) async {
    log('is Subscribed : $isSubscribed');

    // user modeldeki isSubscribed durumunu güncelle
    final userManager = UserManager.instance;
    userManager.user.isSubscribed = isSubscribed;

    if (isSubscribed) {
      await _grantPremiumAccess(isFromSubscription: true);
    }
    await _checkAndProcessConsumables(customerInfo);

    await userManager.setUserAndSaveToCache(userManager.user);
    await userManager.saveUserToDb(userManager.user);
    log('Saved');
  }

  /// Fetches offerings and initial customer info.
  Future<void> loadDataWithRetry({
    int maxRetries = 3, 
    Duration initialDelay = const Duration(seconds: 2),
    bool forceReload = false,
    void Function()? onRetry,
    void Function()? onFail,
  }) async {
    // if (forceReload) {
    //   log('Forcing sync with RevenueCat servers...', name: 'PurchaseService');
    //   await Purchases.syncPurchases();
    // }
    // Daha önce yüklendiyse ve forceReload istenmiyorsa
    if (!forceReload && _offerings != null && _customerInfo.value != null) {
      log('RevenueCat data already loaded — skipping fetch.', name: 'PurchaseService');
      return;
    }

    int attempt = 0;
    final Duration delay = initialDelay;

    while (attempt < maxRetries) {
      try {
        _offerings = await Purchases.getOfferings();
        _customerInfo.value = await Purchases.getCustomerInfo();

        log('RevenueCat data loaded successfully', name: 'PurchaseService');
        return;
      } on PlatformException catch (e) {
        attempt++;
        log('Attempt $attempt: Failed to load purchase data: ${e.message}', name: 'PurchaseService', error: e);
      } catch (e) {
        attempt++;
        log('Attempt $attempt: Unexpected error loading RevenueCat data', name: 'PurchaseService', error: e);
      }

      onRetry?.call();
      await Future.delayed(delay);
      //delay *= 2; // Exponential backoff
    }

    log('All retry attempts failed to load RevenueCat data', name: 'PurchaseService');
    onFail?.call();
  }

  Future<void> _checkAndProcessConsumables(CustomerInfo customerInfo) async {
    final cache = LocalStorageService.instance;
    final List<String> processedTransactions = cache.getValue<List<String>>(LocalStorageKey.processed_rc_transactions) ?? [];
    final bool bootstrapCompleted = cache.getValue<bool>(LocalStorageKey.bootstrap_completed) ?? false;

     // --- First time bootstrap: mark historical non-subscription transactions as processed ---
    if (bootstrapCompleted == false) {
      if (customerInfo.nonSubscriptionTransactions.isNotEmpty) {
        log('First launch sync of non-subscription transactions', name: 'PurchaseService');
        final historicalTransactionIds = customerInfo.nonSubscriptionTransactions.map((t) => t.transactionIdentifier).toList();
        processedTransactions.addAll(historicalTransactionIds);
      }
      await cache.setValue<bool>(LocalStorageKey.bootstrap_completed, true);
    }
    // BOOTSTRAP END

    // --- Process unprocessed consumables ---
    for (final transaction in customerInfo.nonSubscriptionTransactions) {
      final String transactionId = transaction.transactionIdentifier;
      final String productId = transaction.productIdentifier;
      
      if (processedTransactions.contains(transactionId)) {
        continue;
      }

      log('Yeni işlenmemiş alım bulundu: $productId (ID: $transactionId)', name: 'PurchaseService');

      bool purchaseProcessed = false;
      if (productId == RevenuecatIdentifiers.consumablePackage.transactionProductId) {
        await _grantPremiumAccess(isFromSubscription: false);
      }
      purchaseProcessed = true;

      if (purchaseProcessed) {
        processedTransactions.add(transactionId);
      }
      
    }

    await cache.setValue<List<String>>(LocalStorageKey.processed_rc_transactions, processedTransactions);
  }

  /// Grants premium access based on the type of purchase.
  /// 
  /// [isFromSubscription] - If true, the premium is granted via subscription.
  /// If false, it is granted via one-time purchase.
  Future<void> _grantPremiumAccess({required bool isFromSubscription}) async {
    log('Granting premium access via ${isFromSubscription ? 'subscription' : 'one-time purchase'}', name: 'PurchaseService');
    await UserManager.instance.processPremium(isFromSubscription: isFromSubscription);
    await Purchases.syncPurchases();
  }

  /// Sadece ilk uygulama açılışında restore etmeyi dener
  Future<void> tryRestoreOnFirstLaunch() async {
    final cache = LocalStorageService.instance;
    final hasRestored = cache.getValue<bool>(LocalStorageKey.hasRestoredPurchases) ?? false;

    if (!hasRestored) {
      try {
        _customerInfo.value = await Purchases.restorePurchases();

        await _processCustomerInfo(_customerInfo.value!);

        await cache.setValue<bool>(LocalStorageKey.hasRestoredPurchases, true);

        log('Satın alımlar restore edildi (ilk açılışta).', name: 'PurchaseService');
      } catch (e) {
        log('Restore işlemi başarısız: $e', name: 'PurchaseService');
      }
    }
  }

  /// Initiates the purchase flow for a specific package.
  // Future<bool> purchasePackage(Package package) async {
  //   errorhandling
  //   try {
  //     await Purchases.purchasePackage(package);
  //     return true; // Başarılı oldu
  //   } on PlatformException catch (e) {
  //     final errorCode = PurchasesErrorHelper.getErrorCode(e);
  //     if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
  //       log('Purchase failed: ${e.message}', name: 'PurchaseService', error: e);
  //     }
  //     return false; // Başarısız oldu
  //   } catch (e) {
  //     log('An unexpected error occurred during purchase.', name: 'PurchaseService', error: e);
  //     return false; // Başarısız oldu
  //   }
  // }

  /// Restores previous purchases for the user.
  // Future<void> restorePurchases() async {
  //   try {
  //     await Purchases.restorePurchases();
  //     log('Purchases restored.', name: 'PurchaseService');
  //   } on PlatformException catch (e) {
  //     log('Failed to restore purchases: ${e.message}', name: 'PurchaseService', error: e);
  //   } catch (e) {
  //     log('An unexpected error occurred during restore.', name: 'PurchaseService', error: e);
  //   }
  // }

}
