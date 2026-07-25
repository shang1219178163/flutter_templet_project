//
//  RecognizeTextPage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/7/25.
//  Copyright © 2026/7/25 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/service/recognize_text/recognize_text_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// 图片文字提取演示（策略模式：iOS Vision / Android ML Kit）
class RecognizeTextPage extends StatefulWidget {
  const RecognizeTextPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<RecognizeTextPage> createState() => _RecognizeTextPageState();
}

class _RecognizeTextPageState extends State<RecognizeTextPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  ThemeData get theme => Theme.of(context);

  final picker = ImagePicker();
  final service = RecognizeTextService();

  File? imageFile;
  var isLoading = false;
  var resultText = '请选择图片后开始识别';
  var apiName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text('$widget'),
              actions: [
                if (resultText.isNotEmpty && resultText != '请选择图片后开始识别')
                  IconButton(
                    tooltip: '复制结果',
                    onPressed: copyResult,
                    icon: const Icon(Icons.copy),
                  ),
              ],
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '策略：${service.strategyName}\n'
              'iOS：RecognizeTextRequest / VNRecognizeTextRequest\n'
              'Android：Google ML Kit Text Recognition',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            buildImagePreview(),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: isLoading ? null : () => pickImage(ImageSource.gallery),
                  child: const Text('相册选图'),
                ),
                FilledButton.tonal(
                  onPressed: isLoading ? null : () => pickImage(ImageSource.camera),
                  child: const Text('拍照'),
                ),
                OutlinedButton(
                  onPressed: isLoading || imageFile == null ? null : recognize,
                  child: Text(isLoading ? '识别中...' : '开始识别'),
                ),
              ],
            ),
            if (!service.isPlatformSupported) ...[
              const SizedBox(height: 12),
              Text(
                '当前平台无可用识别策略。',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
            if (apiName.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('API：$apiName', style: theme.textTheme.labelMedium),
            ],
            const SizedBox(height: 12),
            Text('识别结果', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(resultText),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImagePreview() {
    if (imageFile == null) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.image_outlined, size: 64, color: theme.hintColor),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        imageFile!,
        height: 240,
        width: double.infinity,
        fit: BoxFit.contain,
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    if (!service.isPlatformSupported) {
      resultText = '当前平台无可用识别策略';
      setState(() {});
      return;
    }
    final file = await picker.pickImage(source: source);
    if (file == null) {
      return;
    }
    imageFile = File(file.path);
    resultText = '已选择图片，点击「开始识别」';
    apiName = '';
    setState(() {});
  }

  Future<void> recognize() async {
    final file = imageFile;
    if (file == null) {
      return;
    }
    isLoading = true;
    resultText = '正在识别...';
    setState(() {});
    try {
      final result = await service.recognizeText(file.path);
      apiName = result.api;
      resultText = result.text.isEmpty ? '未检测到文字' : result.text;
    } on PlatformException catch (e) {
      apiName = '';
      resultText = '识别失败：${e.message ?? e.code}';
    } catch (e) {
      apiName = '';
      resultText = '识别失败：$e';
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  Future<void> copyResult() async {
    await Clipboard.setData(ClipboardData(text: resultText));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已复制到剪贴板')),
    );
  }
}
