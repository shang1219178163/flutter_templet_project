//
//  RecognizeTextService.dart
//  flutter_templet_project
//
//  Created by shang on 2026/7/25.
//  Copyright © 2026/7/25 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/service/recognize_text/android_recognize_text_strategy.dart';
import 'package:flutter_templet_project/service/recognize_text/ios_recognize_text_strategy.dart';

/// 图片文字识别结果
class RecognizeTextResult {
  const RecognizeTextResult({
    required this.text,
    required this.lines,
    required this.api,
  });

  factory RecognizeTextResult.fromMap(Map<dynamic, dynamic> map) {
    final lines = (map['lines'] as List<dynamic>? ?? const []).map((e) => '$e').toList();
    return RecognizeTextResult(
      text: '${map['text'] ?? ''}',
      lines: lines,
      api: '${map['api'] ?? ''}',
    );
  }

  /// 合并后的全文
  final String text;

  /// 按行拆分
  final List<String> lines;

  /// 实际使用的识别实现名称
  final String api;
}

/// 图片文字识别策略
abstract class RecognizeTextStrategy {
  /// 策略名称
  String get name;

  /// 当前运行环境是否适用该策略
  bool get isSupported;

  /// 运行时能力探测（如原生通道是否可用）
  Future<bool> checkSupported();

  /// 从本地图片路径识别文字
  Future<RecognizeTextResult> recognizeText(String path);
}

/// 不支持平台的兜底策略
class UnsupportedRecognizeTextStrategy implements RecognizeTextStrategy {
  @override
  String get name => 'Unsupported';

  @override
  bool get isSupported => false;

  @override
  Future<bool> checkSupported() async => false;

  @override
  Future<RecognizeTextResult> recognizeText(String path) {
    throw PlatformException(
      code: 'UNSUPPORTED',
      message: '当前平台暂无 RecognizeText 策略实现',
    );
  }
}

/// 图片文字识别服务（策略模式入口）
class RecognizeTextService {
  RecognizeTextService({RecognizeTextStrategy? strategy}) : _strategy = strategy ?? createDefaultStrategy();

  final RecognizeTextStrategy _strategy;

  /// 当前策略
  RecognizeTextStrategy get strategy => _strategy;

  /// 当前策略名称
  String get strategyName => _strategy.name;

  /// 当前策略是否适用
  bool get isPlatformSupported => _strategy.isSupported;

  /// 按平台创建默认策略
  static RecognizeTextStrategy createDefaultStrategy() {
    if (!kIsWeb && Platform.isIOS) {
      return IosRecognizeTextStrategy();
    }
    if (!kIsWeb && Platform.isAndroid) {
      return AndroidRecognizeTextStrategy();
    }
    return UnsupportedRecognizeTextStrategy();
  }

  /// 运行时能力探测
  Future<bool> isSupported() => _strategy.checkSupported();

  /// 从本地图片路径识别文字
  Future<RecognizeTextResult> recognizeText(String path) {
    return _strategy.recognizeText(path);
  }
}
