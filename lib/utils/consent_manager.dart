import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

typedef OnConsentGatheringCompleteListener = void Function(FormError? error);

/// The Google Mobile Ads SDK provides the User Messaging Platform (Google's IAB
/// Certified consent management platform) as one solution to capture consent for
/// users in GDPR impacted countries.
class ConsentManager {

  ///Helper method to reset consent value
  Future<void> resetConsent() async {
    await ConsentInformation.instance.reset();
  }

  /// Helper variable to determine if the app can request ads.
  Future<bool> canRequestAds() async {
    final canRequest = await ConsentInformation.instance.canRequestAds();
    return canRequest;
  }

  /// Helper variable to determine if the privacy options form is required.
  Future<bool> isPrivacyOptionsRequired() async {
    return await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() == PrivacyOptionsRequirementStatus.required;
  }

  /// Helper method to call the Mobile Ads SDK to request consent information
  /// and load/show a consent form if necessary.
  void gatherConsent(OnConsentGatheringCompleteListener onConsentGatheringCompleteListener) {
     // For testing purposes, you can force a DebugGeography of Eea or NotEea.
    final debugSettings = ConsentDebugSettings(
      //debugGeography: DebugGeography.debugGeographyEea,
    );
    final params = ConsentRequestParameters(consentDebugSettings: debugSettings);

    // Requesting an update to consent information should be called on every app launch.
    ConsentInformation.instance.requestConsentInfoUpdate(params, () async {
      ConsentForm.loadAndShowConsentFormIfRequired((loadAndShowError) {
        // Consent has been gathered.
        onConsentGatheringCompleteListener(loadAndShowError);
      });
    }, (FormError formError) {
      onConsentGatheringCompleteListener(formError);
    });
  }

  /// Helper method to call the Mobile Ads SDK method to show the privacy options form.
  void showPrivacyOptionsForm(OnConsentFormDismissedListener onConsentFormDismissedListener) {
    ConsentForm.showPrivacyOptionsForm(onConsentFormDismissedListener);
  }
}
