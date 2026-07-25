//
//  RecognizeTextChannel.swift
//  Runner
//
//  iOS Vision 图片文字识别 MethodChannel
//

import Flutter
import UIKit
import Vision

/// 基于 Vision 的文字识别通道
/// iOS 18+：RecognizeTextRequest；更低版本：VNRecognizeTextRequest
final class RecognizeTextChannel {
    static let channelName = "flutter.device/recognizeText"
    static let shared = RecognizeTextChannel()

    private init() {}

    /// 注册 MethodChannel
    func register(with messenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(name: Self.channelName, binaryMessenger: messenger)
        channel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else { return }
            switch call.method {
            case "recognizeText":
                guard let args = call.arguments as? [String: Any],
                      let path = args["path"] as? String else {
                    result(FlutterError(code: "INVALID_ARGS", message: "缺少 path 参数", details: nil))
                    return
                }
                self.recognizeText(from: path, result: result)
            case "isSupported":
                result(true)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    /// 从本地图片路径识别文字
    func recognizeText(from path: String, result: @escaping FlutterResult) {
        guard FileManager.default.fileExists(atPath: path) else {
            result(FlutterError(code: "NO_FILE", message: "图片文件不存在", details: path))
            return
        }
        let url = URL(fileURLWithPath: path)
        if #available(iOS 18.0, *) {
            recognizeTextWithRecognizeTextRequest(url: url, result: result)
            return
        }
        recognizeTextLegacy(from: url, result: result)
    }

    /// iOS 18+ RecognizeTextRequest
    @available(iOS 18.0, *)
    private func recognizeTextWithRecognizeTextRequest(url: URL, result: @escaping FlutterResult) {
        Task {
            do {
                var request = RecognizeTextRequest()
                request.recognitionLevel = .accurate
                request.usesLanguageCorrection = true
                request.automaticallyDetectsLanguage = true
                let observations = try await request.perform(on: url)
                let lines = observations.compactMap { $0.topCandidates(1).first?.string }
                let payload: [String: Any] = [
                    "text": lines.joined(separator: "\n"),
                    "lines": lines,
                    "api": "RecognizeTextRequest"
                ]
                DispatchQueue.main.async {
                    result(payload)
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(code: "OCR_FAILED", message: error.localizedDescription, details: nil))
                }
            }
        }
    }

    /// iOS 18 以下使用 VNRecognizeTextRequest
    private func recognizeTextLegacy(from url: URL, result: @escaping FlutterResult) {
        guard let image = UIImage(contentsOfFile: url.path),
              let cgImage = image.cgImage else {
            result(FlutterError(code: "INVALID_IMAGE", message: "无法读取图片", details: nil))
            return
        }
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                DispatchQueue.main.async {
                    result(FlutterError(code: "OCR_FAILED", message: error.localizedDescription, details: nil))
                }
                return
            }
            let observations = (request.results as? [VNRecognizedTextObservation]) ?? []
            let lines = observations.compactMap { $0.topCandidates(1).first?.string }
            let payload: [String: Any] = [
                "text": lines.joined(separator: "\n"),
                "lines": lines,
                "api": "VNRecognizeTextRequest"
            ]
            DispatchQueue.main.async {
                result(payload)
            }
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        if #available(iOS 16.0, *) {
            request.automaticallyDetectsLanguage = true
        } else {
            request.recognitionLanguages = ["zh-Hans", "en-US"]
        }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(code: "OCR_FAILED", message: error.localizedDescription, details: nil))
                }
            }
        }
    }
}
