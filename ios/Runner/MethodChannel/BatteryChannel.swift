//
//  BatteryChannel.swift
//  Runner
//
//  电池电量 MethodChannel
//

import Flutter
import UIKit

/// 电池电量查询通道
final class BatteryChannel {
    static let channelName = "samples.flutter.io/battery"
    static let shared = BatteryChannel()

    private init() {}

    /// 注册 MethodChannel
    func register(with messenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(name: Self.channelName, binaryMessenger: messenger)
        channel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            if call.method == "getBatteryLevel" {
                self.receiveBatteryLevel(result)
                return
            }
            result(FlutterMethodNotImplemented)
        }
    }

    private func receiveBatteryLevel(_ result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
            result(FlutterError(code: "UNAVAILABLE", message: "电池信息不可用", details: nil))
            return
        }
        result(Int(device.batteryLevel * 100))
    }
}
