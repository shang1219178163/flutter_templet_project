//
//  MethodChannelRegistrar.swift
//  Runner
//
//  统一注册 Runner 内全部 FlutterMethodChannel
//

import Flutter
import UIKit

/// MethodChannel 统一注册入口
enum MethodChannelRegistrar {
    /// 注册全部自定义 MethodChannel
    static func register(with messenger: FlutterBinaryMessenger, window: UIWindow?) {
        BatteryChannel.shared.register(with: messenger)
        VolumeChannel.shared.register(with: messenger, window: window)
        RecognizeTextChannel.shared.register(with: messenger)
    }
}
