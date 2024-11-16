//
//  GoogleTranslationPage.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/16 12:23.
//  Copyright © 2024/11/16 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationTextPage extends StatefulWidget {
  const TranslationTextPage({super.key});

  @override
  _TranslationTextPageState createState() => _TranslationTextPageState();
}

class _TranslationTextPageState extends State<TranslationTextPage> {
  late final _translator = OnDeviceTranslator(
    sourceLanguage: TranslateLanguage.english, // 源语言：英语
    targetLanguage: TranslateLanguage.chinese, // 目标语言：中文
  );
  final _textController = TextEditingController();
  String _translatedText = '';
  bool _isTranslating = false;

  @override
  void initState() {
    super.initState();
    // _translator = OnDeviceTranslator(
    //   sourceLanguage: _sourceLanguage,
    //   targetLanguage: _targetLanguage,
    // );
  }

  @override
  void dispose() {
    _translator.close();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _translateText() async {
    if (_textController.text.isEmpty) {
      return;
    }
    _isTranslating = true;
    setState(() {});

    try {
      final translation = await _translator.translateText(_textController.text);
      _translatedText = translation;
      setState(() {});
    } catch (e) {
      _translatedText = '翻译失败: $e';
      DLog.d(e);
      setState(() {});
    } finally {
      _isTranslating = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _textController.text =
        "I am creating flutter package , when I am testing on test project with direct call to android method it works, but when I am trying it with flutter package example project got this below error.";
    return Scaffold(
      appBar: AppBar(title: Text('Google ML Kit Translation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: '输入文本',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isTranslating ? null : _translateText,
              child: _isTranslating ? CircularProgressIndicator() : Text('翻译'),
            ),
            const SizedBox(height: 16.0),
            Text(
              '翻译结果:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              _translatedText,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
