import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_templet_project/basicWidget/voice_animation_image.dart';

///类似微信语音播放动画
class SoundPlayDemo extends StatefulWidget {
  SoundPlayDemo({Key? key}) : super(key: key);

  @override
  _SoundPlayDemoState createState() => _SoundPlayDemoState();
}

class _SoundPlayDemoState extends State<SoundPlayDemo> {
  final List<String> assetList = <String>[
    "icon_left_voice_1.png".toPath(),
    "icon_left_voice_2.png".toPath(),
    "icon_left_voice_3.png".toPath(),
  ].reversed.toList();

  bool isPlaying = false;

  final _voiceGlobalKey = GlobalKey<VoiceAnimationImageState>(debugLabel: "VoiceAnimationImageState");

  final FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;

  final _exampleAudioFilePathMP3 = 'https://flutter-sound.canardoux.xyz/extract/05.mp3';

  @override
  void dispose() {
    stopPlayer();
    // Be careful : you must `close` the audio session when you have finished with it.
    _mPlayer?.closePlayer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _mPlayer!.openPlayer().then((value) {
      _mPlayerIsInited = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("微信语音播放动画"),
      ),
      body: Column(
        children: <Widget>[
          VoiceAnimationImage(
            key: _voiceGlobalKey,
            assetList: assetList,
            width: 50,
            height: 50,
            isPlaying: isPlaying,
          ).toColoredBox(),
          TextButton(
            child: Text(isPlaying ? "停止动画" : "开始动画"),
            onPressed: () {
              // isPlaying = !isPlaying;
              // setState(() {});
              // if (isPlaying) {
              //   _voiceGlobalKey.currentState?.stop();
              // } else {
              //   _voiceGlobalKey.currentState?.start();
              // }
              // _voiceGlobalKey.currentState?.change();
              playbackFn();
            },
          ),
        ],
      ),
    );
  }

  Future<void> play() async {
    _voiceGlobalKey.currentState?.start();

    if (_mPlayer == null) {
      return;
    }
    await _mPlayer!.startPlayer(
        fromURI: _exampleAudioFilePathMP3,
        codec: Codec.mp3,
        whenFinished: () {
          debugPrint("whenFinished");
          // setState(() {});
          _voiceGlobalKey.currentState?.stop();
        });
  }

  Future<void> stopPlayer() async {
    _voiceGlobalKey.currentState?.stop();

    if (_mPlayer == null) {
      return;
    }
    await _mPlayer?.stopPlayer();
  }

  // --------------------- UI -------------------

  Future<void>? playbackFn() {
    if (!_mPlayerIsInited) {
      return null;
    }
    return _mPlayer!.isStopped ? play() : stopPlayer();
  }
}
