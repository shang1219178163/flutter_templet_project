import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/duration_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/mixin/safe_set_state_mixin.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:path/path.dart';

/// 音频播放 bar
class AudioPlayerBar extends StatefulWidget {
  const AudioPlayerBar({
    super.key,
    required this.url,
    this.duration,
    this.onDuration,
  });

  /// 链接
  final String url;

  /// 时长
  final Duration? duration;

  /// 时长回调
  final ValueChanged<Duration>? onDuration;

  @override
  State<StatefulWidget> createState() => _AudioPlayerBarState();
}

class _AudioPlayerBarState extends State<AudioPlayerBar>
    with WidgetsBindingObserver {
  AudioPlayer player = AudioPlayer();
  PlayerState? _playerState;
  late Duration? _duration = widget.duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;

  String? get _positionText => _position?.toTime();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    player.setReleaseMode(ReleaseMode.stop);

    // Start the player as soon as the app is displayed.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(UrlSource(widget.url));
      await player.resume();
    });

    // Use initial values from player
    _playerState = player.state;
    player.getDuration().then((value) {
      if (value == null) {
        return;
      }
      _duration = value;
      widget.onDuration?.call(value);
      setState(() {});
    });

    player.getCurrentPosition().then((value) {
      _position = value;
      setState(() {});
    });
    _initStreams();
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    player.stop();
    player.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // debugPrint("$widget didChangeAppLifecycleState: $state");

    switch (state) {
      //进入应用时候不会触发该状态 应用程序处于可见状态，并且可以响应用户的输入事件。它相当于 Android 中Activity的onResume
      case AppLifecycleState.resumed:
        // print("应用进入前台======");
        _play();
        break;
      //应用状态处于闲置状态，并且没有用户的输入事件，
      // 注意：这个状态切换到 前后台 会触发，所以流程应该是先冻结窗口，然后停止UI
      case AppLifecycleState.inactive:
        // print("应用处于闲置状态，这种状态的应用应该假设他们可能在任何时候暂停 切换到后台会触发======");
        _pause();
        break;
      //当前页面即将退出
      case AppLifecycleState.detached:
        // print("当前页面即将退出======");
        break;
      // 应用程序处于不可见状态
      case AppLifecycleState.paused:
        // print("应用处于不可见状态 后台======");
        break;
      case AppLifecycleState.hidden:
        // print("AppLifecycleState- hidden");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.startsWith("http") != true) {
      debugPrint("$widget 无效链接: $url");
      return const SizedBox();
    }
    final imgPath = _isPlaying
        ? 'assets/images/icon_pause.png'
        : 'assets/images/icon_play.png';

    final totalDesc = _duration == null ? "--" : _duration!.toTime();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12).copyWith(top: 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(29),
        border: Border.all(width: 0.5, color: lineColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: _isPlaying ? _pause : _play,
            child: Image(
              image: imgPath.toAssetImage(),
              width: 20,
              height: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: NText(
              _positionText ?? "",
              fontSize: 14,
              color: fontColor737373,
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                minHeight: 4,
                // 进度值，范围为0到1
                value: (_position != null &&
                        _duration != null &&
                        _position!.inMilliseconds > 0 &&
                        _position!.inMilliseconds < _duration!.inMilliseconds)
                    ? _position!.inMilliseconds / _duration!.inMilliseconds
                    : 0.0,
                backgroundColor:
                    const Color(0xFF5D6D7E).withOpacity(0.16), // 背景颜色
                valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF5D6D7E)), // 进度条颜色
              ),
            ),
          ),
          const SizedBox(
            width: 11,
          ),
          NText(
            totalDesc,
            fontSize: 14,
            color: fontColor737373,
          ),
        ],
      ),
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      if (_duration?.toTime() == duration.toTime()) {
        return;
      }
      _duration = duration;
      widget.onDuration?.call(duration);
      setState(() {});
    });

    _positionSubscription = player.onPositionChanged.listen((p) {
      _position = p;
      setState(() {});
    });

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
      setState(() {});
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      _playerState = state;
      setState(() {});
    });
  }

  Future<void> _play() async {
    await player.resume();
    _playerState = PlayerState.playing;
    setState(() {});
  }

  Future<void> _pause() async {
    await player.pause();
    _playerState = PlayerState.paused;
    setState(() {});
  }

  Future<void> _stop() async {
    await player.stop();
    _playerState = PlayerState.stopped;
    _position = Duration.zero;
    setState(() {});
  }
}
