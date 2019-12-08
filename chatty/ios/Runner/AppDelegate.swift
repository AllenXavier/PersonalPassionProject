import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let CHANNEL = FlutterMethodChannel(name: "be.xavierallen.chatty/multipeerConnectivity", binaryMessenger: controller.binaryMessenger)
    
    CHANNEL.setMethodCallHandler{ [unowned self] (methodCall, result) in
        if methodCall.method == "Printy"
        {
            result("hi form swift")
        }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
