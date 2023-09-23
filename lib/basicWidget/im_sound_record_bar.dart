//
//  ImSoundRecordBar.dart
//  yl_patient_app
//
//  Created by shang on 2023/9/23 17:17.
//  Copyright © 2023/9/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/overlay_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/uti/color_util.dart';


/// 音频录制(按住说话)组件
class IMSoundRecordBar extends StatefulWidget {

  IMSoundRecordBar({
    Key? key,
    this.height = 48,
    required this.onRecordStart,
    required this.onRecordEnd,
    // required this.onRecordCancel,
  }) : super(key: key);

  double height;

  VoidCallback onRecordStart;

  ValueChanged<bool> onRecordEnd;

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
      onLongPressStart: (details){
        debugPrint("onLongPressStart");
        showEntry(
          child: buildRecoring(),
        );
        widget.onRecordStart.call();
      },
      onLongPressMoveUpdate:  (e) {
        // debugPrint("${DateTime.now()} bottomSheet onPanUpdate ${e.globalPosition}");

        final temp = e.globalPosition.dy < screeenSize.height - bottomBarHeight;
        if (cancelVN.value == temp) return;
        cancelVN.value = temp;
        setState(() {});
      },
      onLongPressEnd: (details){
        debugPrint("onLongPressEnd");
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
        // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
        ),
        child: Text("按住说话",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: fontColor,
          ),
        ),
      ),
    );
  }


  Widget buildRecoring({double bottomBarHeight = 100}) {
    return ValueListenableBuilder<bool>(
      valueListenable: cancelVN,
      builder: (context, isCancel, child){

        final closeButtonIconName =  (isCancel ? "img_sound_overlay_button_cancel.png" : "img_sound_overlay_button.png");
        final bottombarIconName =  (isCancel ? "img_sound_overlay_bottom_cancel.png" : "img_sound_overlay_bottom.png");

        return Container(
          color: Colors.black.withOpacity(0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                // width: 206.w,
                height: 111.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: "img_sound_overlay_bg_recording.png".toAssetImage(),
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                      isCancel ? Colors.red : primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                child: Image(
                  image: "img_sound_recording.gif".toAssetImage(),
                  width: 112.w,
                  height: 42.w,
                ),
              ),
              SizedBox(height: 190.h,),
              Opacity(
                opacity: isCancel ? 1 : 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  alignment: Alignment.center,
                  child: Text("松开 取消",
                    style: TextStyle(
                      color: fontColor[20],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(

                ),
                child: Image(
                  image: closeButtonIconName.toAssetImage(),
                  width: 64,
                  height: 64,
                ),
              ),
              Opacity(
                opacity: !isCancel ? 1 : 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  alignment: Alignment.center,
                  child: Text("松开 发送",
                    style: TextStyle(
                      color: fontColor[20],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1350),
                child: Container(
                  height: bottomBarHeight,
                  // alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: bottombarIconName.toAssetImage(),
                      fit: BoxFit.fill,
                      // colorFilter: ColorFilter.mode(Colors.yellow, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

}