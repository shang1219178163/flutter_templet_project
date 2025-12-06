import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';

class AppAudioPlayer {
  static final AppAudioPlayer _instance = AppAudioPlayer._();
  factory AppAudioPlayer() => _instance;
  AppAudioPlayer._();

  final player = AudioPlayer();

  // 初始化播放器
  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // 电话插拔/焦点处理
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        player.pause();
      }
    });

    // 事件监听（可用于 UI）
    player.playerStateStream.listen((state) {
      debugPrint("PlayerState: $state");
    });
  }

  // 播放 url
  Future<void> playUrl(String url) async {
    await player.setUrl(url);
    player.play();
  }

  // 停止
  Future<void> stop() async {
    await player.stop();
  }

  // 销毁
  Future<void> dispose() async {
    await player.dispose();
  }
}
