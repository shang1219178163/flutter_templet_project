import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/duration_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
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

class _AudioPlayerBarState extends State<AudioPlayerBar> {
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
    player.stop();
    player.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
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
