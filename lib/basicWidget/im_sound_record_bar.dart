//
//  ImSoundRecordBar.dart
//  yl_patient_app
//
//  Created by shang on 2023/9/23 17:17.
//  Copyright © 2023/9/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/im_sound_recording_page.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/overlay_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:flutter_templet_project/vendor/vibration_service.dart';

/// 音频录制(按住说话)组件
class IMSoundRecordBar extends StatefulWidget {
  const IMSoundRecordBar({
    Key? key,
    this.height = 48,
    required this.onRecordStart,
    required this.onRecordEnd,
    // required this.onRecordCancel,
  }) : super(key: key);

  final double height;

  final VoidCallback onRecordStart;

  final ValueChanged<bool> onRecordEnd;

  // VoidCallback onRecordCancel;

  @override
  _IMSoundRecordBarState createState() => _IMSoundRecordBarState();
}

class _IMSoundRecordBarState extends State<IMSoundRecordBar> {
  late final screeenSize = MediaQuery.of(context).size;

  final cancelVN = ValueNotifier(false);

  final bottomBarHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (e) {
        debugPrint("onPanStart");
        // Vibration.vibrate(amplitude: 128, duration: 100);
        VibrationService.vibrate(
          duration: 100,
          amplitude: 128,
        );

        cancelVN.value = false;
        showEntry(
          child: IMSoundRecordingPage(
            cancelVN: cancelVN,
            duration: const Duration(milliseconds: 100),
          ),
        );
        widget.onRecordStart.call();
      },
      onPanUpdate: (e) {
        // debugPrint("${DateTime.now()} bottomSheet onPanUpdate ${e.globalPosition}");

        final temp = e.globalPosition.dy < screenSize.height - bottomBarHeight;
        if (cancelVN.value == temp) return;
        cancelVN.value = temp;
        setState(() {});
      },
      onPanEnd: (details) {
        debugPrint("onPanEnd");
        hideEntry();
        widget.onRecordEnd.call(cancelVN.value);
      },
      // onLongPressCancel: () {
      //   debugPrint("onLongPressCancel");
      //   hideEntry();
      // },
      child: Container(
        height: widget.height,
        alignment: Alignment.center,
        // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: const Text(
          "按住 说话",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: fontColor,
          ),
        ),
      ),
    );

    // return GestureDetector(
    //   onLongPressStart: (details){
    //     debugPrint("onLongPressStart");
    //
    //     cancelVN.value = false;
    //     showEntry(
    //       child: IMSoundRecordingPage(
    //         cancelVN: cancelVN,
    //         duration: const Duration(milliseconds: 100),
    //       ),
    //     );
    //     widget.onRecordStart.call();
    //   },
    //   onLongPressMoveUpdate:  (e) {
    //     // debugPrint("${DateTime.now()} bottomSheet onPanUpdate ${e.globalPosition}");
    //
    //     final temp = e.globalPosition.dy < screeenSize.height - bottomBarHeight;
    //     if (cancelVN.value == temp) {
    //       return;
    //     }
    //     cancelVN.value = temp;
    //     setState(() {});
    //   },
    //   onLongPressEnd: (details){
    //     debugPrint("onLongPressEnd");
    //     hideEntry();
    //     widget.onRecordEnd.call(cancelVN.value);
    //   },
    //   // onLongPressCancel: () {
    //   //   debugPrint("onLongPressCancel");
    //   //   hideEntry();
    //   // },
    //   child: Container(
    //     height: widget.height,
    //     alignment: Alignment.center,
    //     // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.all(Radius.circular(4.w)),
    //     ),
    //     child: Text("按住说话",
    //       textAlign: TextAlign.center,
    //       style: TextStyle(
    //         fontSize: 18.sp,
    //         fontWeight: FontWeight.bold,
    //         color: fontColor,
    //       ),
    //     ),
    //   ),
    // );
  }
}
