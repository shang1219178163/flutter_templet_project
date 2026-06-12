//
//  AppVideoPlayerService.dart
//  flutter_templet_project
//
//  Created by shang on 2025/12/12 18:10.
//  Copyright © 2025/12/12 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:quiver/collection.dart';
import 'package:video_player/video_player.dart';

/// 视频播放控制器全局管理(安卓不支持多控制器,不可控不可测的视频解码错误)
/// 视频播放控制器全局管理
class AppVideoPlayerService {
  AppVideoPlayerService._();
  static final AppVideoPlayerService _instance = AppVideoPlayerService._();
  factory AppVideoPlayerService() => _instance;
  static AppVideoPlayerService get instance => _instance;

  LruMap<String, VideoPlayerController> get controllerMap => _controllerMap;
  final _controllerMap = LruMap<String, VideoPlayerController>(maximumSize: 2);

  final playerVN = ValueNotifier<VideoPlayerController?>(null);

  String get controllerMapJson {
    final result = <String, dynamic>{};
    for (final entry in controllerMap.entries) {
      final newEntry = MapEntry(entry.key, [
        entry.value.hashCode,
        entry.value.dataSource,
      ]);
      result[newEntry.key] = newEntry.value;
    }
    final mapJson = jsonEncode(result);
    return mapJson;

    final map = controllerMap.map(
      (k, v) => MapEntry(k, [v.hashCode, v.dataSource]),
    );
    final mapJsonNew = jsonEncode(map);
    return mapJsonNew;
  }

  /// 有缓存控制器
  bool hasCtrl({required String url}) => _controllerMap[url] != null;

  /// 获取缓存控制器
  VideoPlayerController? getCacheCtrl({required String url}) => _controllerMap[url];

  /// 是网络视频
  static bool isVideo(String? url) {
    if (url?.startsWith("http") != true) {
      return false;
    }

    final videoUri = Uri.tryParse(url!);
    if (videoUri == null) {
      return false;
    }

    final videoExt = ['.mp4', '.mov', '.avi', '.wmv', '.flv', '.mkv', '.webm'];
    final ext = url.toLowerCase();
    final result = videoExt.any((e) => ext.endsWith(e));
    return result;
  }

  /// 获取 VideoPlayerController
  Future<VideoPlayerController?> getController(String url, {bool isLog = false}) async {
    assert(url.startsWith("http"), "必须是视频链接,请检查链接是否合法");
    final videoUri = Uri.tryParse(url);
    if (videoUri == null) {
      return null;
    }

    if (playerVN.value?.dataSource == "$videoUri") {
      DLog.d(["缓存对象", playerVN.value.hashCode, videoUri]);
      return playerVN.value;
    }

    if (playerVN.value?.value.isPlaying == true) {
      await playerVN.value?.pause();
    }
    await playerVN.value?.dispose();
    final videoController = VideoPlayerController.networkUrl(
      videoUri,
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    );
    await videoController.initialize();
    // await Future.delayed(const Duration(milliseconds: 300));
    playerVN.value = videoController;
    DLog.d(["新建对象", playerVN.value.hashCode, videoUri]);
    return videoController;
  }

  /// 播放
  Future<void> play({required String url, bool onlyOne = true}) async {
    if (playerVN.value?.dataSource != url) {
      await getController(url);
    }
    if (playerVN.value?.value.isPlaying == true) {
      playerVN.value?.pause();
    } else {
      playerVN.value?.play();
    }
  }

  /// 暂停所有视频
  Future<void> pauseAll() async {
    playerVN.value?.pause();
    for (final e in _controllerMap.entries) {
      await e.value.pause();
    }
  }

  void clearVideoPlayerControlers() {
    _controllerMap.clear();
  }

  @override
  String toString() {
    return "$runtimeType $controllerMapJson";
  }
}
