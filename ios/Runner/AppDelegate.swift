import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        GeneratedPluginRegistrant.register(with: self)
    
        if let vc = window?.rootViewController as? FlutterViewController {
            let batteryChannel = FlutterMethodChannel(name: "samples.flutter.io/battery", binaryMessenger: vc.binaryMessenger)
            batteryChannel.setMethodCallHandler { (call, result) in
                if call.method == "getBatteryLevel" {
                    self.receiveBatteryLevel(result)
                } else {
                    result(FlutterMethodNotImplemented)
                }
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func receiveBatteryLevel(_ result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
            let error = FlutterError(code: "UNAVAILABLE", message: "电池信息不可用", details: nil)
            result(error)
            return
        }
        result(Int(device.batteryLevel * 100));
    }
}
