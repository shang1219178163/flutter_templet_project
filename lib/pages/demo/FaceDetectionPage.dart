//
//  FaceDetectionPage.dart
//  flutter_templet_project
//
//  Created by shang on 2025/2/7 12:07.
//  Copyright © 2025/2/7 shang. All rights reserved.
//

import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

/// 面部特征识别
class FaceDetectionPage extends StatefulWidget {
  const FaceDetectionPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<FaceDetectionPage> createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  final _scrollController = ScrollController();

  final _picker = ImagePicker();
  String? _photoPath;
  String? _videoPath;
  String? _coverImagePath;
  String? _resultImagePath;

  final options = FaceDetectorOptions();
  late final faceDetector = FaceDetector(options: options);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            if (_photoPath == null)
              GestureDetector(
                onTap: _pickImage,
                child: Icon(
                  Icons.image,
                  color: Colors.grey.withOpacity(0.5),
                  size: 100,
                ),
              ),
            if (_photoPath != null)
              GestureDetector(
                onTap: _pickImage,
                child: Image.file(
                  File(_photoPath!),
                  width: 100,
                ),
              ),
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Pick a Video'),
            ),
            if (_videoPath != null) ...[
              Text('Video selected: $_videoPath'),
              SizedBox(height: 20),
            ],
            if (_coverImagePath != null) ...[
              Image.file(File(_coverImagePath!)),
            ],
            if (_resultImagePath == null) ...[
              Text('Face detected, 未识别到'),
            ]
          ],
        ),
      ),
    );
  }

  // 选择照片
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photoPath = pickedFile.path;
      });
      _detectFaceInPhoto(pickedFile.path);
    }
  }

  // 选择视频
  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    _videoPath = pickedFile.path;
    await _extractCoverImageFromVideo(pickedFile.path);
    setState(() {});
  }

  // 检测照片中的人脸
  Future<void> _detectFaceInPhoto(String photoPath) async {
    final inputImage = InputImage.fromFilePath(photoPath);
    final faces = await faceDetector.processImage(inputImage);

    if (faces.isNotEmpty) {
      // 如果有检测到人脸，开始提取视频帧
      await _extractFramesFromVideo();
    }
  }

  // 提取视频中的帧
  Future<void> _extractFramesFromVideo() async {
    if (_videoPath == null) {
      return;
    }

    // 创建临时目录来保存视频帧
    final tempDir = Directory.systemTemp.createTempSync('video_frames_');
    final outputDir = tempDir.path;

    await FFmpegKit.execute('-i $_videoPath -vf fps=1 $outputDir/frame_%03d.jpg');

    // 查找并检测帧中的人脸
    final frames = Directory(outputDir).listSync();
    for (final frame in frames) {
      final framePath = frame.path;
      final result = await _detectFaceInFrame(framePath);
      if (result) {
        // 如果找到匹配的人脸，截取该帧
        _resultImagePath = framePath;
        setState(() {});
        break;
      }
    }
  }

  // 提取视频封面图像
  // 提取视频封面图像
  Future<void> _extractCoverImageFromVideo(String videoPath) async {
    // 创建临时目录来保存封面图像
    final tempDir = Directory.systemTemp.createTempSync('video_cover_');
    final coverImagePath = '${tempDir.path}/cover.jpg';

    // 使用 FFmpeg 提取视频的第一帧
    final command = '-i $videoPath -vframes 1 -an -s 1920x1080 $coverImagePath';

    // 执行 FFmpeg 命令
    final session = await FFmpegKit.execute(command);

    // 检查执行状态
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      _coverImagePath = coverImagePath;
      setState(() {});
    } else {
      debugPrint("Failed to extract cover image from video. Error: $returnCode");
    }
  }

  // 检测视频帧中的人脸
  Future<bool> _detectFaceInFrame(String framePath) async {
    final inputImage = InputImage.fromFilePath(framePath);

    final faces = await faceDetector.processImage(inputImage);
    return faces.isNotEmpty;
  }
}
