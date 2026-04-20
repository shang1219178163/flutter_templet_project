import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_decoration/en_decoration_image.dart';
import 'package:flutter_templet_project/basicWidget/n_chat_bubble.dart';
import 'package:flutter_templet_project/basicWidget/n_expand_choice.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:get/get.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class ImChatBubbleDemo extends StatefulWidget {
  const ImChatBubbleDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ImChatBubbleDemo> createState() => _ImChatBubbleDemoState();
}

class _ImChatBubbleDemoState extends State<ImChatBubbleDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  final bgChatBubbles = [
    Assets.imagesBgChatBubble1,
    Assets.imagesBgChatBubble2,
    Assets.imagesBgChatBubble3,
    Assets.imagesBgChatBubble4,
    Assets.imagesBgChatBubble5,
    Assets.imagesBgChatBubble6,
    Assets.imagesBgChatBubble7,
    Assets.imagesBgChatBubble8,
    Assets.imagesBgChatBubble9,
    Assets.imagesBgChatBubble10,
  ];

  late var bgChatBubbleIndex = 0;

  String get bgChatBubble => bgChatBubbles[bgChatBubbleIndex];

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
    final textShort = text.substring(0, 5);

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
                  buildChatBubble(isMe: isMe, text: text),
                  buildChatBubble(isMe: isMe, text: text.substring(0, text.length - 20)),
                  buildChatBubble(isMe: isMe, text: text.substring(0, text.length - 40)),
                  buildChatBubble(isMe: isMe, text: text.substring(0, text.length - 60)),
                  buildChatBubble(isMe: isMe, text: text.substring(0, text.length - 80)),
                  buildChatBubble(isMe: isMe, text: text.substring(0, text.length - 100)),
                  buildChatBubble(isMe: isMe, text: text.substring(0, text.length - 113)),
                ],
              ),
            ),
            NSectionBox(
              title: "buildBubble",
              child: Column(
                children: [
                  buildBubble(isMe: isMe, text: text),
                  buildBubble(isMe: isMe, text: text.substring(0, text.length - 20)),
                  buildBubble(isMe: isMe, text: text.substring(0, text.length - 40)),
                  buildBubble(isMe: isMe, text: text.substring(0, text.length - 60)),
                  buildBubble(isMe: isMe, text: text.substring(0, text.length - 80)),
                  buildBubble(isMe: isMe, text: text.substring(0, text.length - 100)),
                  buildBubble(isMe: isMe, text: text.substring(0, text.length - 113)),
                ],
              ),
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
      rowCount: 5,
      leading: (e) => Image(
        image: AssetImage(e),
        width: 58,
        height: 64,
      ),
      itemsMargin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      // itemsBackgroudColor: Colors.green,
      items: bgChatBubbles,
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
        bgChatBubbleIndex = index;
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

  Widget buildBubble({
    required bool isMe,
    required String text,
  }) {
    final imageSize = Size(58, 44);
    final constraints = BoxConstraints(minWidth: imageSize.width, minHeight: imageSize.height);
    final safeInset = const EdgeInsets.symmetric(horizontal: 24, vertical: 18);
    final centerSlice = Rect.fromLTWH(safeInset.left, safeInset.top, 1, 1);

    final padding = EdgeInsets.only(
      top: safeInset.top - 4,
      bottom: safeInset.bottom - 4,
      left: safeInset.left - 8,
      right: safeInset.right - 8,
    );

    final child = Container(
      margin: const EdgeInsets.only(top: 10),
      // ⭐关键1：给足最小高度（防止单行塌陷）
      constraints: constraints,
      // ⭐关键2：padding 不能贴边
      padding: padding,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.blue),
        image: DecorationImage(
          image: AssetImage(bgChatBubble),
          // ⭐关键3：中心点必须在“纯色区域”
          centerSlice: centerSlice,
          fit: BoxFit.fill,
          scale: 3,
        ),
      ),
      child: Text(text),
    );

    return buildMessage(isMe: isMe, child: child);
  }

  Widget buildChatBubble({
    required bool isMe,
    required String text,
  }) {
    return buildMessage(
      isMe: isMe,
      child: NChatBubble(
        imagePath: bgChatBubble,
        metrics: NChatBubbleMetrics(
          imageSize: const Size(58, 44),
          safeInset: const EdgeInsets.fromLTRB(23, 19, 19, 11),
        ),
        child: Text(text),
      ),
    );
  }
}
