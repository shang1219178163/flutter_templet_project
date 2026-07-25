//
//  AndroidRecognizeTextStrategy.dart
//  flutter_templet_project
//
//  Created by shang on 2026/7/25.
//  Copyright © 2026/7/25 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/service/recognize_text/recognize_text_service.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Android 策略：Google ML Kit Text Recognition
class AndroidRecognizeTextStrategy implements RecognizeTextStrategy {
  @override
  String get name => 'Android ML Kit';

  @override
  bool get isSupported => !kIsWeb && Platform.isAndroid;

  @override
  Future<bool> checkSupported() async => isSupported;

  @override
  Future<RecognizeTextResult> recognizeText(String path) async {
    if (!isSupported) {
      throw PlatformException(
        code: 'UNSUPPORTED',
        message: '当前非 Android，无法使用 AndroidRecognizeTextStrategy',
      );
    }
    if (!File(path).existsSync()) {
      throw PlatformException(code: 'NO_FILE', message: '图片文件不存在');
    }
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.chinese);
    try {
      final recognizedText = await textRecognizer.processImage(InputImage.fromFilePath(path));
      final text = recognizedText.text;
      final lines = recognizedText.blocks
          .expand((block) => block.lines)
          .map((line) => line.text)
          .where((line) => line.trim().isNotEmpty)
          .toList();
      return RecognizeTextResult(
        text: text,
        lines: lines.isEmpty && text.isNotEmpty ? text.split('\n') : lines,
        api: 'MlKitTextRecognizer',
      );
    } finally {
      await textRecognizer.close();
    }
  }
}
