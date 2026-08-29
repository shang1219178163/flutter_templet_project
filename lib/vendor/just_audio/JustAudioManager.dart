import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:just_audio/just_audio.dart';

/// 此功能依赖 just_audio: ^0.10.5
class AudioDetailModel {

  AudioDetailModel({
    required this.image,
    required this.name,
    required this.artist,
    required this.url,
  }) : audioSource = AudioSource.uri(Uri.parse(url));

  factory AudioDetailModel.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String? ?? '';
    return AudioDetailModel(
      image: json['image'] as String? ?? 'assets/images/default.jpg',
      name: json['name'] as String? ?? '',
      artist: json['artist'] as String? ?? '',
      url: url,
    );
  }
  final String image;
  final String name;
  final String artist;
  final String url;
  final AudioSource audioSource;

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'artist': artist,
      'url': url,
    };
  }

  @override
  String toString() {
    return "$runtimeType ${toJson()}";
  }
}

class JustAudioManager {

  factory JustAudioManager() => _instance;
  JustAudioManager._();

  static final JustAudioManager _instance = JustAudioManager._();

  static JustAudioManager get instance => _instance;

  /// 音频列表存储 key
  static const String audioStorageKey = 'AUDIO_UTIL:AUDIO_LIST';

  /// 播放索引存储 key
  static const String audioIndexKey = 'AUDIO_UTIL:AUDIO_INDEX';

  final AudioPlayer _player = AudioPlayer();
  final List<StreamSubscription> _streamSubscriptions = [];
  final List<AudioDetailModel> _audioModels = [];
  final _countdownController = StreamController<int>.broadcast();

  int _countdown = -1;
  Timer? _countdownTimer;
  bool _initialized = false;

  /// 初始化（幂等）
  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    await CacheService().init();

    try {
      final audioListJson = CacheService().getString(audioStorageKey) ?? '';
      if (audioListJson.isNotEmpty) {
        final jsonList = jsonDecode(audioListJson) as List<dynamic>;
        await setAudioSource(jsonList);
      }
    } catch (e, s) {
      debugPrint('AudioPlayerUtil.init playlist restore failed: $e\n$s');
    }

    final maxIndex = _audioModels.length - 1;
    if (maxIndex >= 0) {
      final index = (CacheService().getInt(audioIndexKey) ?? 0).clamp(0, maxIndex);
      await seek(Duration.zero, index: index);
    }

