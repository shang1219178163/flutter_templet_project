import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        GeneratedPluginRegistrant.register(with: self)

        guard let rootViewController = window?.rootViewController as? FlutterViewController else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        let batteryChannel = FlutterMethodChannel(name: "samples.flutter.io/battery",
                                                  binaryMessenger: rootViewController.binaryMessenger)
        batteryChannel.setMethodCallHandler { (call, result) in
            if call.method == "getBatteryLevel" {
                self.receiveBatteryLevel(result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        
        let volumeChannel = FlutterMethodChannel(name: "flutter.device/volume",
                                                 binaryMessenger: rootViewController.binaryMessenger)
        volumeChannel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            if call.method == "setVolume" {
                guard let args = call.arguments as? [String: Any],
                      let value = args["value"] as? Double else {
                    result(false)
                    return
                }
                self.setSystemVolume(Float(value))
                result(true)
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
    
     /// 无HUD设置音量
     private func setSystemVolume(_ value: Float) {
       DispatchQueue.main.async {
         if self.volumeView == nil {
           self.volumeView = MPVolumeView(frame: CGRect(x: -1000, y: -1000, width: 0, height: 0))
           if let window = self.window {
             window.addSubview(self.volumeView!)
           }
         }

         guard let slider = self.volumeView?.subviews.compactMap({ $0 as? UISlider }).first else {
           return
         }

         slider.value = value
       }
     }
}
