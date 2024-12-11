import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
      
      let vibrateChannel : FlutterMethodChannel = FlutterMethodChannel(name: "com.viddy/vibrate", binaryMessenger: controller.binaryMessenger);
      vibrateChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
          guard call.method == "vibrateDevice" else{
              result(FlutterMethodNotImplemented);
              return;
          }
          self?.vibrateDevice(result: result);
      })
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func vibrateDevice(result: FlutterResult){
        let impactGenerator = UIImpactFeedbackGenerator(style: .heavy);
        impactGenerator.prepare();
        impactGenerator.impactOccurred();
    }
}
