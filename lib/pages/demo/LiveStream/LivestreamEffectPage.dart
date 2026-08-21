//
//  LivestreamEffectPage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/20 15:47.
//  Copyright © 2026/4/20 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_chat_bubble.dart';
import 'package:flutter_templet_project/basicWidget/n_expand_choice.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_queue_card.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/pages/demo/LiveStream/LiveStreamEnterEffectCard.dart';
import 'package:flutter_templet_project/pages/demo/LiveStream/LiveStreamGiftSendCard.dart';
import 'package:get/get.dart';

/// 直播间效果demo
class LivestreamEffectPage extends StatefulWidget {
  const LivestreamEffectPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<LivestreamEffectPage> createState() => _LivestreamEffectPageState();
}

class _LivestreamEffectPageState extends State<LivestreamEffectPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  final items = <String>[
    Assets.messageEffectBeer,
    Assets.messageEffectFootball,
    Assets.messageEffectBasketball,
    Assets.messageEffectCar,
    Assets.messageEffectFireworks,
    Assets.messageEffectFirst,
  ];

  late var selectedIndex = 0;

  String get current => items[selectedIndex];

  final countVN = ValueNotifier(0);

  @override
  void didUpdateWidget(covariant LivestreamEffectPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    var imageUrl = "https://cdn.kbisai.com/kanbisai/goods/bubble/zu_qiu.png";
    // imageUrl = "https://cdn.kbisai.com/kanbisai/goods/bubble/lan_qiu.png";

    var text = "聊天气泡的“拉伸”本质是背景形状可伸缩（capInsets / 9-slice）+ 内容自适应";
    text += "可以，直接教你一套工程级“反推 centerSlice”方法，等价于 iOS 的 capInsets，而且可以做到一次算准、长期复用。";
    final textShort = text.substring(0, 15);

    final isMe = true;

    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            buildExpandMenu(),
            NSectionBox(
              title: "NChatBubble",
              child: Column(
                children: [
                  buildMessage(
                    isMe: isMe,
                    child: buildChatBubble(isMe: isMe, text: textShort),
                  ),
                ],
              ),
            ),
            NSectionBox(
              title: "EnterEffectCard",
              child: buildEnterEffectBox(text: textShort),
            ),
            NSectionBox(
              title: "GiftSendCard",
              child: buildGiftSendCardBox(),
            ),
          ],
        ),
      ),
    );
  }

  /// 颜色扩展菜单
  Widget buildExpandMenu() {
    return NExpandChoice<String>(
      title: '气泡主题',
      rowCount: 2,
      leading: (e) => Image(
        image: AssetImage(e),
        width: 150,
        height: 40,
      ),
      itemsMargin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      // itemsBackgroudColor: Colors.green,
      itemHeight: 40,
      items: items,
      itemBuilder: (e) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            // border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(0)),
            image: DecorationImage(image: AssetImage(e)),
          ),
        );
      },
      itemFooter: Divider(),
      onChanged: (index) {
        selectedIndex = index;
        setState(() {});
      },
    );
  }

  Widget buildMessage({
    required bool isMe,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Opacity(
          opacity: isMe ? 0 : 1,
          child: FlutterLogo(size: 48),
        ),
        Flexible(
          child: child,
        ),
        Opacity(
          opacity: !isMe ? 0 : 1,
          child: FlutterLogo(size: 48),
        ),
      ],
    );
  }

  Widget buildChatBubble({
    required bool isMe,
    required String text,
  }) {
    return NChatBubble(
      imagePath: current,
      metrics: NChatBubbleMetrics(
        imageSize: const Size(150, 40),
        safeInset: const EdgeInsets.fromLTRB(25, 11, 37, 11),
        adjust: EdgeInsets.only(top: 0),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 进场特效卡片效果
  Widget buildEnterEffectBox({required String text}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LiveStreamEnterEffectCard(
          imagePath: current,
          text: text,
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Widget child = LiveStreamEnterEffectCard(
                  imagePath: current,
                  text: text,
                );
                // child = buildChatBubble(isMe: isMe, text: textShort);

                NQueueCard.show(
                  context: context,
                  tag: "success",
                  child: child,
                );
              },
              child: Text("EnterEffectCard"),
            ),
          ],
        ),
      ],
    );
  }

  /// 礼物发送卡片效果
  Widget buildGiftSendCardBox() {
    final avatar = "https://p9-passport.byteacctimg.com/img/user-avatar/ad3a331f1d369e7b6b9fb461fb4dcab4~40x40.awebp";
    final name = "小西同学";
    final giftName = "大啤酒";
    final giftUrl = "https://p6-passport.byteacctimg.com/img/mosaic-legacy/3795/3033762272~100x100.awebp";
    final num = "×${countVN.value}";

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LiveStreamGiftSendCard(
          avatar: avatar,
          name: name,
          giftUrl: giftUrl,
          giftColor: Colors.red,
          giftName: giftName,
          giftCount: countVN.value,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                countVN.value = 90;

                final giftCard = LiveStreamGiftSendCard(
                  avatar: avatar,
                  name: name,
                  giftUrl: giftUrl,
                  giftColor: Colors.red,
                  giftName: giftName,
                  giftCount: countVN.value,
                );

                NQueueCard.show(
                  context: context,
                  tag: "success",
                  child: giftCard,
                );
              },
              child: Text("第一次 ${countVN.value}"),
            ),
            ElevatedButton(
              onPressed: () {
                countVN.value++;

                final giftCard = LiveStreamGiftSendCard(
                  avatar: avatar,
                  name: name,
                  giftUrl: giftUrl,
                  giftColor: Colors.red,
                  giftName: giftName,
                  giftCount: countVN.value,
                );
                NQueueCard.show(
                  context: context,
                  tag: "success",
                  child: giftCard,
                );
              },
              child: Text("更新内容"),
            ),
            ElevatedButton(
              onPressed: () {
                countVN.value++;
                final giftCard = LiveStreamGiftSendCard(
                  avatar: avatar,
                  name: name,
                  giftUrl: giftUrl,
                  giftColor: Colors.red,
                  giftName: giftName,
                  giftCount: countVN.value,
                );

                // 不同类型
                NQueueCard.show(
                  context: context,
                  tag: "tag ${countVN.value}",
                  max: 5,
                  child: giftCard,
                );
              },
              child: Text("新的 toast"),
            ),
          ],
        ),
      ],
    );
  }
}
