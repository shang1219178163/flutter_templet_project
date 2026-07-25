//
//  IosRecognizeTextStrategy.dart
//  flutter_templet_project
//
//  Created by shang on 2026/7/25.
//  Copyright © 2026/7/25 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/service/recognize_text/recognize_text_service.dart';

/// iOS 策略：Vision RecognizeTextRequest / VNRecognizeTextRequest
class IosRecognizeTextStrategy implements RecognizeTextStrategy {
  static const MethodChannel _channel = MethodChannel('flutter.device/recognizeText');

  @override
  String get name => 'iOS Vision';

  @override
  bool get isSupported => !kIsWeb && Platform.isIOS;

  @override
  Future<bool> checkSupported() async {
    if (!isSupported) {
      return false;
    }
    try {
      final value = await _channel.invokeMethod<bool>('isSupported');
      return value ?? false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<RecognizeTextResult> recognizeText(String path) async {
    if (!isSupported) {
      throw PlatformException(
        code: 'UNSUPPORTED',
        message: '当前非 iOS，无法使用 IosRecognizeTextStrategy',
      );
    }
    if (!File(path).existsSync()) {
      throw PlatformException(code: 'NO_FILE', message: '图片文件不存在');
    }
    final raw = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'recognizeText',
      {'path': path},
    );
    if (raw == null) {
      throw PlatformException(code: 'EMPTY', message: '识别结果为空');
    }
    return RecognizeTextResult.fromMap(raw);
  }
}
