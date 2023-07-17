


import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/mixin/keyboard_change_mixin.dart';
import 'package:flutter_templet_project/uti/color_util.dart';

class IMTextfieldBar extends StatefulWidget {

  IMTextfieldBar({
    Key? key,
    required this.onSubmitted,
    this.title,
    this.header = const SizedBox(),
    this.footer = const SizedBox(),
    this.footerMaxHeight = 260,
    this.footerMinHeight = 0,
    this.spacing = 6,
    this.runSpacing = 14,
    this.isVoice = false,
    // required this.isKeyboardVisibleVN,
  }) : super(key: key);

  final String? title;
  final ValueChanged<String>? onSubmitted;

  Widget header;
  Widget footer;
  double footerMinHeight;
  double footerMaxHeight;

  double spacing;
  double runSpacing;
  bool isVoice;

  // ValueNotifier isKeyboardVisibleVN;

  @override
  _IMTextfieldBarState createState() => _IMTextfieldBarState();
}

class _IMTextfieldBarState extends State<IMTextfieldBar> with WidgetsBindingObserver {

  var isExpand = ValueNotifier(false);

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

    final tmp = bottom > 0;
    if (isKeyboardVisibleVN.value == tmp) {
      return;
    }
    isKeyboardVisibleVN.value = tmp;
    if (isKeyboardVisibleVN.value) {
      isExpand.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {

    final textfield = NTextfield(
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      obscureText: false,
      onChanged: (val) async {
      },
      onSubmitted: widget.onSubmitted,
    );

    final box = GestureDetector(
      onLongPressStart: (details){
        debugPrint("onLongPressStart");
      },
      onLongPressEnd: (details){
        debugPrint("onLongPressEnd");
      },
      onLongPressCancel: () {
        debugPrint("onLongPressCancel");
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
        ),
        child: Text("按住说话",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: fontColor
          ),
        ),
      ),
    );

    return Container(
      color: bgColor,
      // padding: EdgeInsets.all(6.w),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.header,
              Padding(
                padding: EdgeInsets.only(
                  top: widget.runSpacing,
                  left: widget.spacing,
                  right: widget.spacing,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: InkWell(
                        onTap: () {
                          isVoice = !isVoice;
                          setState(() {});
                        },
                        child: Image(
                          image: "icon_voice_circle.png".toAssetImage(),
                          width: 30.w,
                          height: 30.w,
                          // color: color,
                        ),
                      ),
                    ),
                    Expanded(
                      child: isVoice ? box : textfield,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: InkWell(
                        onTap: () {
                          isExpand.value = !isExpand.value;
                          if (isExpand.value) {
                            FocusScope.of(context).unfocus();
                          }
                          setState(() {});
                        },
                        child: Image(
                          image: "icon_add_circle.png".toAssetImage(),
                          width: 30.w,
                          height: 30.w,
                          // color: color,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w,),
                  ],
                ),
              ),
              ValueListenableBuilder<bool>(
                 valueListenable: isExpand,
                 builder: (context,  value, child){
                   if (!value) {
                     return const SizedBox();
                   }
                   if (isKeyboardVisibleVN.value) {
                     FocusScope.of(context).unfocus();
                   }
                   return widget.footer;
                }
              ),
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