import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/im_sound_record_bar.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/overlay_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/mixin/sound_state_mixin.dart';
import 'package:flutter_templet_project/util/app_color.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';

class GestureDetectorDemo extends StatefulWidget {
  GestureDetectorDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _GestureDetectorDemoState createState() => _GestureDetectorDemoState();
}

class _GestureDetectorDemoState extends State<GestureDetectorDemo> with SoundStateMixin {
  final cancelVN = ValueNotifier(false);

  late final screeenSize = MediaQuery.of(context).size;

  double bottomBarHeight = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    cancelVN.value = !cancelVN.value;
                    setState(() {});
                  },
                ))
            .toList(),
      ),
      body: Container(
        color: Colors.greenAccent,
      ),
      bottomSheet: buildBottomSheet(),
    );
  }

  buildBottomSheet() {
    return GestureDetector(
      onPanStart: (e) {
        debugPrint("onPanStart");
        showEntry(
          child: buildRecoring(),
        );
      },
      onPanUpdate: (e) {
        debugPrint("${DateTime.now()} bottomSheet onPanUpdate ${e.globalPosition}");

        final temp = e.globalPosition.dy < screeenSize.height - bottomBarHeight;
        if (cancelVN.value == temp) return;
        cancelVN.value = temp;
        setState(() {});
      },

      onPanEnd: (e) {
        debugPrint("onPanEnd");
        hideEntry();
      },
      // onLongPressCancel: () {
      //   debugPrint("onLongPressCancel");
      //   hideEntry();
      // },
      child: Container(
        height: 78,
        alignment: Alignment.center,
        // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
        ),
        child: Text(
          "按住说话",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColor.fontColor),
        ),
      ),
    );

    return GestureDetector(
      onLongPressStart: (details) {
        debugPrint("onLongPressStart");
        showEntry(
          child: buildRecoring(),
        );
      },
      onLongPressMoveUpdate: (e) {
        debugPrint("${DateTime.now()} bottomSheet onPanUpdate ${e.globalPosition}");

        final temp = e.globalPosition.dy < screeenSize.height - bottomBarHeight;
        if (cancelVN.value == temp) return;
        cancelVN.value = temp;
        setState(() {});
      },

      onLongPressEnd: (details) {
        debugPrint("onLongPressEnd");
        hideEntry();
      },
      // onLongPressCancel: () {
      //   debugPrint("onLongPressCancel");
      //   hideEntry();
      // },
      child: Container(
        height: 78,
        alignment: Alignment.center,
        // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
        ),
        child: Text(
          "按住说话",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColor.fontColor),
        ),
      ),
    );
  }

  buildSoundRecordBar() {
    return IMSoundRecordBar(
      onRecordStart: () async {
        // debugPrint("${DateTime.now()} onRecordStart");
        await soundStartRecord();
      },
      onRecordEnd: (bool isCancel) async {
        // debugPrint("${DateTime.now()} onRecordEnd");
        final fileURL = await stopSoundRecorder();
        debugPrint("${DateTime.now()} onRecordEnd fileURL: $fileURL");
        // play(fromURI: fileURL);//add test
        if (isCancel) {
          return;
        }
        if (soundDuration <= 1) {
          ToastUtil.show("说话时间太短");
          return;
        }
      },
    );
  }

  Widget buildRecoring() {
    return ValueListenableBuilder<bool>(
        valueListenable: cancelVN,
        builder: (context, isCancel, child) {
          final closeButtonIconName =
              (isCancel ? "img_sound_overlay_button_cancel.png" : "img_sound_overlay_button.png");
          final bottombarIconName = (isCancel ? "img_sound_overlay_bottom_cancel.png" : "img_sound_overlay_bottom.png");

          return Material(
            type: MaterialType.transparency,
            child: Container(
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
                          isCancel ? Colors.red : context.primaryColor,
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
                  SizedBox(
                    height: 190.h,
                  ),
                  Opacity(
                    opacity: isCancel ? 1 : 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      alignment: Alignment.center,
                      child: Text(
                        "松开 取消",
                        style: TextStyle(
                          color: AppColor.fontColorB3B3B3,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(),
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
                      child: Text(
                        "松开 发送",
                        style: TextStyle(
                          color: AppColor.fontColorB3B3B3,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
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
                ],
              ),
            ),
          );
        });
  }
}
