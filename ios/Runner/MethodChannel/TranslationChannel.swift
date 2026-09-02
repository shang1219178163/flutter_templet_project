//
//  TranslationChannel.swift
//  Runner
//
//  基于 Apple Translation framework 的翻译 MethodChannel（iOS 18+）
//  TranslationSession 只能通过 SwiftUI `.translationTask` 获取，故用 UIHostingController 桥接。
//

import Flutter
import SwiftUI
import Translation
import UIKit

/// 系统端侧翻译通道（真机 + iOS 18+；模拟器不可用）
final class TranslationChannel {
    static let channelName = "flutter.device/translation"
    static let shared = TranslationChannel()

    private weak var window: UIWindow?
    private var hostingController: UIViewController?

    private init() {}

    /// 注册 MethodChannel
    func register(with messenger: FlutterBinaryMessenger, window: UIWindow?) {
        self.window = window
        let channel = FlutterMethodChannel(name: Self.channelName, binaryMessenger: messenger)
        channel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            switch call.method {
            case "isSupported":
                result(self.isSupported)
            case "translate":
                self.handleTranslate(call: call, result: result)
            case "status":
                self.handleStatus(call: call, result: result)
            case "prepareTranslation":
                self.handlePrepare(call: call, result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    /// 是否支持（iOS 18+ 且非模拟器）
    private var isSupported: Bool {
        if #available(iOS 18.0, *) {
            #if targetEnvironment(simulator)
            return false
            #else
            return true
            #endif
        }
        return false
    }

    // MARK: - Handlers

    private func handleTranslate(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard isSupported else {
            result(FlutterError(
                code: "UNSUPPORTED",
                message: "需要 iOS 18+ 真机；Translation 在模拟器不可用",
                details: nil
            ))
            return
        }
        guard let args = call.arguments as? [String: Any],
              let text = args["text"] as? String,
              !text.isEmpty else {
            result(FlutterError(code: "INVALID_ARGS", message: "缺少 text", details: nil))
            return
        }
        let targetCode = (args["targetLanguage"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let targetCode, !targetCode.isEmpty else {
            result(FlutterError(code: "INVALID_ARGS", message: "缺少 targetLanguage（BCP-47）", details: nil))
            return
        }
        let sourceCode = (args["sourceLanguage"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        if #available(iOS 18.0, *) {
            translate(
                text: text,
                sourceCode: (sourceCode?.isEmpty == false) ? sourceCode : nil,
                targetCode: targetCode,
                result: result
            )
        }
    }

    private func handleStatus(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard isSupported else {
            result([
                "status": "unsupported",
                "api": "LanguageAvailability"
            ] as [String: Any])
            return
        }
        guard let args = call.arguments as? [String: Any],
              let targetCode = args["targetLanguage"] as? String,
              !targetCode.isEmpty else {
            result(FlutterError(code: "INVALID_ARGS", message: "缺少 targetLanguage（BCP-47）", details: nil))
            return
        }
        let sourceCode = args["sourceLanguage"] as? String
        if #available(iOS 18.0, *) {
            Task {
                let status = await languageStatus(
                    sourceCode: (sourceCode?.isEmpty == false) ? sourceCode : nil,
                    targetCode: targetCode
                )
                DispatchQueue.main.async {
                    result([
                        "status": status,
                        "sourceLanguage": sourceCode as Any,
                        "targetLanguage": targetCode,
                        "api": "LanguageAvailability"
                    ] as [String: Any])
                }
            }
        }
    }

    private func handlePrepare(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard isSupported else {
            result(FlutterError(
                code: "UNSUPPORTED",
                message: "需要 iOS 18+ 真机；Translation 在模拟器不可用",
                details: nil
            ))
            return
        }
        guard let args = call.arguments as? [String: Any],
              let targetCode = args["targetLanguage"] as? String,
              !targetCode.isEmpty else {
            result(FlutterError(code: "INVALID_ARGS", message: "缺少 targetLanguage（BCP-47）", details: nil))
            return
        }
        let sourceCode = args["sourceLanguage"] as? String
        if #available(iOS 18.0, *) {
            prepareTranslation(
                sourceCode: (sourceCode?.isEmpty == false) ? sourceCode : nil,
                targetCode: targetCode,
                result: result
            )
        }
    }

    // MARK: - Translation (iOS 18+)

    @available(iOS 18.0, *)
    private func translate(
        text: String,
        sourceCode: String?,
        targetCode: String,
        result: @escaping FlutterResult
    ) {
        let source = sourceCode.map { Locale.Language(identifier: $0) }
        let target = Locale.Language(identifier: targetCode)

        DispatchQueue.main.async {
            let bridge = TranslationBridgeView(
                mode: .translate(text),
                source: source,
                target: target,
                onFinished: { [weak self] outcome in
                    self?.detachBridge()
                    switch outcome {
                    case .success(let translated):
                        result([
                            "text": translated,
                            "sourceLanguage": sourceCode as Any,
                            "targetLanguage": targetCode,
                            "api": "TranslationSession"
                        ] as [String: Any])
                    case .failure(let error):
                        result(FlutterError(
                            code: "TRANSLATE_FAILED",
                            message: error.localizedDescription,
                            details: nil
                        ))
                    }
                }
            )
            self.attachBridge(rootView: bridge)
        }
    }

    @available(iOS 18.0, *)
    private func prepareTranslation(
        sourceCode: String?,
        targetCode: String,
        result: @escaping FlutterResult
    ) {
        let source = sourceCode.map { Locale.Language(identifier: $0) }
        let target = Locale.Language(identifier: targetCode)

        DispatchQueue.main.async {
            let bridge = TranslationBridgeView(
                mode: .prepare,
                source: source,
                target: target,
                onFinished: { [weak self] outcome in
                    self?.detachBridge()
                    switch outcome {
                    case .success:
                        result([
                            "prepared": true,
                            "sourceLanguage": sourceCode as Any,
                            "targetLanguage": targetCode,
                            "api": "TranslationSession.prepareTranslation"
                        ] as [String: Any])
                    case .failure(let error):
                        result(FlutterError(
                            code: "PREPARE_FAILED",
                            message: error.localizedDescription,
                            details: nil
                        ))
                    }
                }
            )
            self.attachBridge(rootView: bridge)
        }
    }

    @available(iOS 18.0, *)
    private func languageStatus(sourceCode: String?, targetCode: String) async -> String {
        let availability = LanguageAvailability()
        let target = Locale.Language(identifier: targetCode)
        let status: LanguageAvailability.Status
        if let sourceCode, !sourceCode.isEmpty {
            status = await availability.status(
                from: Locale.Language(identifier: sourceCode),
                to: target
            )
        } else {
            // 无源语言时默认用 en → target 探测该语言对是否可用
            status = await availability.status(
                from: Locale.Language(identifier: "en"),
                to: target
            )
        }
        switch status {
        case .installed:
            return "installed"
        case .supported:
            return "supported"
        case .unsupported:
            return "unsupported"
        @unknown default:
            return "unsupported"
        }
    }

    // MARK: - Hosting

    @available(iOS 18.0, *)
    private func attachBridge(rootView: TranslationBridgeView) {
        detachBridge()
        guard let parent = topViewController() else { return }
        let host = UIHostingController(rootView: rootView)
        host.view.backgroundColor = .clear
        host.view.isUserInteractionEnabled = false
        host.view.frame = .zero
        parent.addChild(host)
        parent.view.addSubview(host.view)
        host.didMove(toParent: parent)
        hostingController = host
    }

    private func detachBridge() {
        guard let host = hostingController else { return }
        host.willMove(toParent: nil)
        host.view.removeFromSuperview()
        host.removeFromParent()
        hostingController = nil
    }

    private func topViewController() -> UIViewController? {
        var root = window?.rootViewController
        if root == nil {
            root = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: \.isKeyWindow)?
                .rootViewController
        }
        while let presented = root?.presentedViewController {
            root = presented
        }
        return root
    }
}

// MARK: - SwiftUI bridge

@available(iOS 18.0, *)
private struct TranslationBridgeView: View {
    enum Mode {
        case translate(String)
        case prepare
    }

    let mode: Mode
    let source: Locale.Language?
    let target: Locale.Language
    let onFinished: (Result<String, Error>) -> Void

    @State private var configuration: TranslationSession.Configuration?

    var body: some View {
        Color.clear
            .frame(width: 1, height: 1)
            .accessibilityHidden(true)
            .onAppear {
                if configuration == nil {
                    configuration = TranslationSession.Configuration(
                        source: source,
                        target: target
                    )
                }
            }
            .translationTask(configuration) { session in
                do {
                    switch mode {
                    case .translate(let text):
                        let response = try await session.translate(text)
                        await MainActor.run {
                            onFinished(.success(response.targetText))
                        }
                    case .prepare:
                        try await session.prepareTranslation()
                        await MainActor.run {
                            onFinished(.success(""))
                        }
                    }
                } catch {
                    await MainActor.run {
                        onFinished(.failure(error))
                    }
                }
            }
    }
}
