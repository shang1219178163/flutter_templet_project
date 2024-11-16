//
//  OcrPhotoDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/16 10:52.
//  Copyright © 2024/11/16 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OcrPhotoDemo extends StatefulWidget {
  const OcrPhotoDemo({super.key});

  @override
  _OcrPhotoDemoState createState() => _OcrPhotoDemoState();
}

class _OcrPhotoDemoState extends State<OcrPhotoDemo> {
  File? _imageFile;
  String _recognizedText = "请上传图片进行文字识别";

  final _picker = ImagePicker();
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.chinese);

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imageFile = File(image.path);
      _recognizedText = "正在识别文字...";
      setState(() {});
      _processImage(_imageFile!);
    }
  }

  Future<void> _processImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);

    try {
      final recognizedText = await _textRecognizer.processImage(inputImage);
      _recognizedText = recognizedText.text.isEmpty ? "未检测到文字" : recognizedText.text;
      setState(() {});
    } catch (e) {
      _recognizedText = "识别失败：$e";
      setState(() {});
    }
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("文字识别")),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (_imageFile != null) Image.file(_imageFile!) else Icon(Icons.image, size: 100, color: Colors.grey),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: Text("选择图片"),
                ),
              ),
              Text(
                _recognizedText,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
