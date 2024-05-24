//
//  AudioPlayerManager.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/5/23 14:21.
//  Copyright © 2024/5/23 shang. All rights reserved.
//

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';

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

  late final player = AudioPlayer();

  init() async {}

  destory() {
    player.dispose();
  }

  /// 停止播放音频
  Future<void> stop() async {
    return await player.stop();
  }

  /// 暂停播放音频
  Future<void> pause() async {
    return await player.pause();
  }

  /// 继续播放音频
  Future<void> resume() async {
    return await player.resume();
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
    player.setReleaseMode(model);

    await player.stop();
    final source = url.startsWith("http") ? UrlSource(url) : AssetSource(url);
    await player.play(source);
  }

  /// 播放/停止
  playback(String url, {bool isLoop = false}) async {
    if (player.state == PlayerState.playing) {
      await stop();
    } else {
      await play(url, isLoop: isLoop);
    }
  }
}
