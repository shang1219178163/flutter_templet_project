
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PromptItem {
  GlobalKey promptWidgetKey;
  String promptTips;

  PromptItem(this.promptWidgetKey, this.promptTips);
}

class PromptBuilder {
  static List<PromptItem> toPromptWidgetKeys = [];
  static OverlayEntry? lastOverlay;

  static promptToWidgets(List<PromptItem> widgetKeys) {
    toPromptWidgetKeys = widgetKeys;
    _prepareToPromptSingleWidget();
  }

  static _prepareToPromptSingleWidget() async {
    if (toPromptWidgetKeys.isEmpty) {
      return;
    }
    var promptItem = toPromptWidgetKeys.removeAt(0);

    var promptRenderObject =
    promptItem.promptWidgetKey.currentContext?.findRenderObject();
    var widgetHeight = promptRenderObject?.paintBounds.height ?? 0;
    var widgetWidth = promptRenderObject?.paintBounds.width ?? 0;

    var widgetTop = 0.0;
    var widgetLeft = 0.0;

    if (promptRenderObject is RenderBox) {
      var offset = promptRenderObject.localToGlobal(Offset.zero);
      widgetTop = offset.dy;
      widgetLeft = offset.dx;
    }

    if (widgetHeight != 0 &&
        widgetWidth != 0 &&
        widgetTop != 0 &&
        widgetLeft != 0) {
      _buildNextPromptOverlay(
          promptItem.promptWidgetKey.currentContext!,
          widgetWidth,
          widgetHeight,
          widgetLeft,
          widgetTop,
          null,
          promptItem.promptTips);
    }
  }

  static _buildNextPromptOverlay(BuildContext context, double w, double h,
      double l, double t, Decoration? decoration, String tips) {
    _removeCurrentOverlay();
    lastOverlay = OverlayEntry(builder: (ctx) {
      return GestureDetector(
        onTap: () {
          // 点击后移除当前展示的overlay
          _removeCurrentOverlay();
          // 准备展示下一个overlay
          _prepareToPromptSingleWidget();
        },
        child: Stack(
          children: [
            Positioned.fill(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.srcOut),
                  child: Stack(
                    children: [
                      // 透明色填充背景，作为蒙版
                      Positioned.fill(
                          child: Container(
                            color: Colors.transparent,
                          )),
                      // 镂空区域
                      Positioned(
                          left: l,
                          top: t,
                          child: Container(
                            width: w,
                            height: h,
                            decoration: decoration ??
                                const BoxDecoration(color: Colors.black),
                          )),
                    ],
                  ),
                )),
            // 文字提示，需要放在ColorFiltered的外层
            Positioned(
                left: l - 40,
                top: t - 40,
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    tips,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ))
          ],
        ),
      );
    });
    Overlay.of(context).insert(lastOverlay!);
  }

  static _removeCurrentOverlay() {
    if (lastOverlay != null) {
      lastOverlay!.remove();
      lastOverlay = null;
    }
  }
}