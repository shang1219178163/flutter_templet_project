//
//  DeviceBrightnessAndVolumeControllerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/9/10 12:04.
//  Copyright © 2025/9/10 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';
import 'package:get/get.dart';
import 'package:volume_controller/volume_controller.dart';

class DeviceBrightnessAndVolumeControllerDemo extends StatefulWidget {
  const DeviceBrightnessAndVolumeControllerDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<DeviceBrightnessAndVolumeControllerDemo> createState() => _DeviceBrightnessAndVolumeControllerDemoState();
}

class _DeviceBrightnessAndVolumeControllerDemoState extends State<DeviceBrightnessAndVolumeControllerDemo> {
  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  double _brightness = 0.5;
  double _volume = 0.5;
  Offset? _startPosition;

  @override
  void initState() {
    super.initState();
    _initValues();
  }

  Future<void> _initValues() async {
    final currentBrightness = await FlutterScreenWake.brightness;
    final currentVolume = await VolumeController().getVolume();

    setState(() {
      _brightness = currentBrightness;
      _volume = currentVolume;
    });
  }

  void _onPanStart(DragStartDetails details) {
    _startPosition = details.localPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_startPosition == null) {
      return;
    }

    final dx = details.localPosition.dx - _startPosition!.dx;
    final dy = details.localPosition.dy - _startPosition!.dy;

    // 判断横向 or 纵向滑动
    if (dx.abs() > dy.abs()) {
      // 横向滑动（比如控制进度，这里先打印）
      debugPrint("调节进度: $dx");
    } else {
      // 纵向滑动，区分左右屏幕：左边控制亮度，右边控制音量
      final screenWidth = MediaQuery.of(context).size.width;
      if (_startPosition!.dx < screenWidth / 2) {
        // 左半屏调节亮度
        final delta = -dy / 300; // 调节灵敏度
        _brightness = (_brightness + delta).clamp(0.0, 1.0);
        FlutterScreenWake.setBrightness(_brightness);
        debugPrint("亮度: $_brightness");
      } else {
        // 右半屏调节音量
        final delta = -dy / 300;
        _volume = (_volume + delta).clamp(0.0, 1.0);
        VolumeController().setVolume(_volume, showSystemUI: false);
        debugPrint("音量: $_volume");
      }
    }
  }

  void _onPanEnd(DragEndDetails details) {
    _startPosition = null;
  }

  @override
  void didUpdateWidget(covariant DeviceBrightnessAndVolumeControllerDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

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
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Container(
        color: Colors.black,
        child: Center(
          child: Text(
            "左右滑动调节进度\n左边上下滑调亮度\n右边上下滑调音量",
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Text("$widget"),
          ],
        ),
      ),
    );
  }
}
