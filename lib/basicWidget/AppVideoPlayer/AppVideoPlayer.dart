import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



/// 播放器
class AppVideoPlayer extends StatefulWidget {
  const AppVideoPlayer({
    super.key,
    this.controller,
    required this.url,
    this.autoPlay = true,
    this.looping = false,
    this.aspectRatio = 16 / 9,
    this.isPortrait = true,
    this.fullScreenVN,
    this.onFullScreen,
    this.onClose,
  });

  final AppVideoPlayerController? controller;

  final String url;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;

  /// 设备方向
  final bool isPortrait;

  final ValueNotifier<bool>? fullScreenVN;

  final void Function(bool isFullScreen)? onFullScreen;

  final VoidCallback? onClose;

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  Duration position = Duration.zero;

  @override
  void dispose() {
    widget.controller?._detach(this);
    _onClose();
    // 不销毁 VideoPlayerController，让全局复用
    // _chewieController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPlayer();
    });
  }

  Future<void> initPlayer() async {
    // DLog.d(widget.url.split("/").last);
    assert(widget.url.startsWith("http"), "url 错误");

    _videoController = await AppVideoPlayerService.instance.getController(widget.url);

    _chewieController?.dispose();
    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      aspectRatio: widget.aspectRatio,
      autoInitialize: true,
      allowFullScreen: true,
      allowMuting: false,
      showControlsOnInitialize: false,
      // customControls: const AppVideoControls(),
    );

    _chewieController!.addListener(() {
      final isFullScreen = _chewieController!.isFullScreen;
      widget.fullScreenVN?.value = isFullScreen;
      widget.onFullScreen?.call(isFullScreen);
      if (isFullScreen) {
        DLog.d("进入全屏");
      } else {
        DLog.d("退出全屏");
      }
    });
    if (mounted) setState(() {});
  }

  Future<void> _onClose() async {
    if (_videoController?.value.isPlaying == true) {
      _videoController?.pause();
    }
  }

  @override
  void didUpdateWidget(covariant AppVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      initPlayer();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// 🔥屏幕横竖切换时 rebuild Chewie，但不 rebuild video
    DLog.d([MediaQuery.of(context).orientation]);
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.url.startsWith("http") != true) {
      return const SizedBox();
    }

    if (_chewieController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    // return Chewie(controller: _chewieController!);
    return Stack(
      children: [
        Positioned.fill(
          child: Chewie(
            controller: _chewieController!,
          ),
        ),
        Positioned(
          right: 20,
          top: 10,
          child: Container(
            // decoration: BoxDecoration(
            //   color: Colors.red,
            //   border: Border.all(color: Colors.blue),
            // ),
            child: buildCloseBtn(onTap: widget.onClose),
          ),
        ),
      ],
    );
  }

  Widget buildCloseBtn({VoidCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        DLog.d("buildCloseBtn");
        _onClose();
        if (onTap != null) {
          onTap();
          return;
        }
        Navigator.pop(context);
      },
      child: Container(
        // padding: EdgeInsets.all(6),
        // decoration: BoxDecoration(
        //   color: Colors.black54,
        //   shape: BoxShape.circle,
        //   border: Border.all(color: Colors.blue),
        // ),
        child: const Icon(Icons.close, color: Colors.white, size: 24),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AppVideoPlayerController {
  _AppVideoPlayerState? _anchor;

  void _attach(_AppVideoPlayerState anchor) {
    _anchor = anchor;
  }

  void _detach(_AppVideoPlayerState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  VideoPlayerController? get videoController {
    assert(_anchor != null);
    return _anchor!._videoController;
  }

  ChewieController? get chewieController {
    assert(_anchor != null);
    return _anchor!._chewieController;
  }
}
