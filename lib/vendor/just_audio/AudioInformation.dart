import 'dart:async';
import 'dart:convert';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:just_audio/just_audio.dart';

///此功能依赖 just_audio: ^0.10.5

class AudioInfoModel {
  final String image;
  final String name;
  final String artist;
  final String url;
  final AudioSource audioSource;

  AudioInfoModel({
    required this.image,
    required this.name,
    required this.artist,
    required this.url,
  }) : audioSource = AudioSource.uri(Uri.parse(url));

  AudioInfoModel.fromJson(Map<String, dynamic> json)
      : image = json['image'] ?? 'assets/images/default.jpg',
        name = json['name'] ?? '',
        artist = json['artist'] ?? '',
        url = json['url'] ?? '',
        audioSource = AudioSource.uri(Uri.parse(json['url']));

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

class AudioPlayerUtil {
  AudioPlayerUtil._() {
    _positionTimer = Timer.periodic(const Duration(milliseconds: 40), (t) {
      if (_player.playing) {
        _positionController.add(_player.position);
      }
    });
  }

  static final AudioPlayerUtil _instance = AudioPlayerUtil._();

  static AudioPlayerUtil of() {
    return _instance;
  }

  /// 音频列表存储 key
  static final String audioStrorageKey = 'AUDIO_UTIL:AUDIO_LIST';

  /// 播放索引存储 key
  static final String audioIndexKey = 'AUDIO_UTIL:AUDIO_INDEX';

  final List<StreamSubscription> _streamSubscriptions = [];

  /// 初始化
  Future<void> init() async {
    var audioListJson = CacheService().getString(audioStrorageKey) ?? "";
    if (audioListJson.isNotEmpty) {
      List<dynamic> jsonList = jsonDecode(audioListJson);
      await setAudioSource(jsonList);
    }
    var index = CacheService().getInt(audioIndexKey) ?? 0;
    await seek(Duration.zero, index: index);
    // 监听播放索引变化
    _streamSubscriptions.add(
      currentIndexStream.listen((index) {
        CacheService().setInt(audioIndexKey, index ?? 0);
      }),
    );
    return Future.value(null);
  }

// 播放器
  final _player = AudioPlayer();

// 位置更新定时器
  late final Timer _positionTimer;

// 位置更新通知流控制器
  final _positionController = StreamController<Duration>.broadcast();

// 定时关闭倒计时
  int _countdown = -1;

// 定时关闭倒计时定时器
  Timer? _countdownTimer;

// 定时关闭倒计时通知流控制器
  final _countdownController = StreamController<int>.broadcast();

// 播放列表
  final List<AudioInfoModel> _audioInformationList = [];

  /// 设置播放源
  Future<Duration?> setAudioSource(
    List<dynamic> jsonList, {
    int initialIndex = 0,
  }) async {
    if (jsonList.isEmpty) {
      return Future.value(null);
    }
    // 转换为 AudioInformation 列表
    var audioList = jsonList.map((json) => AudioInfoModel.fromJson(json)).toList();
    _audioInformationList.clear();
    // 停止播放
    pause();
    stop();
    _player.clearAudioSources();
    _audioInformationList.addAll(audioList);
    // 本地存储
    CacheService().setString(
      audioStrorageKey,
      jsonEncode(_audioInformationList.map((it) => it.toJson()).toList()),
    );
    return _player.setAudioSources(
      audioList.map((it) => it.audioSource).toList(),
      shuffleOrder: DefaultShuffleOrder(), // Customise the shuffle algorithm
    );
    return null;
  }

  /// 添加播放源
  Future<void> addAudioSource(List<dynamic> jsonList) async {
    if (jsonList.isEmpty) {
      return Future.value(null);
    }
    // 添加音频
    var audioList = jsonList.map((json) => AudioInfoModel.fromJson(json)).toList();
    _audioInformationList.addAll(audioList);
    // 本地存储
    CacheService().setString(
      audioStrorageKey,
      jsonEncode(_audioInformationList.map((it) => it.toJson()).toList()),
    );
    return _player.addAudioSources(
      audioList.map((it) => it.audioSource).toList(),
    );
  }

  /// 添加到下一个播放
  void addNext(AudioInfoModel audio) {
    var nextIndex = (_player.currentIndex ?? -1) + 1;
    _audioInformationList.insert(nextIndex, audio);
    _player.insertAudioSource(
      nextIndex,
      _audioInformationList[nextIndex].audioSource,
    );
    // 本地存储
    CacheService().setString(
      audioStrorageKey,
      jsonEncode(_audioInformationList.map((it) => it.toJson()).toList()),
    );
  }

