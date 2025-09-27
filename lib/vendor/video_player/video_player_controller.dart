//
//  VideoPlayerController.dart
//  flutter_templet_project
//
//  Created by shang on 2024/5/23 18:16.
//  Copyright © 2024/5/23 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';

class MediaPlayerController {
  /// 跳转随访视频回放
  void toVideoPlayer({
    required String videoUrl,
    String videoThumbUrl = "",
    hideDownload = true,
    ValueChanged? onBack,
  }) {
    if (!videoUrl.startsWith("http")) {
      ToastUtil.show("播放链接异常");
      return;
    }
    final videoTitle = (videoUrl).split("/").last;
    Get.toNamed(APPRouter.chewiePlayerPage, arguments: {
      "videoUrl": videoUrl,
      "videoTitle": videoTitle,
      "videoThumbUrl": videoThumbUrl,
      "hideDownload": hideDownload,
    })?.then((value) {
      onBack?.call(value);
    });
  }

  /// 跳转随访音频回放
  void toAudioPlayer({
    required String url,
    required String desc,
    required int? timeLong,
    String? title,
    ValueChanged? onBack,
  }) {
    if (!url.startsWith("http")) {
      ToastUtil.show("播放链接异常");
      return;
    }
    Get.toNamed(APPRouter.audioPlayPage, arguments: {
      "url": url,
      "desc": desc,
      "timeLong": timeLong ?? 0,
      "title": title,
    })?.then((value) {
      onBack?.call(value);
    });
  }
}
