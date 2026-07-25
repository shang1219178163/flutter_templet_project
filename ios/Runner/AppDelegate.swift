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
        MethodChannelRegistrar.register(
            with: rootViewController.binaryMessenger,
            window: window
        )
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
