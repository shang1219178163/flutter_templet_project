//
//  VolumeAndBrightnessMixin.dart
//  projects
//
//  Created by shang on 2026/1/30 12:23.
//  Copyright © 2026/1/30 shang. All rights reserved.
//

import 'package:flutter/material.dart';
// import 'package:volume_controller/volume_controller.dart';
import 'package:screen_brightness/screen_brightness.dart';

/// 横屏音量和屏幕亮度管理
mixin VolumeAndBrightnessMixin<W extends StatefulWidget, T> on State<W> {
  late var mediaQuery = MediaQuery.of(context);

  final showBrightnessProgressVN = ValueNotifier(false);
  final showVolumeOrBrightnessProgressVN = ValueNotifier(false);

  double _brightness = 0.5;
  late final brightnessVN = ValueNotifier(_brightness);
  double _volume = 0.5;
  late final volumeVN = ValueNotifier(_volume);

  Offset? _startPosition;

  OverlayEntry? _overlayEntry;

  /// 溢出图层
  void _removeBrightnessIndicator() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initValues();
  }

  Future<void> _initValues() async {
    // final currentBrightness = await FlutterScreenWake.brightness;
    final currentBrightness = await ScreenBrightness.instance.system;
    // final currentVolume = await VolumeController.instance.getVolume();
    // VolumeController.instance.showSystemUI = false;

    _brightness = currentBrightness;
    // _volume = currentVolume;
    brightnessVN.value = _brightness;
    volumeVN.value = _volume;

    showVolumeOrBrightnessProgressVN.value = false;
    setState(() {});

    // debugPrint("_initValues: currentBrightness:${currentBrightness}, currentVolume:$currentVolume");
  }

  Future<void> onPanStartForVolumeAndBrightness(DragStartDetails details) async {
    mediaQuery = MediaQuery.of(context);
    // if (mediaQuery.orientation != Orientation.landscape) {
    //   return;
    // }
    showVolumeOrBrightnessProgressVN.value = true;
    _startPosition = details.localPosition;
    debugPrint("_onPanStart: ${details.localPosition}");

    final isLeft = details.localPosition.dx < mediaQuery.size.width * 0.5;
    // showBrightnessIndicator(isLeft: isLeft);
    showBrightnessProgressVN.value = isLeft;

    _brightness = await ScreenBrightness.instance.system;
    brightnessVN.value = _brightness;
  }

  Future<void> onPanUpdateForVolumeAndBrightness(DragUpdateDetails details) async {
    // if (mediaQuery.orientation != Orientation.landscape) {
    //   return;
    // }
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
      final screenWidth = mediaQuery.size.width;
      if (_startPosition!.dx < screenWidth / 2) {
        // 左半屏调节亮度
        // final delta = -dy / (400 * 2); // 调节灵敏度
        final delta = -dy / 2000; // 调节灵敏度
        _brightness = (_brightness + delta).clamp(0, 1.0);
        debugPrint(
            "亮度: ${[_brightness, (_brightness + delta), delta, dy].map((e) => e.toStringAsFixed(2)).toList().asMap()}");

        try {
          brightnessVN.value = _brightness;
          ScreenBrightness.instance.setSystemScreenBrightness(_brightness);
        } catch (e) {
          debugPrint(e.toString());
          throw '❌Failed to set system brightness';
        }
      } else {
        // 右半屏调节音量
        final delta = -dy / 1000;
        _volume = (_volume + delta).clamp(0.0, 1.0);
        volumeVN.value = _volume;
        debugPrint("音量: ${[_volume, (_volume + delta), delta, dy].map((e) => e.toStringAsFixed(2)).toList().asMap()}");
        VolumeController.instance.setVolume(_volume);
        debugPrint("音量: $_volume");
      }
    }
  }

  Future<void> onPanEndForVolumeAndBrightness(DragEndDetails details) async {
    // if (mediaQuery.orientation != Orientation.landscape) {
    //   return;
    // }
    _startPosition = null;
    debugPrint("_onPanEnd: ${details.localPosition}");

    await Future.delayed(const Duration(milliseconds: 800));
    showVolumeOrBrightnessProgressVN.value = false;
    _removeBrightnessIndicator();
  }

  // /// 展示图层
  // void showBrightnessIndicator({required bool isLeft}) {
  //   // final theme = Theme.of(context);
  //   // final isDark = theme.brightness == Brightness.dark;
  //   // final color242434OrWhite = isDark ? Color(0xFF242434) : Colors.white;
  //   // final inverseColor = isDark ? Colors.white : Colors.black;
  //
  //   final child = Align(
  //     alignment: Alignment.center,
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 28),
  //       child: isLeft
  //           ? BrightnessProgressIndicator(
  //               valueVN: brightnessVN,
  //             )
  //           : VolumeProgressIndicator(
  //               valueVN: volumeVN,
  //             ),
  //     ),
  //   );
  //
  //   if (_overlayEntry != null) {
  //     _removeBrightnessIndicator();
  //     return;
  //   }
  //
  //   _overlayEntry = OverlayEntry(
  //     builder: (BuildContext context) {
  //       return child;
  //     },
  //   );
  //   Overlay.of(context).insert(_overlayEntry!);
  // }
}
