import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/livestream/livestream_gift_send_card.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/overlay/card/n_overlay_slide_card.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_overlay_zindex_manager.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_reuse_toast.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/n_screen_manager.dart';
import 'package:get/get.dart';

/// OverlayEntry 弹窗
class OverlayEntryPage extends StatefulWidget {
  const OverlayEntryPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<OverlayEntryPage> createState() => _OverlayEntryPageState();
}

class _OverlayEntryPageState extends State<OverlayEntryPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  final countVN = ValueNotifier(0);

  final heightRatio = 420.0 / 932.0;
  late final top = NScreenManager.screenSize.height * heightRatio;

  bool isLeft = true;

  double get leftSpacing => 0;
  Offset get beginOffset => isLeft ? Offset(-1, 0) : Offset(1, 0);
  Alignment get alignment => isLeft ? Alignment.centerLeft : Alignment.centerRight;

  @override
  void dispose() {
    NReuseToast.clear();
    super.dispose();
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
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              SwitchListTile(
                title: Text(isLeft ? "Slide in left" : "Slide in right"),
                value: isLeft,
                onChanged: (v) {
                  isLeft = v;
                  setState(() {});
                },
              ),
              NSectionBox(
                title: "直播礼物卡片",
                child: buildLivestreamBox(),
              ),
              NSectionBox(
                title: "NOverlayZIndexManager",
                child: buildWrap(
                  onChanged: showOverlayZIndex,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLivestreamBox() {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton(
          onPressed: () {
            countVN.value = 90;

            NReuseToast.show(
              context: context,
              initialTop: top,
              left: leftSpacing,
              beginOffset: beginOffset,
              alignment: alignment,
              tag: "success",
              child: buildGiftCard(count: countVN.value),
            );
          },
          child: Text("第一次 ${countVN.value}"),
        ),
        ElevatedButton(
          onPressed: () {
            countVN.value++;

            NReuseToast.show(
              context: context,
              initialTop: top,
              left: leftSpacing,
              beginOffset: beginOffset,
              alignment: alignment,
              tag: "success",
              child: buildGiftCard(count: countVN.value),
            );
          },
          child: Text("更新内容"),
        ),
        ElevatedButton(
          onPressed: () {
            countVN.value++;
            final num = countVN.value;
            // 不同类型
            NReuseToast.show(
              context: context,
              initialTop: top,
              left: leftSpacing,
              beginOffset: beginOffset,
              alignment: alignment,
              duration: Duration(seconds: 5),
              tag: "tag $num",
              max: 9,
              child: buildGiftCard(count: num),
            );
          },
          child: Text("新的 toast"),
        ),
        ElevatedButton(
          onPressed: () {
            countVN.value++;
            final num = countVN.value;
            // 不同类型
            NReuseToast.show(
              context: context,
              initialTop: top,
              left: leftSpacing,
              beginOffset: beginOffset,
              alignment: Alignment.center,
              slideDuration: Duration.zero,
              tag: "tag $num",
              max: 6,
              child: buildGiftCard(count: num),
            );
          },
          child: Text("无动画"),
        ),
      ],
    );
  }

  Widget buildGiftCard({int count = 99}) {
    final avatar = "https://p9-passport.byteacctimg.com/img/user-avatar/ad3a331f1d369e7b6b9fb461fb4dcab4~40x40.awebp";
    final nickName = "小西同学";
    final goodsName = "大啤酒";
    final giftUrl = "https://p6-passport.byteacctimg.com/img/mosaic-legacy/3795/3033762272~100x100.awebp";
    final giftCount = count;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: LiveStreamGiftSendCard(
        avatar: avatar,
        name: nickName,
        giftName: goodsName,
        giftUrl: giftUrl,
        giftColor: Color(0xFFE13508),
        giftCount: giftCount,
      ),
    );
  }

  Widget buildWrap({required ValueChanged<int> onChanged}) {
    final list = List.generate(8, (i) => i);

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 8.0;
        final rowCount = 4.0;
        final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...list.map(
              (e) {
                final i = list.indexOf(e);
                final btnTitle = "card $e";
                return GestureDetector(
                  onTap: () => onChanged(i),
                  child: Container(
                    width: itemWidth.truncateToDouble(),
                    height: itemWidth * 0.6,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Text(
                      btnTitle,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void showOverlayZIndex(int v) {
    DLog.d(v);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) {
        return NOverlaySlideCard(
          height: 60,
          top: 400 + v * 50,
          left: v * 10,
          right: v * 10,
          beginOffset: beginOffset,
          child: (onDismiss) => GestureDetector(
            onTap: () async {
              await onDismiss();
              NOverlayZIndexManager.instance.removeWhere((e) => e.entry == entry);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorExt.random,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "$v 这是一条测试数据!",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );

    NOverlayZIndexManager.instance.show(
      context: context,
      zIndex: v * 100,
      // key: key,
      entry: entry,
    );
  }
}
