import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/im_sound_record_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';

import 'package:flutter_templet_project/util/color_util.dart';

enum IMTextfieldBarEvent {
  sound,
  emoji,
  add,
}

typedef EventWidgetBuilder = Widget Function(BuildContext context, IMTextfieldBarEvent event);

class IMTextfieldBar extends StatefulWidget {
  IMTextfieldBar({
    Key? key,
    this.controller,
    required this.onChanged,
    required this.onSubmitted,
    this.hintText = "请输入",
    this.keyboardType,
    // this.title,
    this.header = const SizedBox(),
    // this.footer = const SizedBox(),
    this.footerBuilder,
    this.footerMaxHeight = 260,
    this.footerMinHeight = 0,
    this.spacing = 8,
    this.runSpacing = 8,
    this.isVoice = false,
    // required this.isKeyboardVisibleVN,
  }) : super(key: key);

  // final String? title;
  /// 控制器
  final TextEditingController? controller;

  /// 改变回调
  final ValueChanged<String> onChanged;

  /// 一般是键盘回车键/确定回调
  final ValueChanged<String>? onSubmitted;

  /// 提示语
  final String? hintText;

  /// 键盘类型
  final TextInputType? keyboardType;

  final Widget header;
  // Widget footer;

  final EventWidgetBuilder? footerBuilder;
  final double footerMinHeight;
  final double footerMaxHeight;

  final double spacing;
  final double runSpacing;
  final bool isVoice;

  // ValueNotifier isKeyboardVisibleVN;

  @override
  _IMTextfieldBarState createState() => _IMTextfieldBarState();
}

class _IMTextfieldBarState extends State<IMTextfieldBar> with WidgetsBindingObserver {
  var isExpand = ValueNotifier(false);
  var isExpandEmoji = ValueNotifier(false);

  late var isVoice = widget.isVoice;

  final isKeyboardVisibleVN = ValueNotifier(false);

  double get bottom {
    return MediaQuery.of(context).padding.bottom;
  }

  @override
  void dispose() {
    /// 销毁
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    /// 初始化
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!mounted) {
      return;
    }

    // final tmp = bottom > 0;
    // if (isKeyboardVisibleVN.value == tmp) {
    //   return;
    // }
    // isKeyboardVisibleVN.value = tmp;
    // if (isKeyboardVisibleVN.value) {
    //   isExpand.value = false;
    //   isExpandEmoji.value = false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    buildBorder() {
      OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.w)), //边角
        borderSide: const BorderSide(
          color: Colors.transparent, //边框颜色为白色
          width: 1, //宽度为1
        ),
      );
    }

    final textfield = NTextField(
      isCollapsed: true,
      controller: widget.controller,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.done,
      obscureText: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      fillColor: Colors.white,
      border: buildBorder(),
      enabledBorder: buildBorder(),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );

    final soundRecordBar = IMSoundRecordBar(
      height: 36,
      onRecordStart: () async {
        // debugPrint("${DateTime.now()} onRecordStart");
        // await soundStartRecord();
      },
      onRecordEnd: (bool isCancel) async {
        // debugPrint("${DateTime.now()} onRecordEnd");
        // final fileURL = await stopSoundRecorder();
        // debugPrint("${DateTime.now()} onRecordEnd fileURL: $fileURL");
        // // play(fromURI: fileURL);//add test
        // if (isCancel) {
        //   return;
        // }
        // if (soundDuration <= 1) {
        //   EasyToast.showToast("说话时间太短");
        //   return;
        // }
      },
    );

    return Container(
      color: bgColor,
      // padding: EdgeInsets.all(8),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.header,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.spacing,
                  vertical: widget.runSpacing,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: widget.spacing),
                      child: InkWell(
                        onTap: () {
                          isVoice = !isVoice;
                          setState(() {});
                        },
                        child: Image(
                          image: "icon_voice_circle.png".toAssetImage(),
                          width: 30,
                          height: 30,
                          // color: color,
                        ),
                      ),
                    ),
                    Expanded(
                      child: isVoice ? soundRecordBar : textfield,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: widget.spacing),
                      child: InkWell(
                        onTap: () {
                          isExpandEmoji.value = !isExpandEmoji.value;
                          if (isExpandEmoji.value) {
                            FocusScope.of(context).unfocus();
                          }

                          if (isExpand.value) {
                            isExpand.value = !isExpand.value;
                          }
                          // setState(() {});
                        },
                        child: Image(
                          image: "icon_emoji_circle.png".toAssetImage(),
                          width: 30.w,
                          height: 30.w,
                          // color: color,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: widget.spacing),
                      child: InkWell(
                        onTap: () {
                          isExpand.value = !isExpand.value;
                          if (isExpand.value) {
                            FocusScope.of(context).unfocus();
                          }

                          if (isExpandEmoji.value) {
                            isExpandEmoji.value = false;
                          }
                          // setState(() {});
                        },
                        child: Image(
                          image: "icon_add_circle.png".toAssetImage(),
                          width: 30.w,
                          height: 30.w,
                          // color: color,
                        ),
                      ),
                    ),
                    // SizedBox(width: 6.w,),
                  ],
                ),
              ),
              if (widget.footerBuilder != null)
                ValueListenableBuilder<bool>(
                    valueListenable: isExpandEmoji,
                    builder: (context, value, child) {
                      if (!value) {
                        return const SizedBox();
                      }
                      if (isKeyboardVisibleVN.value) {
                        FocusScope.of(context).unfocus();
                      }
                      return widget.footerBuilder?.call(context, IMTextfieldBarEvent.emoji) ?? SizedBox();
                    }),
              if (widget.footerBuilder != null)
                ValueListenableBuilder<bool>(
                    valueListenable: isExpand,
                    builder: (context, value, child) {
                      if (!value) {
                        return const SizedBox();
                      }
                      if (isKeyboardVisibleVN.value) {
                        FocusScope.of(context).unfocus();
                      }
                      return widget.footerBuilder?.call(context, IMTextfieldBarEvent.add) ?? SizedBox();
                    }),
              SizedBox(
                height: max(widget.runSpacing, MediaQuery.of(context).padding.bottom),
              ),
            ],
          );
        },
      ),
    );
  }
}
