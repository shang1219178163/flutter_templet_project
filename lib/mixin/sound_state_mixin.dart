import 'dart:async';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:tencent_cloud_chat_sdk/enum/log_level.dart';
import 'package:logger/logger.dart' show Level, Logger;


const theSource = AudioSource.microphone;


mixin SoundStateMixin<T extends StatefulWidget> on State<T> {


  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  // bool _mplaybackReady = false;

  /// True if `FlutterSoundRecorder.isRecording`
  bool get isRecording => _mRecorder!.isRecording;

  /// True if `FlutterSoundPlayer.isStopped`
  bool get isStopped => _mPlayer!.isStopped;

  int recordingStartTimestamp = DateTime.now().millisecondsSinceEpoch;
  /// 语音秒数
  int soundDuration = 0;

  // int get soundDuration {
  //   final result = (recordingEndTimestamp - recordingStartTimestamp)/1000;
  //   return result.toInt();
  // }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;

    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }

  @override
  void initState() {
    _mPlayer?.setLogLevel(Level.warning);
    _mRecorder?.setLogLevel(Level.warning);
    debugPrint("_mPlayer:${_mPlayer.runtimeType.toString()}");
    debugPrint("_mRecorder:${_mRecorder.runtimeType.toString()}");
    _mPlayer!.openPlayer().then((value) {
      _mPlayerIsInited = true;
      // setState(() {});
    });

    openTheRecorder().then((value) {
      _mRecorderIsInited = true;
      // setState(() {});
    });

    soundLocalPath().then((value) {
      _mPath = value;
      debugPrint("_mPath:${_mPath}");
    });
    super.initState();
  }

  Future<String> soundLocalPath() async {
    //用户允许使用麦克风之后开始录音
    Directory tempDir = await getTemporaryDirectory();
    // var time = DateTime.now().toIso8601String();
    var time = DateTime.now().millisecondsSinceEpoch;
    String path = '${tempDir.path}/tmp_sound_$time${ext[_codec.index]}';
    File file = File(path);
    if (!file.existsSync()) {
      file.createSync();
      debugPrint('soundLocalPath 创建成功');
    }
    return path;
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------
  /// 开始录音
  record({String? toFile,}) async {
    recordingStartTimestamp = DateTime.now().millisecondsSinceEpoch;
    return await _mRecorder!.startRecorder(
      toFile: toFile ?? _mPath,
      codec: _codec,
      audioSource: theSource,
    );
  }
  /// 停止录音
  Future<String?> stopRecorder() async {
    soundDuration = (DateTime.now().millisecondsSinceEpoch - recordingStartTimestamp)~/1000;
    debugPrint("soundDuration: $soundDuration");
    return await _mRecorder!.stopRecorder();
  }

  /// 播放音频
  Future<Duration?> play({String? fromURI, VoidCallback? whenFinished}) async {
    // assert(_mPlayerIsInited &&
    //     _mplaybackReady &&
    //     _mRecorder!.isStopped &&
    //     _mPlayer!.isStopped);
    assert(_mPlayerIsInited && _mPlayer!.isStopped);
    return await _mPlayer!.startPlayer(
      fromURI: fromURI ?? _mPath,
      codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
      whenFinished: whenFinished ?? () async {
        final playerState = await _mPlayer!.getPlayerState();
        debugPrint("whenFinished playerState: $playerState");
      },
    );
  }

  /// 停止播放音频
  Future<void> stopPlayer() async {
    if (!_mPlayerIsInited) {
      return;
    }
    return await _mPlayer!.stopPlayer();
  }

// ----------------------------- UI --------------------------------------------

  VoidCallback? getRecorderFn() {
    if (!_mRecorderIsInited) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  VoidCallback? getPlaybackFn() {
    if (!_mPlayerIsInited) {
      return null;
    }
    return _mPlayer!.isPlaying ? play : stopPlayer;
  }

  playback({String? fromURI, required VoidCallback cb}) async {
    if (!_mPlayerIsInited) {
      return null;
    }
    debugPrint("isPlaying:${_mPlayer!.isPlaying}_isPaused:${_mPlayer!.isPaused}_isStopped:${_mPlayer!.isStopped}");
    if (_mPlayer!.isStopped) {
      await play(fromURI:fromURI, whenFinished: cb);
      cb;
    } else {
      await stopPlayer();
      cb;
    }
  }

}

// class SoundModel<T>{
//   SoundModel({
//     required this.url,
//     this.dataSize,
//     this.duration,
//     this.data,
//   });
//
//   String url;
//
//   int? dataSize;
//
//   int? duration;
//
//   T? data;
// }
