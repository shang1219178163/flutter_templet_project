//
//  VisitEvaluateAudioPlayPage.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/4/29 16:56.
//  Copyright © 2024/4/29 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/vendor/audioplayers/audio_player_bar.dart';
import 'package:get/get.dart';

/// 随访音频回放
class AudioPlayPage extends StatefulWidget {
  const AudioPlayPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<AudioPlayPage> createState() => _AudioPlayPageState();
}

class _AudioPlayPageState extends State<AudioPlayPage> {
  late Map<String, dynamic> arguments = widget.arguments ?? Get.arguments ?? <String, dynamic>{};

  /// 必传 链接
  late String? url = arguments["url"];

  /// 标题
  late String? title = arguments["title"];

  /// 必传 描述信息
  late String? desc = arguments["desc"];

  /// 必传 时长秒
  late int? timeLong = arguments["timeLong"];

  /// 开始播放
  final _isStarPlay = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColorF9F9F9,
      appBar: AppBar(
        // backgroundColor: bgColorF9F9F9,
        title: Text(title ?? "通话记录"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MediaRecordCard(
            desc: desc ?? "未知",
            timeLong: timeLong,
            onPlay: () {
              _isStarPlay.value = true;
            },
          ),
          AudioPlayerBar(
            url: url ?? '',
            onDuration: (val) {
              DLog.d(val.toTime());
            },
          ),
        ],
      ),
    );
  }
}

class MediaRecordCard extends StatelessWidget {
  const MediaRecordCard({
    super.key,
    required this.timeLong,
    required this.desc,
    this.isVideo = true,
    this.onPlay,
  });

  // final VisitEvaluateDetailModel? detailModel;
  /// 秒
  final int? timeLong;

  final String desc;

  final bool isVideo;

  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    var timestamp = (timeLong ?? 0) * 1000;
    final duration = Duration(milliseconds: timestamp);
    final timeLongDesc = duration.toTimeNew();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NPair(
            isReverse: true,
            flexibleChild: false,
            icon: InkWell(
              onTap: onPlay,
              child: buildMediaBox(
                isVideo: isVideo,
              ),
            ),
            child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NText(
                    desc,
                    fontSize: 16,
                    maxLines: 2,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 16),
                  NPair(
                    icon: Image(
                      image: "icon_time_long.png".toAssetImage(),
                      width: 14,
                      height: 14,
                    ),
                    child: NText(
                      timeLongDesc,
                      color: AppColor.fontColor5D6D7E,
                      maxLines: 1,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMediaBox({required bool isVideo}) {
    final imageName = isVideo ? "icon_video_visit_evaluate.png" : "icon_audio_visit_evaluate.png";
    return Container(
      width: 80,
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xff00B578).withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Image(
        image: imageName.toAssetImage(),
        width: 33,
        height: 32,
      ),
    );
  }
}
