//
//  ImSoundRecordingPage.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/24 19:25.
//  Copyright © 2023/10/24 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_transition_builder.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

/// 发语音: 声音录制页面
class IMSoundRecordingPage extends StatelessWidget {
  const IMSoundRecordingPage({
    Key? key,
    this.bottomBarHeight = 100,
    this.duration = const Duration(milliseconds: 350),
    required this.cancelVN,
  }) : super(key: key);

  final double bottomBarHeight;

  /// 动画时间
  final Duration duration;

  final ValueNotifier<bool> cancelVN;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return ValueListenableBuilder<bool>(
      valueListenable: cancelVN,
      builder: (context, isCancel, child) {
        final closeButtonIconName = (isCancel ? "img_sound_overlay_button_cancel.png" : "img_sound_overlay_button.png");
        final bottomBarIconName = (isCancel ? "img_sound_overlay_bottom_cancel.png" : "img_sound_overlay_bottom.png");

        return Container(
          color: Colors.black.withOpacity(0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                // width: 206.w,
                height: 111,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // border: Border.all(width: 1),
                  image: DecorationImage(
                    image: "img_sound_overlay_bg_recording.png".toAssetImage(),
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                      isCancel ? Colors.red : primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                child: Image(
                  image: "img_sound_recording.gif".toAssetImage(),
                  width: 150,
                  height: 70,
                ),
              ),
              const SizedBox(
                height: 190,
              ),
              Opacity(
                opacity: isCancel ? 1 : 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  child: Text(
                    "松开 取消",
                    style: TextStyle(
                      color: AppColor.fontColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(),
                child: Image(
                  image: closeButtonIconName.toAssetImage(),
                  width: 64,
                  height: 64,
                ),
              ),
              Opacity(
                opacity: !isCancel ? 1 : 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  child: Text(
                    "松开 发送",
                    style: TextStyle(
                      color: AppColor.fontColorB3B3B3,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              NTransitionBuilder(
                duration: duration,
                builder: (context, controller, Animation<double> animation) {
                  return SizeTransition(
                    axisAlignment: 0.0,
                    sizeFactor: animation,
                    axis: Axis.vertical,
                    child: Container(
                      height: bottomBarHeight,
                      // alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: bottomBarIconName.toAssetImage(),
                          fit: BoxFit.fill,
                          // colorFilter: ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
