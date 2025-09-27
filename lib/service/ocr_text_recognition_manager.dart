//
//  OcrTextRecognizeMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/14 09:18.
//  Copyright © 2024/9/14 shang. All rights reserved.
//

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Ocr 识别
class OcrTextRecognitionManager {
  /// 识别图片
  Future<({bool isSuccess, String result})> processImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);

      final textRecognizer = TextRecognizer(script: TextRecognitionScript.chinese);
      final recognizedText = await textRecognizer.processImage(inputImage);
      final result = recognizedText.text;
      return (isSuccess: true, result: result);
    } catch (e) {
      debugPrint("识别失败：$e");
      return (isSuccess: false, result: e.toString());
    }
  }
}
