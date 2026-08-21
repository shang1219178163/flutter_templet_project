import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';

/// AudioSession 音频理类
class AudioSessionManager {
  static final AudioSessionManager _instance = AudioSessionManager._();
  AudioSessionManager._();
  factory AudioSessionManager() => _instance;

  /// 播放器: 是否外放
  bool isSpeaker = true;

  toSpeaker() async {
    if (Platform.isIOS) {
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth | AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          usage: AndroidAudioUsage.media,
          flags: AndroidAudioFlags.audibilityEnforced,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));
    } else if (Platform.isAndroid) {
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth | AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          usage: AndroidAudioUsage.media,
          flags: AndroidAudioFlags.audibilityEnforced,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));
      // final androidAudioManager = AndroidAudioManager();
      // await androidAudioManager.setMode(AndroidAudioHardwareMode.normal);
      // await androidAudioManager.setSpeakerphoneOn(true);

      // await JustAudioManager().toSpeakerOfAndroid();
    }
    isSpeaker = true;
  }

  toEarpiece() async {
    if (Platform.isIOS) {
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth | AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.voiceChat,
        avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          usage: AndroidAudioUsage.voiceCommunication,
          flags: AndroidAudioFlags.audibilityEnforced,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));
    } else if (Platform.isAndroid) {
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth | AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.voiceChat,
        avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          usage: AndroidAudioUsage.voiceCommunication,
          flags: AndroidAudioFlags.audibilityEnforced,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));
      // final androidAudioManager = AndroidAudioManager();
      // await androidAudioManager.setMode(AndroidAudioHardwareMode.inCommunication);
      // await androidAudioManager.setSpeakerphoneOn(false);

      // await JustAudioManager().toEarpieceOfAndroid();
    }
    isSpeaker = false;
  }

  /// 监听列表(实现音频统一管理)
  final List<AudioSessionSoundPlayerModel> _listeners = [];

  // 添加监听
  void addListener(AudioSessionSoundPlayerModel cb) {
    if (_listeners.contains(cb)) {
      return;
    }
    _listeners.add(cb);
  }

  // 移除监听
  void removeListener(AudioSessionSoundPlayerModel cb) {
    _listeners.remove(cb);
  }

  // 通知所有监听器
  Future<void> notifyListeners(Future<void> Function(AudioSessionSoundPlayerModel e) action) async {
    for (final ltr in _listeners) {
      await action(ltr);
    }
  }

  void clearListeners() {
    _listeners.clear();
  }
}

class AudioSessionSoundPlayerModel {
  AudioSessionSoundPlayerModel({
    this.data,
    this.onPlay,
    this.onStop,
  });

  /// 唯一值
  Map<String, dynamic>? data;

  /// 播放
  Future<void> Function()? onPlay;

  /// 停止播放
  Future<void> Function()? onStop;

  AudioSessionSoundPlayerModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] ?? {};
    onPlay = json['onPlay'];
    onStop = json['onStop'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['data'] = data;
    data['onPlay'] = onPlay.hashCode;
    data['onStop'] = onStop.hashCode;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    final isEqual = other is AudioSessionSoundPlayerModel &&
        runtimeType == other.runtimeType &&
        mapEquals(toJson(), other.toJson());
    return isEqual;
  }

  @override
  int get hashCode => data.hashCode ^ onPlay.hashCode ^ onStop.hashCode;
}
