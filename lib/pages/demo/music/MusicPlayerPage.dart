import 'package:flutter/material.dart';
import 'package:flutter_templet_project/pages/demo/music/MusicLyricScrollWidget.dart';
import 'package:flutter_templet_project/vendor/audioplayers/audio_player_manager.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late AudioPlayerManager _audioManager;
  List<LyricLine> _lyrics = [];
  Duration _currentPosition = Duration.zero;

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
//     const lrcContent = '''
// [00:00.00]歌曲开始
// [00:15.50]第一句歌词
// [00:20.30]第二句歌词
// [00:25.10]第三句歌词
// [00:30.00]第四句歌词
// ''';

    final assetFilePath = "assets/media/立心-国风集.河图.lrc";
    String lrcContent = await rootBundle.loadString(assetFilePath);
    _lyrics = parseLrc(lrcContent);
  }

  void _setupAudioListeners() {
    _audioManager.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
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
          // 歌词显示区域
          Expanded(
            child: LyricScrollWidget(
              lyrics: _lyrics,
              currentPosition: _currentPosition,
              onSeek: _onLyricSeek,
            ),
          ),
          // 进度条
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildAudioControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.skip_previous),
          onPressed: () {
            // 上一首逻辑
          },
        ),
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: () {
            _audioManager.play('https://example.com/audio.mp3');
          },
        ),
        IconButton(
          icon: Icon(Icons.pause),
          onPressed: () {
            _audioManager.pause();
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
  }

  Widget _buildProgressBar() {
    return StreamBuilder<Duration>(
      stream: _audioManager.durationStream,
      builder: (context, snapshot) {
        final totalDuration = snapshot.data ?? Duration.zero;

        return Slider(
          value: _currentPosition.inMilliseconds.toDouble(),
          min: 0,
          max: totalDuration.inMilliseconds.toDouble(),
          onChanged: (value) {
            final position = Duration(milliseconds: value.toInt());
            _audioManager.seek(position);
          },
        );
      },
    );
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