  /// 移除指定索引的播放信息
  void removeAt(int index) {
    if (index < 0 || index >= _audioInformationList.length || index == _player.currentIndex) {
      return;
    }
    _audioInformationList.removeAt(index);
    _player.removeAudioSourceAt(index);
  }

  /// 播放下一首
  Future<void> next() async {
    if (_audioInformationList.isEmpty) {
      return Future.value();
    }
    if (_player.hasNext) {
      return _player.seekToNext();
    } else {
      return _player.seek(Duration.zero, index: 0);
    }
  }

  /// 播放上一首
  Future<void> previous() async {
    if (_audioInformationList.isEmpty) {
      return Future.value();
    }
    if (_player.hasPrevious) {
      return _player.seekToPrevious();
    } else {
      return _player.seek(
        Duration.zero,
        index: _audioInformationList.length - 1,
      );
    }
  }

  /// 指定播放音频位置和播放源
  Future<void> seek(Duration position, {int? index}) async {
    return _player.seek(position, index: index);
  }

  /// 播放 or 播放指定音频
  Future<void> play({int? index}) async {
    if (null == index) {
      return _player.play();
    }
    if (index < 0 || index >= _audioInformationList.length) {
      return;
    }
    await seek(Duration.zero, index: index);
    return _player.play();
  }

  /// 暂停
  Future<void> pause() async {
    return _player.pause();
  }

  /// 停止
  Future<void> stop() async {
    return _player.stop();
  }

  /// 设置循环模式
  Future<void> setLoopMode(LoopMode loopMode) async {
    return _player.setLoopMode(loopMode);
  }

  /// 设置随机播放
  Future<void> setShuffleModeEnabled(bool randomModeEnabled) async {
    return _player.setShuffleModeEnabled(randomModeEnabled);
  }

  /// 获取随机播放
  bool get shuffleModeEnabled => _player.shuffleModeEnabled;

  /// 获取循环模式
  LoopMode get loopMode => _player.loopMode;

  /// 获取播放列表
  List<AudioInfoModel> get audioInformationList => _audioInformationList;

  /// 获取当前播放进度
  Duration get position => _player.position;

  /// 获取当前播放时长
  Duration? get duration => _player.duration;

  /// 获取当前播放状态
  bool get playing => _player.playing;

  /// 获取当前播放音频索引
  int? get currentIndex => _player.currentIndex;

  /// 获取当前播放音频
  AudioInfoModel? get currentAudio {
    if (null == _player.currentIndex) {
      returnnull;
    }
    return _audioInformationList[_player.currentIndex!];
  }

  /// 获取播放器状态流
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// 获取当前索引流
  Stream<int?> get currentIndexStream => _player.currentIndexStream;

  /// 获取播放进度流
  Stream<Duration> get positionStream {
    // return _player.positionStream;
    return _positionController.stream;
  }

  /// 获取播放时长流
  Stream<Duration?> get durationStream => _player.durationStream;

  /// 设置定时关闭
  void setCountdown(int countdownSeconds) {
    _countdown = countdownSeconds;
    _countdownTimer?.cancel();
    _countdownController.add(_countdown);
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _countdown = _countdown - 1;
      _countdownController.add(_countdown);
      if (_countdown < 0) {
        // 暂停播放
        pause();
        stop();
        timer.cancel();
      }
    });
  }

  /// 取消定时关闭
  void cancelCountdown() {
    _countdown = -1;
    _countdownController.add(_countdown);
    _countdownTimer?.cancel();
  }

  /// 倒计时流
  Stream<int> get countdownStream => _countdownController.stream;

  /// 释放播放器资源
  Future<void> dispose() async {
    while (_streamSubscriptions.isNotEmpty) {
      _streamSubscriptions.removeLast().cancel();
    }
    // 停止位置更新
    _positionTimer.cancel();
    _positionController.close();
    // 停止倒计时
    _countdownTimer?.cancel();
    _countdownController.close();
    // 先停止并清除所有音频源
    await _player.pause();
    await _player.stop();
    await _player.clearAudioSources();
    // 释放播放器资源
    await _player.dispose();
    // 清理播放列表
    _audioInformationList.clear();
  }
}