    _streamSubscriptions.add(
      currentIndexStream.listen((index) {
        CacheService().setInt(audioIndexKey, index ?? 0);
      }),
    );
  }

  List<AudioDetailModel> _parseAudioList(List<dynamic> jsonList) {
    return jsonList
        .whereType<Map>()
        .map((json) => AudioDetailModel.fromJson(Map<String, dynamic>.from(json)))
        .where((e) => e.url.isNotEmpty)
        .toList();
  }

  Future<void> _persistPlaylist() async {
    await CacheService().setString(
      audioStorageKey,
      jsonEncode(_audioModels.map((it) => it.toJson()).toList()),
    );
  }

  /// 设置播放源
  Future<Duration?> setAudioSource(
    List<dynamic> jsonList, {
    int initialIndex = 0,
  }) async {
    if (jsonList.isEmpty) {
      return null;
    }

    final audioList = _parseAudioList(jsonList);
    if (audioList.isEmpty) {
      return null;
    }

    await pause();
    await stop();
    await _player.clearAudioSources();

    _audioModels
      ..clear()
      ..addAll(audioList);
    await _persistPlaylist();

    final safeIndex = initialIndex.clamp(0, audioList.length - 1);
    try {
      return await _player.setAudioSources(
        audioList.map((it) => it.audioSource).toList(),
        initialIndex: safeIndex,
        shuffleOrder: DefaultShuffleOrder(),
      );
    } catch (e, s) {
      debugPrint('AudioPlayerUtil.setAudioSource failed: $e\n$s');
      return null;
    }
  }

  /// 添加播放源
  Future<void> addAudioSource(List<dynamic> jsonList) async {
    if (jsonList.isEmpty) {
      return;
    }

    final audioList = _parseAudioList(jsonList);
    if (audioList.isEmpty) {
      return;
    }

    _audioModels.addAll(audioList);
    await _persistPlaylist();
    await _player.addAudioSources(
      audioList.map((it) => it.audioSource).toList(),
    );
  }

  /// 添加到下一个播放
  Future<void> addNext(AudioDetailModel audio) async {
    if (audio.url.isEmpty) {
      return;
    }

    final nextIndex = (_player.currentIndex ?? -1) + 1;
    _audioModels.insert(nextIndex, audio);
    await _player.insertAudioSource(nextIndex, audio.audioSource);
    await _persistPlaylist();
  }

  /// 移除指定索引的播放信息
  Future<void> removeAt(int index) async {
    if (index < 0 || index >= _audioModels.length || index == _player.currentIndex) {
      return;
    }

    _audioModels.removeAt(index);
    await _player.removeAudioSourceAt(index);
    await _persistPlaylist();
  }

  /// 播放下一首
  Future<void> next() async {
    if (_audioModels.isEmpty) {
      return;
    }
    if (_player.hasNext) {
      await _player.seekToNext();
    } else {
      await _player.seek(Duration.zero, index: 0);
    }
  }

  /// 播放上一首
  Future<void> previous() async {
    if (_audioModels.isEmpty) {
      return;
    }
    if (_player.hasPrevious) {
      await _player.seekToPrevious();
    } else {
      await _player.seek(
        Duration.zero,
        index: _audioModels.length - 1,
      );
    }
  }

  /// 指定播放音频位置和播放源
  Future<void> seek(Duration position, {int? index}) async {
    if (index != null) {
      if (_audioModels.isEmpty) {
        return;
      }
      index = index.clamp(0, _audioModels.length - 1);
    }
    await _player.seek(position, index: index);
  }

  /// 播放 or 播放指定音频
  Future<void> play({int? index}) async {
    if (index == null) {
      await _player.play();
      return;
    }
    if (index < 0 || index >= _audioModels.length) {
      return;
    }
    await seek(Duration.zero, index: index);
    await _player.play();
  }

  /// 暂停
  Future<void> pause() async {
    await _player.pause();
  }

  /// 停止
  Future<void> stop() async {
    await _player.stop();
  }

  /// 设置循环模式
  Future<void> setLoopMode(LoopMode loopMode) async {
    await _player.setLoopMode(loopMode);
  }

  /// 设置随机播放
  Future<void> setShuffleModeEnabled(bool randomModeEnabled) async {
    await _player.setShuffleModeEnabled(randomModeEnabled);
  }

  bool get shuffleModeEnabled => _player.shuffleModeEnabled;

  LoopMode get loopMode => _player.loopMode;

  List<AudioDetailModel> get audioInformationList => List.unmodifiable(_audioModels);

  Duration get position => _player.position;

  Duration? get duration => _player.duration;

  bool get playing => _player.playing;

  int? get currentIndex => _player.currentIndex;

  AudioDetailModel? get currentAudio {
    final index = _player.currentIndex;
    if (index == null || index < 0 || index >= _audioModels.length) {
      return null;
    }
    return _audioModels[index];
  }

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Stream<int?> get currentIndexStream => _player.currentIndexStream;

  Stream<Duration> get positionStream => _player.positionStream;

  Stream<Duration?> get durationStream => _player.durationStream;

  /// 设置定时关闭
  void setCountdown(int countdownSeconds) {
    _countdown = countdownSeconds;
    _countdownTimer?.cancel();
    _countdownController.add(_countdown);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _countdown -= 1;
      _countdownController.add(_countdown);
      if (_countdown < 0) {
        timer.cancel();
        unawaited(_stopPlayback());
      }
    });
  }

  Future<void> _stopPlayback() async {
    await pause();
    await stop();
  }

  /// 取消定时关闭
  void cancelCountdown() {
    _countdown = -1;
    _countdownController.add(_countdown);
    _countdownTimer?.cancel();
  }

  Stream<int> get countdownStream => _countdownController.stream;

  /// 释放播放器资源（一次性；调用后不可再使用本单例）
  Future<void> dispose() async {
    while (_streamSubscriptions.isNotEmpty) {
      await _streamSubscriptions.removeLast().cancel();
    }
    _countdownTimer?.cancel();
    await _countdownController.close();
    await _player.pause();
    await _player.stop();
    await _player.clearAudioSources();
    await _player.dispose();
    _audioModels.clear();
    _initialized = false;
  }
}
