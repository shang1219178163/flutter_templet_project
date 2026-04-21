//
//  LivestreamEffectPage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/20 15:47.
//  Copyright © 2026/4/20 shang. All rights reserved.
//

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_chat_bubble.dart';
import 'package:flutter_templet_project/basicWidget/n_expand_choice.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/generated/assets.dart';
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
                  buildChatBubble(isMe: isMe, text: textShort),
                ],
              ),
            ),
            NSectionBox(
              title: "buildEffect",
              child: Column(
                children: [
                  buildEffectFirst(),
                ],
              ),
            ),
            NSectionBox(
              title: "buildGiftCard",
              child: Column(
                children: [
                  buildEffectFirst(),
                ],
              ),
            ),
            buildGiftCard(),
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
    return buildMessage(
      isMe: isMe,
      child: NChatBubble(
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
      ),
    );
  }

  Widget buildEffectFirst() {
    return Container(
      // padding: EdgeInsets.symmetric(),
      // decoration: BoxDecoration(
      //   color: Colors.transparent,
      //   border: Border.all(color: Colors.blue),
      //   borderRadius: BorderRadius.all(Radius.circular(0)),
      // ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: 40,
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.only(left: 24, right: 28 + 10, top: 10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(0)),
              image: DecorationImage(
                image: AssetImage(Assets.messageEffectFirst),
              ),
            ),
            // decoration: ShapeDecoration(
            //   // color: Colors.red,
            //   gradient: LinearGradient(
            //     colors: [
            //       Color(0xFFFFD13B),
            //       Color(0xFFF49D25).withOpacity(0.9),
            //       Color(0xFFF49D25).withOpacity(0.0),
            //     ],
            //   ),
            //   shape: StadiumBorder(
            //     side: BorderSide(
            //       color: Color(0xFF9D25E5),
            //     ),
            //   ),
            // ),
            child: Text(
              "小明同学进入直播间",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                // backgroundColor: Colors.green,
              ),
            ),
          ),
          // Positioned(
          //   top: 4,
          //   left: 0,
          //   child: Image(
          //     image: AssetImage(Assets.assetsIconGoldMedal),
          //     width: 24,
          //     height: 32,
          //   ),
          // ),
          // Positioned(
          //   top: 0,
          //   right: 0,
          //   child: Image(
          //     image: AssetImage(Assets.assetsIconTrophy),
          //     width: 28,
          //     height: 36,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildGiftCard() {
    final avatar = "https://p9-passport.byteacctimg.com/img/user-avatar/ad3a331f1d369e7b6b9fb461fb4dcab4~40x40.awebp";
    final name = "小西同学";
    final gift = "大啤酒";
    final giftUrl = "https://p6-passport.byteacctimg.com/img/mosaic-legacy/3795/3033762272~100x100.awebp";
    final num = "×10";

    return Container(
      height: 40,
      width: 214,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE13508),
            Color(0xFFE13508).withOpacity(0.0),
          ],
        ),
        shape: StadiumBorder(),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 4),
          NNetworkImage(
            url: avatar,
            radius: 16,
            width: 32,
            height: 32,
          ),
          SizedBox(width: 13),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                gift,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(width: 13),
          NNetworkImage(
            url: giftUrl,
            radius: 16,
            width: 32,
            height: 32,
          ),
          SizedBox(width: 8),
          Text(
            num,
            style: TextStyle(
              color: Color(0xFFFFD876),
              fontSize: 26,
              fontWeight: FontWeight.w900,
              fontFamily: 'DDINPRO',
            ),
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }
}
