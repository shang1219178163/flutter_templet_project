//
//  SendGiftButton.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/23 11:33.
//  Copyright © 2026/4/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_target_follower.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/generated/assets.dart';

/// 谁送礼物按钮
class NSendGiftButton extends StatefulWidget {
  const NSendGiftButton({
    super.key,
    this.items = const [188, 66, 10, 5, 1],
    required this.textController,
    required this.onGiftCountCustom,
    required this.onSendChanged,
    this.onDropHide,
  });

  ///礼物数量列表
  final List<int> items;

  final TextEditingController textController;

  /// 礼物数量自定义
  final VoidCallback onGiftCountCustom;

  final VoidCallback? onDropHide;

  /// 确定的礼物数量
  final ValueChanged<int> onSendChanged;

  @override
  State<NSendGiftButton> createState() => _NSendGiftButtonState();
}

class _NSendGiftButtonState extends State<NSendGiftButton> {
  final targetFollowerController = NTargetFollowerController();

  final giftCountVN = ValueNotifier(1);

  late final textController = widget.textController;

  @override
  void dispose() {
    textController.removeListener(onLtr);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    textController.addListener(onLtr);
  }

  onLtr() {
    final count = int.tryParse(textController.text);
    if (count == null) {
      return;
    }
    giftCountVN.value = count;
  }

  @override
  Widget build(BuildContext context) {
    return NTargetFollower(
      controller: targetFollowerController,
      targetAnchor: Alignment.topRight,
      followerAnchor: Alignment.bottomRight,
      target: buildGiftButton(
        countVN: giftCountVN,
        onMore: () {
          // DLog.d("onMore");
          targetFollowerController.toggle();
        },
        onSend: () {
          // DLog.d("onSend");
          widget.onSendChanged(giftCountVN.value);
          targetFollowerController.hide();
        },
      ),
      followerBuilder: (context, onHide) {
        return TapRegion(
          onTapInside: (tap) {
            // debugPrint('On Tap Inside!!');
          },
          onTapOutside: (tap) {
            debugPrint('On Tap Outside!!');
            onHide();
            widget.onDropHide?.call();
          },
          child: buildDropMenu(
            controller: textController,
            onChanged: (int value) {
              // DLog.d("onSend $value");
              // widget.onChanged(value);
              targetFollowerController.toggle();
              giftCountVN.value = value;
            },
          ),
        );
      },
    );
  }

  Widget buildGiftButton({
    required ValueNotifier<int> countVN,
    VoidCallback? onMore,
    VoidCallback? onSend,
  }) {
    return Container(
      // width: 140,
      height: 30,
      padding: const EdgeInsets.only(left: 18),
      decoration: ShapeDecoration(
        shape: StadiumBorder(
          side: BorderSide(width: 1, color: Color(0xFFE91025)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: countVN,
                  builder: (context, value, child) {
                    return GestureDetector(
                      onTap: onMore,
                      child: Container(
                        // constraints: BoxConstraints(
                        //   minWidth: 26,
                        // ),
                        alignment: Alignment.center,
                        // decoration: BoxDecoration(
                        //   color: Colors.green,
                        //   border: Border.all(color: Colors.blue),
                        //   borderRadius: BorderRadius.all(Radius.circular(0)),
                        // ),
                        child: FittedBox(
                          child: Text(
                            '$value',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'PingFang SC',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  onTap: onMore,
                  child: Container(
                    width: 24,
                    height: 24,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(),
                    child: const Image(
                      image: AssetImage(Assets.imagesIconArrowUp),
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onSend,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 6),
              decoration: ShapeDecoration(
                color: Color(0xFFE91025),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              child: const Text(
                '赠送',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropMenu({
    FocusNode? focusNode,
    TextEditingController? controller,
    required ValueChanged<int> onChanged,
  }) {
    final items = widget.items;

    return Container(
      width: 120,
      height: 200 + 12,
      padding: EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
          // border: Border.all(color: Colors.blue),
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // height: 200,
            padding: EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Color(0xFFDEDEDE), width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8),
                buildTextField(
                  focusNode: focusNode,
                  controller: controller,
                  onChanged: onChanged,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: items.map((e) {
                    return GestureDetector(
                      onTap: () {
                        // DLog.d(e);
                        onChanged(e);
                      },
                      child: Container(
                        width: 100,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          // border: Border.all(color: Color(0xFFDEDEDE), width: 0.5),
                          // borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Text(
                          e.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontFamily: 'PingFang SC',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
          Image(
            image: AssetImage(Assets.imagesIconArrowDownFilled),
            width: 12,
            height: 6,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    FocusNode? focusNode,
    TextEditingController? controller,
    required ValueChanged<int> onChanged,
  }) {
    void onInput(String v) {
      final num = int.tryParse(v) ?? 0;
      if (num <= 0) {
        return;
      }
      onChanged(num);
    }

    return TextField(
      readOnly: true,
      onTap: widget.onGiftCountCustom,
      controller: controller,
      textAlign: TextAlign.center,
      maxLines: 1,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      decoration: InputDecoration(
        constraints: BoxConstraints(
          maxHeight: 32,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 2),
        hintText: "自定义",
        filled: true,
        fillColor: Colors.white,
        border: buildBorder(),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
        disabledBorder: buildBorder(),
      ),
      onChanged: (v) => onInput.debounce.call(v),
    );
  }

  InputBorder buildBorder({Color color = const Color(0xffDEDEDE), double radius = 4}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(
        color: color, //边线颜色为白色
        width: 1, //边线宽度为1
      ),
    );
  }
}
