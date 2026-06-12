# 视频音量设置

问题： volume_controller: 2.0.8 在 iOS 上指示器显示有问题
解决办法：Plugin插件。

### 1.插件声明
```swift
import Flutter
import UIKit
import MediaPlayer


@main
@objc class AppDelegate: FlutterAppDelegate {
    
      private var volumeView: MPVolumeView?
    
      override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
          
          guard let controller = window?.rootViewController as? FlutterViewController else {
               return super.application(application, didFinishLaunchingWithOptions: launchOptions)
             }
          
          let volumeChannel = FlutterMethodChannel(
                name: "flutter.device/volume",
                binaryMessenger: controller.binaryMessenger
              )
          
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
    
     /// 隐藏音量设置
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
```

### 2.插件使用封装为 VolumeIOSMixin
```dart
mixin VolumeIOSMixin {
  final _volumeChannel = const MethodChannel('flutter.device/volume');

  /// 设置IOS音量
  Future<void> _setVolumeIOS(double value) async {
    try {
      await _volumeChannel.invokeMethod('setVolume', {'value': value});
    } catch (e) {
      debugPrint([runtimeType, e].join(", "));
    }
  }
}

```