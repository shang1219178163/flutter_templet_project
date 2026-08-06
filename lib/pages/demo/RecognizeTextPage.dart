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
import 'package:flutter_templet_project/basicWidget/n_page_indicator.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_box.dart';
import 'package:flutter_templet_project/service/recognize_text/recognize_text_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// 单张图片识别项（识别成功后缓存结果）
class RecognizeTextItem {
  RecognizeTextItem({
    required this.imageFile,
  });

  /// 本地图片
  final File imageFile;

  /// 识别成功后的缓存结果
  RecognizeTextResult? result;

  /// 识别失败信息
  String? errorMessage;

  /// 是否正在识别
  bool isRecognizing = false;

  /// 是否已有成功缓存
  bool get hasCachedResult => result != null;

  /// 展示用识别文案
  String get displayResultText {
    if (isRecognizing) {
      return '正在识别...';
    }
    if (result != null) {
      return result!.text.isEmpty ? '未检测到文字' : result!.text;
    }
    if (errorMessage != null) {
      return errorMessage!;
    }
    return '已选择图片，点击「开始识别」';
  }

  /// 展示用 API 名称
  String get displayApi => result?.api ?? '';
}

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
  static const int maxImageCount = 9;

  /// 主图占比，左右露出前后图
  static const double pageViewportFraction = 0.78;

  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  ThemeData get theme => Theme.of(context);

  final picker = ImagePicker();
  final service = RecognizeTextService();
  final currentPage = ValueNotifier(0);

  var pageController = PageController(viewportFraction: pageViewportFraction);

  final items = <RecognizeTextItem>[];
  var currentIndex = 0;
  var isRuntimeSupported = false;
  var isCheckingSupport = true;

  /// 串行识别队列，避免快速滑动并发多路 OCR
  Future<void> recognizeChain = Future<void>.value();

  RecognizeTextItem? get currentItem {
    if (items.isEmpty || currentIndex < 0 || currentIndex >= items.length) {
      return null;
    }
    return items[currentIndex];
  }

  bool get canAddMore => items.length < maxImageCount;

  bool get canPickImage => isRuntimeSupported && !isCheckingSupport && canAddMore;

  @override
  void initState() {
    super.initState();
    checkSupport();
  }

  @override
  void dispose() {
    pageController.dispose();
    currentPage.dispose();
    super.dispose();
  }

  Future<void> checkSupport() async {
    isCheckingSupport = true;
    setState(() {});
    if (!service.isPlatformSupported) {
      isRuntimeSupported = false;
      isCheckingSupport = false;
      if (mounted) {
        setState(() {});
      }
      return;
    }
    isRuntimeSupported = await service.isSupported();
    isCheckingSupport = false;
    if (mounted) {
      setState(() {});
    }
  }

  /// 重建 PageController，避免清空后页码越界
  void resetPageController({int initialPage = 0}) {
    pageController.dispose();
    pageController = PageController(
      viewportFraction: pageViewportFraction,
      initialPage: initialPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = currentItem;
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text('$widget'),
              actions: [
                if (item != null && item.hasCachedResult)
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            '策略：${service.strategyName}\n'
            'iOS：RecognizeTextRequest / VNRecognizeTextRequest\n'
            'Android：Google ML Kit Text Recognition\n'
            '最多选择 $maxImageCount 张，底部仅展示当前图片识别结果',
            style: theme.textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: buildImagePageView(),
        ),
        if (items.length >= 2)
          NPageIndicator(
            currentPage: currentPage,
            itemCount: items.length,
            margin: const EdgeInsets.only(top: 8),
            normalColor: theme.colorScheme.outlineVariant,
            selectedColor: theme.colorScheme.primary,
            itemSize: Size((72 / items.length).clamp(4, 24), 2),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: buildActions(),
        ),
        if (isCheckingSupport)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text('正在检测识别能力...', style: theme.textTheme.bodySmall),
          )
        else if (!isRuntimeSupported)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              '当前平台无可用识别策略。',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Text('识别结果', style: theme.textTheme.titleMedium),
              const Spacer(),
              if (items.isNotEmpty)
                Text(
                  '${currentIndex + 1}/${items.length}',
                  style: theme.textTheme.labelMedium,
                ),
            ],
          ),
        ),
        Expanded(child: buildCurrentResult()),
      ],
    );
  }

  Widget buildActions() {
    final item = currentItem;
    final isRecognizing = item?.isRecognizing == true;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton(
          onPressed: canPickImage ? () => pickImages(ImageSource.gallery) : null,
          child: const Text('相册选图'),
        ),
        FilledButton.tonal(
          onPressed: canPickImage ? () => pickImages(ImageSource.camera) : null,
          child: const Text('拍照'),
        ),
        OutlinedButton(
          onPressed: !isRuntimeSupported || item == null || isRecognizing ? null : recognizeCurrent,
          child: Text(isRecognizing ? '识别中...' : '开始识别'),
        ),
        if (items.isNotEmpty)
          TextButton(
            onPressed: clearItems,
            child: const Text('清空'),
          ),
      ],
    );
  }

  Widget buildImagePageView() {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.image_outlined, size: 64, color: theme.hintColor),
        ),
      );
    }
    return PageView.builder(
      controller: pageController,
      itemCount: items.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: () => jumpImagePreview(index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ColoredBox(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Image.file(
                  items[index].imageFile,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 仅展示当前图片的识别结果
  Widget buildCurrentResult() {
    final item = currentItem;
    final resultText = item?.displayResultText ?? '请选择图片后开始识别';
    final apiName = item?.displayApi ?? '';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (apiName.isNotEmpty) ...[
                Text('API：$apiName', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
              ],
              SelectableText(resultText),
            ],
          ),
        ),
      ),
    );
  }

  void onPageChanged(int index) {
    currentIndex = index;
    currentPage.value = index;
    setState(() {});
    enqueueRecognizeIfNeeded(items[index]);
  }

  Future<void> pickImages(ImageSource source) async {
    if (!isRuntimeSupported) {
      showMessage('当前平台无可用识别策略');
      return;
    }
    if (!canAddMore) {
      showMessage('最多选择 $maxImageCount 张图片');
      return;
    }
    final remaining = maxImageCount - items.length;
    final wasEmpty = items.isEmpty;
    if (source == ImageSource.camera) {
      final file = await picker.pickImage(source: ImageSource.camera);
      if (file == null) {
        return;
      }
      items.add(RecognizeTextItem(imageFile: File(file.path)));
    } else {
      final files = await picker.pickMultiImage();
      if (files.isEmpty) {
        return;
      }
      final selected = files.take(remaining).map((e) => RecognizeTextItem(imageFile: File(e.path)));
      items.addAll(selected);
      if (files.length > remaining) {
        showMessage('已达上限，仅添加 $remaining 张');
      }
    }
    currentIndex = items.length - 1;
    currentPage.value = currentIndex;
    if (wasEmpty) {
      resetPageController(initialPage: currentIndex);
    }
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!pageController.hasClients) {
        return;
      }
      if (!wasEmpty) {
        pageController.jumpToPage(currentIndex);
      }
      enqueueRecognizeIfNeeded(items[currentIndex]);
    });
  }

  Future<void> recognizeCurrent() async {
    final item = currentItem;
    if (item == null) {
      return;
    }
    if (item.hasCachedResult) {
      showMessage('当前图片已有识别缓存');
      return;
    }
    await enqueueRecognizeIfNeeded(item);
  }

  /// 串行入队：轮到执行时若已不是当前页则跳过，避免并发多路 OCR
  Future<void> enqueueRecognizeIfNeeded(RecognizeTextItem item) {
    recognizeChain = recognizeChain.then((_) => recognizeItemIfNeeded(item));
    return recognizeChain;
  }

  /// 无成功缓存且未在识别中时立即识别（仅当前页）
  Future<void> recognizeItemIfNeeded(RecognizeTextItem item) async {
    if (!isRuntimeSupported) {
      return;
    }
    if (item.hasCachedResult || item.isRecognizing) {
      return;
    }
    if (!identical(item, currentItem)) {
      return;
    }
    item.isRecognizing = true;
    item.errorMessage = null;
    if (mounted) {
      setState(() {});
    }
    try {
      final result = await service.recognizeText(item.imageFile.path);
      item.result = result;
      item.errorMessage = null;
    } on PlatformException catch (e) {
      item.result = null;
      item.errorMessage = '识别失败：${e.message ?? e.code}';
    } catch (e) {
      item.result = null;
      item.errorMessage = '识别失败：$e';
    } finally {
      item.isRecognizing = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> jumpImagePreview(int index) async {
    if (items.isEmpty) {
      return;
    }
    final safeIndex = index.clamp(0, items.length - 1);
    await AssetUploadBox.jumpImagePreview(
      context: context,
      urls: items.map((e) => e.imageFile.path).toList(),
      index: safeIndex,
    );
  }

  void clearItems() {
    items.clear();
    currentIndex = 0;
    currentPage.value = 0;
    resetPageController();
    setState(() {});
  }

  Future<void> copyResult() async {
    final item = currentItem;
    final text = item?.result?.text;
    if (text == null) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) {
      return;
    }
    showMessage('已复制到剪贴板');
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
