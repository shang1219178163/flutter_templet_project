import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/livestream/livestream_gift_send_card.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            countVN.value = 90;

            const heightRatio = 420.0 / 932.0;
            var top = NScreenManager.screenSize.height * heightRatio;
            NReuseToast.show(
              context: context,
              initialTop: top,
              tag: "success",
              message: "第一次",
              child: buildGiftCard(count: countVN.value),
            );
          },
          child: Text("第一次 ${countVN.value}"),
        ),
        ElevatedButton(
          onPressed: () {
            countVN.value++;

            const heightRatio = 420.0 / 932.0;
            var top = NScreenManager.screenSize.height * heightRatio;
            NReuseToast.show(
              context: context,
              initialTop: top,
              tag: "success",
              message: "更新内容 ${countVN.value}",
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
            const heightRatio = 420.0 / 932.0;
            var top = NScreenManager.screenSize.height * heightRatio;
            NReuseToast.show(
              context: context,
              initialTop: top,
              tag: "error $num",
              max: 5,
              message: "新的 toast",
              child: buildGiftCard(count: num),
            );
          },
          child: Text("新的 toast"),
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

    return LiveStreamGiftSendCard(
      avatar: avatar,
      name: nickName,
      giftName: goodsName,
      giftUrl: giftUrl,
      giftColor: Color(0xFFE13508),
      giftCount: giftCount,
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
        return NOverlaySlideAnimatedCard(
          height: 60,
          top: 400 + v * 50,
          left: v * 10,
          right: v * 10,
          beginOffset: Offset(1, 0),
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

/// OverlayEntry 动画卡片
class NOverlaySlideAnimatedCard extends StatefulWidget {
  const NOverlaySlideAnimatedCard({
    super.key,
    this.alignment = Alignment.centerLeft,
    required this.height,
    required this.top,
    this.left = 0,
    this.right = 0,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.beginOffset = const Offset(1, 0),
  });

  final AlignmentGeometry? alignment;

  final double height;

  final double top;

  final double left;

  final double right;

  final Widget Function(Future<void> Function() onDismiss) child;

  /// 动画时间
  final Duration duration;

  /// 初始偏移
  final Offset beginOffset;

  @override
  State<NOverlaySlideAnimatedCard> createState() => NOverlaySlideAnimatedCardState();
}

class NOverlaySlideAnimatedCardState extends State<NOverlaySlideAnimatedCard> {
  /// 初始在屏幕外
  Offset offset = Offset.zero;

  double opacity = 0;

  bool isDismissing = false;

  @override
  void initState() {
    super.initState();

    offset = widget.beginOffset;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      offset = Offset.zero;
      opacity = 1;
      setState(() {});
    });
  }

  /// dismiss 动画
  Future<void> dismiss() async {
    if (isDismissing || !mounted) {
      return;
    }
    isDismissing = true;
    offset = widget.beginOffset;
    opacity = 0;
    setState(() {});
    await Future.delayed(widget.duration);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: widget.duration,
      top: widget.top,
      left: widget.left,
      right: widget.right,
      child: AnimatedOpacity(
        duration: widget.duration,
        opacity: opacity,
        child: AnimatedSlide(
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          offset: offset,
          child: Container(
            height: widget.height,
            alignment: widget.alignment,
            child: widget.child(dismiss),
          ),
        ),
      ),
    );
  }
}
