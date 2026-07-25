//
//  VolumeChannel.swift
//  Runner
//
//  系统音量 MethodChannel
//

import Flutter
import MediaPlayer
import UIKit

/// 无 HUD 设置系统音量通道
final class VolumeChannel {
    static let channelName = "flutter.device/volume"
    static let shared = VolumeChannel()

    private var volumeView: MPVolumeView?
    private weak var window: UIWindow?

    private init() {}

    /// 注册 MethodChannel
    func register(with messenger: FlutterBinaryMessenger, window: UIWindow?) {
        self.window = window
        let channel = FlutterMethodChannel(name: Self.channelName, binaryMessenger: messenger)
        channel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            if call.method == "setVolume" {
                guard let args = call.arguments as? [String: Any],
                      let value = args["value"] as? Double else {
                    result(false)
                    return
                }
                self.setSystemVolume(Float(value))
                result(true)
                return
            }
            result(FlutterMethodNotImplemented)
        }
    }

    /// 无 HUD 设置音量
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
