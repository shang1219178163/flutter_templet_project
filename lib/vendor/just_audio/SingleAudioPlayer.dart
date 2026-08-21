import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AppAudioPlayer {
  static final AppAudioPlayer _instance = AppAudioPlayer._();

  factory AppAudioPlayer() => _instance;

  AppAudioPlayer._();

  final player = AudioPlayer();
  final List<StreamSubscription> _subscriptions = [];
  bool _initialized = false;

  /// 初始化播放器（幂等）
  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // 电话插拔/焦点处理
    _subscriptions.add(
      session.interruptionEventStream.listen((event) {
        if (event.begin) {
          player.pause();
        }
      }),
    );

    // 事件监听（可用于 UI）
    _subscriptions.add(
      player.playerStateStream.listen((state) {
        debugPrint("PlayerState: $state");
      }),
    );
  }

  /// 播放 url
  Future<void> playUrl(String url) async {
    try {
      await player.setUrl(url);
      await player.play();
    } catch (e, s) {
      debugPrint("AppAudioPlayer.playUrl failed: $e\n$s");
      rethrow;
    }
  }

  /// 停止
  Future<void> stop() async {
    await player.stop();
  }

  /// 销毁（一次性；调用后不可再使用本单例）
  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    await player.dispose();
    _initialized = false;
  }
}
