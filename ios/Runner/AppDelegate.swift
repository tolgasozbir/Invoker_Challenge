import AVFoundation
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // flutter_soloud ses oturumunu uygulamaya bırakıyor. Ayarlanmazsa iOS varsayılan SoloAmbient'i
    // kullanır ve oyun sesi başlayınca arkada çalan müzik durur. Ambient müzikle karışır,
    // sessiz modda ise SoloAmbient gibi oyun sesini kapatır.
    try? AVAudioSession.sharedInstance().setCategory(.ambient)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
