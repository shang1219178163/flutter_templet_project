//
//  TextToSpeechManager.dart
//  projects
//
//  Created by shang on 2024/11/28 16:22.
//  Copyright © 2024/11/28 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter_tts/flutter_tts.dart';

/*
* 魅族手机无此语音合并功能模块,无声音正常
* */

enum TTSManagerPlayerState {
  /// initial state, stop has been called or an error occurred.
  stopped,

  /// Currently playing audio.
  playing,

  /// Pause has been called.
  paused,

  /// The audio successfully completed (reached the end).
  completed,
}

/// 文字转语音
class TTSManager {
  static final TTSManager _instance = TTSManager._();

  TTSManager._() {
    // init();
  }

  factory TTSManager() => _instance;

  static TTSManager get instance => _instance;

  final flutterTts = FlutterTts();

  bool _initial = false;

  TTSManagerPlayerState playerState = TTSManagerPlayerState.stopped;

  /// 当前播放段落
  String? _current;

  /// 异常
  String _exception = "";

  String get exception => _exception;

  /// 初始化方法
  Future<bool> init() async {
    if (_initial) {
      // debugPrint("$runtimeType 过去已初始化!");
      return _initial;
    }

    try {
      //设置语音语言
      await flutterTts.setLanguage("zh-CN");
      //设置语音速率
      await flutterTts.setSpeechRate(Platform.isAndroid ? 0.7 : 0.7 / 4 * 3);
      //设置语音音量
      await flutterTts.setVolume(0.5);
      //设置语音音调
      await flutterTts.setPitch(1.0);
      if (Platform.isIOS) {
        await flutterTts.setSharedInstance(true);
        await flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.ambient,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          ],
          IosTextToSpeechAudioMode.voicePrompt,
        );
      }

      flutterTts.setErrorHandler((message) {
        DLog.d("setErrorHandler: $message");
      });

      flutterTts.setInitHandler(() {
        DLog.d("✅ $runtimeType flutterTts 初始完成!!!");
      });

      flutterTts.setStartHandler(() {
        playerState = TTSManagerPlayerState.playing;
        onStateChanged(playerState);
      });

      flutterTts.setPauseHandler(() {
        playerState = TTSManagerPlayerState.paused;
        onStateChanged(playerState);
      });

      flutterTts.setCompletionHandler(() {
        playerState = TTSManagerPlayerState.completed;
        onStateChanged(playerState);
      });

      flutterTts.setCancelHandler(() {
        playerState = TTSManagerPlayerState.completed;
        onStateChanged(playerState);
      });

      _initial = true;
    } catch (e) {
      _exception = e.toString();
      debugPrint("$runtimeType 初始化错误 $e");
      _initial = false;
    }
    return _initial;
  }

  void onStateChanged(TTSManagerPlayerState state) {
    DLog.d("✅ $runtimeType flutterTts playerState: $state");
  }

  /// 播报中时,再次点击同一条停止;非同一条重新播放
  Future<dynamic> speak({String text = ""}) async {
    assert(text.isNotEmpty == true, "❌ $this text?.isNotEmpty == true");
    final emojiRegex = RegExp(
      "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]",
      unicode: true,
    );
    final before = text;
    text = text.replaceAll(emojiRegex, '');
    DLog.d("$runtimeType 语音播报文字(文字/总字符): ${text.length}/${before.length} ${text.isEmpty ? "无可播报文字" : ""} $playerState");
    if (text.isNotEmpty != true) {
      return;
    }

    await init();
    final isSameText = _current == text;
    if (playerState == TTSManagerPlayerState.playing && isSameText) {
      DLog.d("✅ $runtimeType flutterTts.stop: $_current");
      return stop();
    }

    if (playerState == TTSManagerPlayerState.playing) {
      // 停止旧播放
      await stop();
    }

    _current = text;
    if (Platform.isAndroid) {
      final segmentLength = await flutterTts.getMaxSpeechInputLength ?? 4000;
      DLog.d("✅ $runtimeType flutterTts getMaxSpeechInputLength: $segmentLength");

      final readContents = text.splitStride(by: segmentLength);
      // DLog.d("✅ $this speak: ${readContents.join("><")}");
      for (final content in readContents) {
        DLog.d("✅ $runtimeType flutterTts speak: $content");
        await flutterTts.speak(content);
        await Future.delayed(const Duration(milliseconds: 500)); // 加入延迟，避免语音播放冲突
      }
      return;
    }
    DLog.d("✅ $runtimeType flutterTts speak: $_current");
    return flutterTts.speak(_current ?? "");
  }

  Future<dynamic> pause({String? text}) async {
    playerState = TTSManagerPlayerState.paused;
    onStateChanged(playerState);
    return flutterTts.pause();
  }

  Future<dynamic> stop({String? text}) async {
    // playerState = TTSManagerPlayerState.completed;
    // onStateChanged(playerState);
    return flutterTts.stop();
  }

// /// 播放停止
// Future<dynamic> toggle({String? text}) async {
//   if (playerState == TTSManagerPlayerState.playing && _current == text) {
//     return await stop();
//   } else {
//     return await speak(text: text ?? "");
//   }
// }
}
