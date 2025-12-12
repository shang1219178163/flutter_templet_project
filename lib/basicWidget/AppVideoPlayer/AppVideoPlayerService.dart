//
//  AppVideoPlayerService.dart
//  flutter_templet_project
//
//  Created by shang on 2025/12/12 18:10.
//  Copyright © 2025/12/12 shang. All rights reserved.
//

import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:quiver/collection.dart';
import 'package:video_player/video_player.dart';

/// 视频播放控制器全局管理
class AppVideoPlayerService {
  AppVideoPlayerService._();
  static final AppVideoPlayerService _instance = AppVideoPlayerService._();
  factory AppVideoPlayerService() => _instance;
  static AppVideoPlayerService get instance => _instance;

  /// 播放器字典
  LruMap<String, VideoPlayerController> get controllerMap => _controllerMap;
  // final _controllerMap = <String, VideoPlayerController>{};
  final _controllerMap = LruMap<String, VideoPlayerController>(maximumSize: 10);

  /// 最新使用播放器
  VideoPlayerController? current;

  /// 有缓存控制器
  bool hasCtrl({required String url}) => _controllerMap[url] != null;

  /// 是网络视频
  static bool isVideo(String? url) {
    if (url?.isNotEmpty != true) {
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
    final vc = _controllerMap[url];
    if (vc != null) {
      current = vc;
      if (isLog) {
        DLog.d(["缓存: ${vc.hashCode}"]);
      }
      return vc;
    }

    final videoUri = Uri.tryParse(url);
    if (videoUri == null) {
      return null;
    }

    final ctrl = VideoPlayerController.networkUrl(videoUri);
    await ctrl.initialize();
    _controllerMap[url] = ctrl;
    current = ctrl;
    if (isLog) {
      DLog.d(["新建: ${_controllerMap[url].hashCode}"]);
    }
    return ctrl;
  }

  /// 播放
  Future<void> play({required String url, bool onlyOne = true}) async {
    await getController(url);
    for (final e in _controllerMap.entries) {
      if (e.key == url) {
        if (!e.value.value.isPlaying) {
          e.value.play();
        } else {
          e.value.pause();
        }
      } else {
        if (onlyOne) {
          e.value.pause();
        }
      }
    }
  }

  /// 暂停所有视频
  void pauseAll() {
    for (final e in _controllerMap.entries) {
      e.value.pause();
    }
  }

  void dispose(String url) {
    _controllerMap[url]?.dispose();
    _controllerMap.remove(url);
  }

  void disposeAll() {
    for (final c in _controllerMap.values) {
      c.dispose();
    }
    _controllerMap.clear();
  }
}
