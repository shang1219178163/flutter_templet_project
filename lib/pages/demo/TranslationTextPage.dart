//
//  GoogleTranslationPage.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/16 12:23.
//  Copyright © 2024/11/16 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/basicWidget/n_future_builder.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/clipboard_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/pages/demo/SelectableTextDemo.dart';
import 'package:flutter_templet_project/util/device_info_plugin_ext.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:quiver/time.dart';

class TranslationTextPage extends StatefulWidget {
  const TranslationTextPage({super.key});

  @override
  _TranslationTextPageState createState() => _TranslationTextPageState();
}

class _TranslationTextPageState extends State<TranslationTextPage> {
  var translator = OnDeviceTranslator(
    sourceLanguage: TranslateLanguage.english, // 源语言：英语
    targetLanguage: TranslateLanguage.chinese, // 目标语言：中文
  );

  final _languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
  var _identifiedLanguage = '';

  final _textController = TextEditingController();
  String _translatedText = '';
  bool _isTranslating = false;

  TranslateLanguage? sourceLanguage;
  TranslateLanguage? targetLanguage = TranslateLanguage.chinese;

  final isSimulatorVN = ValueNotifier(false);

  @override
  void dispose() {
    translator.close();
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    isSimulatorVN.value = await DeviceInfoPluginExt.isSimulator();
  }

  Future<void> checkLanguage({required String text}) async {
    if (text.isNotEmpty != true) {
      return;
    }
    String language;
    try {
      language = await _languageIdentifier.identifyLanguage(text);
    } on PlatformException catch (pe) {
      if (pe.code == _languageIdentifier.undeterminedLanguageCode) {
        language = 'error: no language identified!';
      }
      language = 'error: ${pe.code}: ${pe.message}';
    } catch (e) {
      language = 'error: ${e.toString()}';
    }
    _identifiedLanguage = language;
    sourceLanguage = BCP47Code.fromRawValue(language);
    DLog.d([language, sourceLanguage].asMap());
    // setState(() {});
  }

  Future<void> onTranslateText({required String text}) async {
    if (text.isEmpty || _isTranslating) {
      return;
    }
    _isTranslating = true;
    setState(() {});

    try {
      translator = OnDeviceTranslator(
        sourceLanguage: sourceLanguage ?? TranslateLanguage.english, // 源语言：英语
        targetLanguage: targetLanguage ?? TranslateLanguage.chinese, // 目标语言：中文
      );
      final translation = await translator.translateText(text);
      _translatedText = translation;
    } catch (e) {
      _translatedText = '翻译失败: $e';
      DLog.d(e);
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: isSimulatorVN,
                builder: (context, value, child) {
                  if (!value) {
                    return SizedBox();
                  }

                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '模拟器不支持语言检测',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  );
                },
              ),
              Container(
                padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Spacer(),
                    NMenuAnchor(
                      values: TranslateLanguage.values,
                      initialItem: sourceLanguage,
                      placeholder: "自动检测",
                      onChanged: (val) async {
                        ddlog(val);
                        sourceLanguage = val;
                        await onTranslateText(text: _textController.text);
                      },
                      cbName: (e) => "$e".split(".").last,
                      equal: (a, b) => a == b,
                      constraints: BoxConstraints(
                        maxHeight: 400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.change_circle_outlined),
                    ),
                    NMenuAnchor(
                      values: TranslateLanguage.values,
                      initialItem: targetLanguage,
                      onChanged: (val) async {
                        ddlog(val);
                        targetLanguage = val;
                        await onTranslateText(text: _textController.text);
                      },
                      cbName: (e) => "$e".split(".").last,
                      equal: (a, b) => a == b,
                      constraints: BoxConstraints(
                        maxHeight: 400,
                      ),
                    ),
                  ],
                ),
              ),
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
                onPressed: () async {
                  await checkLanguage(text: _textController.text);
                  await onTranslateText(text: _textController.text);
                },
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
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
