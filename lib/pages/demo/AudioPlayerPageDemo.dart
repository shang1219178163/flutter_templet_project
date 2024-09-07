import 'package:flutter/material.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:flutter_templet_project/vendor/video_player/video_player_controller.dart';
import 'package:get/get.dart';

class AudioPlayPageDemo extends StatefulWidget {
  const AudioPlayPageDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<AudioPlayPageDemo> createState() => _AudioPlayPageDemoState();
}

class _AudioPlayPageDemoState extends State<AudioPlayPageDemo> {
  bool get hideApp =>
      Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => debugPrint(e),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                final url = "https://ylgcp-1259562304.cos.ap-beijing"
                    ".myqcloud.com/beta/message/trtc/D0zNeI1Rsl+5JZsZ3IHEod32B4WQQrcfbphUzLFudOxa++Iw-pX4FdRVa0h6VOyilruxBp+j9beno1-GVHUA/1400349613_1365667410.m3u8";
                final desc = (url ?? "").split("/").last;
                MediaPlayerController().toAudioPlayer(
                  url: url,
                  desc: desc,
                  timeLong: 50,
                );
              },
              child: Text("播放"),
            ),
          ],
        ),
      ),
    );
  }
}
