//
//  OcrPhotoDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/16 10:52.
//  Copyright © 2024/11/16 shang. All rights reserved.
//

import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/cache/asset_cache_service.dart';
import 'package:flutter_templet_project/service/ocr_text_recognition_manager.dart';
import 'package:flutter_templet_project/util/R.dart';
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

  final pageController = PageController();

  List<String> urls = Resource.image.urls;

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
              if (_imageFile == null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: buildPageView(),
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPageView({int index = 0}) {
    final urls = Resource.image.urls;
    final pageController = PageController(initialPage: index);
    final indexVN = ValueNotifier(index);

    return Container(
      constraints: BoxConstraints(
        minHeight: 400,
        maxHeight: 600,
      ),
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: indexVN,
            builder: (context, value, child) {
              return Text("$value/${urls.length}");
            },
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                indexVN.value = index;
              },
              children: urls.map((e) {
                return OCRNetImageCard(
                  key: ValueKey(e),
                  avatar: e,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class OCRNetImageCard extends StatefulWidget {
  const OCRNetImageCard({
    super.key,
    required this.avatar,
  });

  final String? avatar;

  @override
  State<OCRNetImageCard> createState() => _OCRNetImageCardState();
}

class _OCRNetImageCardState extends State<OCRNetImageCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 保持页面活跃

  var recognitionText = ValueNotifier("");

  final isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    initData();
  }

  @override
  void didUpdateWidget(covariant OCRNetImageCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.avatar != oldWidget.avatar) {
      initData();
    }
  }

  Future<void> initData() async {
    isLoading.value = true;
    final text = await recognition(url: widget.avatar ?? "");
    isLoading.value = false;
    recognitionText.value = text;
  }

  /// 文字识别
  Future<String> recognition({required String url}) async {
    final file = await AssetCacheService().saveNetworkImage(url: url);
    final res = await OcrTextRecognitionManager().processImage(file);
    final text = (res.result ?? "").split("\n").join(" ");
    return Future(() => text);
  }

  @override
  Widget build(BuildContext context) {
    final avatar = widget.avatar ?? "";
    return Container(
      constraints: BoxConstraints(
        minHeight: 400,
        maxHeight: 600,
      ),
      // alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
        image: DecorationImage(
          alignment: Alignment.topCenter,
          opacity: 0.2,
          image: ExtendedNetworkImageProvider(
            avatar,
            cache: true,
          ),
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([
              isLoading,
              recognitionText,
            ]),
            builder: (context, child) {
              if (isLoading.value) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  child: CupertinoActivityIndicator(),
                );
              }

              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recognitionText.value,
                        // maxLines: 5,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
