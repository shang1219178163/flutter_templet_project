import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_templet_project/mixin/safe_set_state_mixin.dart';

import 'package:flutter_templet_project/pages/demo/music/MusicLyricScrollWidget.dart';
import 'package:flutter_templet_project/vendor/audioplayers/audio_player_manager.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> with SafeSetStateMixin {
  late AudioPlayerManager _audioManager;
  List<LyricLine> _lyrics = [];
  // Duration _currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  final loopVN = ValueNotifier(false);

  @override
  void dispose() {
    _audioManager.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _audioManager = AudioPlayerManager();
    _loadLyrics();
    _setupAudioListeners();
  }

  Future<void> _loadLyrics() async {
    final assetFilePath = "assets/media/立心-国风集.河图.lrc";
    final lrcContent = await rootBundle.loadString(assetFilePath);
    _lyrics = parseLrc(lrcContent);
    setState(() {});
  }

  void _setupAudioListeners() {
    _audioManager.durationStream.listen((position) {
      totalDuration = position;
      setState(() {});
    });
    // _audioManager.positionStream.listen((position) {
    //   _currentPosition = position;
    //   // setState(() {});
    // });
  }

  void _onLyricSeek(Duration position) {
    _audioManager.seek(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('音乐播放器'),
      ),
      body: Column(
        children: [
          // 音频控制面板
          _buildAudioControls(),
          // 进度条
          _buildProgressBar(),
          // 歌词显示区域
          Expanded(
            child: LyricScrollWidget(
              lyrics: _lyrics,
              positionStream: _audioManager.positionStream,
              onSeek: _onLyricSeek,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioControls() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: loopVN,
            builder: (context, value, child) {
              return IconButton(
                icon: Icon(value ? Icons.repeat_one : Icons.loop),
                onPressed: () async {
                  loopVN.value = !loopVN.value;
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.skip_previous),
            onPressed: () async {
              // 上一首逻辑
            },
          ),
          if (!_audioManager.isPlaying)
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () async {
                if (_audioManager.isPaused) {
                  await _audioManager.resume();
                } else {
                  await _audioManager.play('media/立心-国风集.河图.mp3', isLoop: loopVN.value);
                }
                setState(() {});
              },
            ),
          if (_audioManager.isPlaying)
            IconButton(
              icon: Icon(Icons.pause),
              onPressed: () async {
                await _audioManager.pause();
                setState(() {});
              },
            ),
          IconButton(
            icon: Icon(Icons.skip_next),
            onPressed: () {
              // 下一首逻辑
            },
          ),
        ],
      );
    });
  }

  Widget _buildProgressBar() {
    return StreamBuilder<Duration>(
      stream: _audioManager.positionStream,
      builder: (context, snapshot) {
        final currentPosition = snapshot.data ?? Duration.zero;

        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 8.0, //默认
              pressedElevation: 0,
            ), //按下效果
          ),
          child: Slider(
            value: currentPosition.inMilliseconds.toDouble(),
            min: 0,
            max: totalDuration.inMilliseconds.toDouble(),
            onChanged: (value) {
              final position = Duration(milliseconds: value.toInt());
              _audioManager.seek(position);
            },
          ),
        );
      },
    );

    // return StreamBuilder<Duration>(
    //   stream: _audioManager.durationStream,
    //   builder: (context, snapshot) {
    //     final totalDuration = snapshot.data ?? Duration.zero;
    //
    //     return Slider(
    //       value: _currentPosition.inMilliseconds.toDouble(),
    //       min: 0,
    //       max: totalDuration.inMilliseconds.toDouble(),
    //       onChanged: (value) {
    //         final position = Duration(milliseconds: value.toInt());
    //         _audioManager.seek(position);
    //       },
    //     );
    //   },
    // );
  }

  // 解析 LRC 歌词文件
  List<LyricLine> parseLrc(String lrcContent) {
    final lines = lrcContent.split('\n');
    final List<LyricLine> lyrics = [];
    final RegExp regExp = RegExp(r'\[(\d+):(\d+\.?\d*)\]');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final matches = regExp.allMatches(line);

      if (matches.isNotEmpty) {
        final timeMatch = matches.first;
        final minutes = int.parse(timeMatch.group(1)!);
        final seconds = double.parse(timeMatch.group(2)!);
        final duration = Duration(
          minutes: minutes,
          seconds: seconds.toInt(),
          milliseconds: ((seconds - seconds.toInt()) * 1000).round(),
        );

        final lyricText = line.substring(timeMatch.end);

        lyrics.add(LyricLine(
          startTime: duration,
          endTime: i + 1 < lyrics.length ? lyrics[i + 1].startTime : duration + const Duration(seconds: 5),
          text: lyricText.trim(),
        ));
      }
    }

    return lyrics;
  }
}
