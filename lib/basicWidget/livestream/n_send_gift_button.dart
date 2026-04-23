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
    required this.onChanged,
  });

  ///礼物数量列表
  final List<int> items;

  /// 确定的礼物数量
  final ValueChanged<int> onChanged;

  @override
  State<NSendGiftButton> createState() => _NSendGiftButtonState();
}

class _NSendGiftButtonState extends State<NSendGiftButton> {
  final targetFollowerController = NTargetFollowerController();

  final giftCountVN = ValueNotifier(1);

  final focusNode = FocusNode();
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return buildGift();
  }

  Widget buildGift() {
    return NTargetFollower(
      controller: targetFollowerController,
      targetAnchor: Alignment.topRight,
      followerAnchor: Alignment.bottomRight,
      target: buildGiftButton(
        countVN: giftCountVN,
        onMore: () {
          DLog.d("onMore");
          targetFollowerController.toggle();
        },
        onSend: () {
          DLog.d("onSend");
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
          },
          child: buildDropMenu(
            focusNode: focusNode,
            controller: textController,
            onChanged: (int value) {
              DLog.d("onSend $value");
              widget.onChanged(value);
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
      width: 140,
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
                        constraints: BoxConstraints(
                          minWidth: 26,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        child: Text(
                          '$value',
                          style: TextStyle(
                            color: Color(0xFF303034),
                            fontSize: 12,
                            fontFamily: 'PingFang SC',
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
                    child: Image(
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
              child: Text(
                '赠送',
                style: TextStyle(
                  color: Color(0xFFFAFAFA),
                  fontSize: 12,
                  fontFamily: 'PingFang SC',
                  height: 0,
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
    void onInput(String v) {
      DLog.d(v);
      final num = int.tryParse(v) ?? 0;
      if (num <= 0) {
        return;
      }
      onChanged(num);
    }

    return Container(
      width: 120,
      height: 200 + 12,
      padding: EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        // color: Colors.green,
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
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
                TextField(
                  focusNode: focusNode,
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
                    hintStyle: TextStyle(color: Color(0xFFA7A7AE), fontSize: 14),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (v) => onInput.debounce.call(v),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: items.map((e) {
                    return GestureDetector(
                      onTap: () {
                        DLog.d(e);
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
                          style: TextStyle(
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
          ),
        ],
      ),
    );
  }
}
