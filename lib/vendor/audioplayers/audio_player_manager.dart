//
//  AudioPlayerManager.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/5/23 14:21.
//  Copyright © 2024/5/23 shang. All rights reserved.
//

import 'package:audioplayers/audioplayers.dart';

// await AudioPlayerManager().playWaitCallingMp3();
//
// await AudioPlayerManager().stop();

/// 呼叫铃声
const wait_calling_mp3 = "https://yl-oss.yljt.cn/wait_calling.mp3";

/// 挂机铃声
const hang_up_mp3 = "https://yl-oss.yljt.cn/hang_up.mp3";

/// 声音播放管理器
class AudioPlayerManager {
  AudioPlayerManager._() {
    init();
  }

  static final AudioPlayerManager _instance = AudioPlayerManager._();
  factory AudioPlayerManager() => _instance;

  late final _audioPlayer = AudioPlayer();

  // var playerState = PlayerState.stopped;
  // var currentPosition = Duration.zero;
  // var totalDuration = Duration.zero;

  bool get isPlaying => _audioPlayer.state == PlayerState.playing;

  Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;
  Stream<Duration> get durationStream => _audioPlayer.onDurationChanged;
  Stream<PlayerState> get stateStream => _audioPlayer.onPlayerStateChanged;

  init() async {}

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }

  /// 停止播放音频
  Future<void> stop() async {
    return _audioPlayer.stop();
  }

  /// 暂停播放音频
  Future<void> pause() async {
    return _audioPlayer.pause();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// 继续播放音频
  Future<void> resume() async {
    return _audioPlayer.resume();
  }

  // 播放循环音频呼叫铃声
  Future<void> playWaitCallingMp3() async {
    // return; //test by bin
    return play(wait_calling_mp3, isLoop: true);
  }

  // 播放挂机音频
  Future<void> playHangUpMp3() async {
    return play(hang_up_mp3, isLoop: false);
  }

  // 播放循环音频
  Future<void> play(String url, {bool isLoop = false}) async {
    final model = isLoop ? ReleaseMode.loop : ReleaseMode.stop;
    _audioPlayer.setReleaseMode(model);

    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.stop();
    }
    final source = url.startsWith("http") ? UrlSource(url) : AssetSource(url);
    await _audioPlayer.play(source);
  }

  /// 播放/停止
  Future<void> playback(String url, {bool isLoop = false}) async {
    if (_audioPlayer.state == PlayerState.playing) {
      await stop();
    } else {
      await play(url, isLoop: isLoop);
    }
  }
}
