//
//  ios_translation_channel.dart
//  flutter_templet_project
//
//  Created by shang on 2026/9/2.
//  Copyright © 2026/9/2 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// iOS Apple Translation MethodChannel 客户端（真机 + iOS 18+）。
class IosTranslationChannel {
  IosTranslationChannel._();

  static const MethodChannel _channel = MethodChannel('flutter.device/translation');

  /// 是否可用（iOS 真机且系统返回 supported）
  static bool get isPlatformSupported => !kIsWeb && Platform.isIOS;

  /// 查询原生侧是否支持 Translation
  static Future<bool> isSupported() async {
    if (!isPlatformSupported) {
      return false;
    }
    try {
      final value = await _channel.invokeMethod<bool>('isSupported');
      return value ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// 翻译文本。
  ///
  /// [sourceLanguage] / [targetLanguage] 使用 BCP-47（如 `en`、`zh-Hans`）。
  /// [sourceLanguage] 可空，表示由系统检测源语言。
  static Future<IosTranslationResult> translate({
    required String text,
    required String targetLanguage,
    String? sourceLanguage,
  }) async {
    if (!isPlatformSupported) {
      throw PlatformException(code: 'UNSUPPORTED', message: '仅支持 iOS');
    }
    final raw = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'translate',
      {
        'text': text,
        'targetLanguage': targetLanguage,
        if (sourceLanguage != null && sourceLanguage.isNotEmpty) 'sourceLanguage': sourceLanguage,
      },
    );
    if (raw == null) {
      throw PlatformException(code: 'EMPTY', message: '翻译结果为空');
    }
    return IosTranslationResult.fromMap(raw);
  }

  /// 查询语言对状态：`installed` / `supported` / `unsupported`
  static Future<String> status({
    required String targetLanguage,
    String? sourceLanguage,
  }) async {
    if (!isPlatformSupported) {
      return 'unsupported';
    }
    final raw = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'status',
      {
        'targetLanguage': targetLanguage,
        if (sourceLanguage != null && sourceLanguage.isNotEmpty) 'sourceLanguage': sourceLanguage,
      },
    );
    return raw?['status']?.toString() ?? 'unsupported';
  }

  /// 预下载语言包（可能弹出系统授权 UI）
  static Future<bool> prepareTranslation({
    required String targetLanguage,
    String? sourceLanguage,
  }) async {
    if (!isPlatformSupported) {
      return false;
    }
    final raw = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'prepareTranslation',
      {
        'targetLanguage': targetLanguage,
        if (sourceLanguage != null && sourceLanguage.isNotEmpty) 'sourceLanguage': sourceLanguage,
      },
    );
    return raw?['prepared'] == true;
  }
}

/// 翻译结果
class IosTranslationResult {
  const IosTranslationResult({
    required this.text,
    this.sourceLanguage,
    this.targetLanguage,
    this.api,
  });

  factory IosTranslationResult.fromMap(Map<dynamic, dynamic> map) {
    return IosTranslationResult(
      text: map['text']?.toString() ?? '',
      sourceLanguage: map['sourceLanguage']?.toString(),
      targetLanguage: map['targetLanguage']?.toString(),
      api: map['api']?.toString(),
    );
  }

  final String text;
  final String? sourceLanguage;
  final String? targetLanguage;
  final String? api;
}
