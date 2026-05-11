
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:video_player/video_player.dart';

///足球赛事-资讯Provider
mixin ChewiePlayerMixin on ChangeNotifier {
  VideoPlayerController? videoController;
  ChewieController? playController;
  bool isPlaying = false;
  String _videoUrl = "";

  @override
  void dispose() {
    playController?.dispose();
    videoController?.dispose();
    super.dispose();
  }

  Future<void> preloadVideo(String url) async {
    _videoUrl = url;
    if (url.isEmpty) {
      return;
    }
    if (playController == null) {
      videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      debugPrint("$runtimeType videoControllerInit=$videoController");
      await videoController?.initialize();

      debugPrint("VideoMixin videoControllerEnd=$videoController");
      playController = ChewieController(
        videoPlayerController: videoController!,
        autoPlay: false,
        looping: false,
        allowFullScreen: false,
        allowPlaybackSpeedChanging: false,
        showControls: true,
        autoInitialize: true,
        customControls: CupertinoControls(
          backgroundColor: Colors.black.withOpacity(0.8),
          iconColor: Colors.white,
        ),
      );
    }

    notifyListeners();
  }

  /// 播放指定视频
  Future<void> playVideo() async {
    if (_videoUrl.isEmpty) {
      SmartDialog.showToast("视频地址错误，播放失败");
      return;
    }
    if (!isPlaying) {
      isPlaying = true;
      playController?.play();
      notifyListeners();
    }
  }

  /// 暂停播放
  void pauseVideo() {
    if (isPlaying) {
      isPlaying = false;
      playController?.pause();
      notifyListeners();
    }
  }
}
