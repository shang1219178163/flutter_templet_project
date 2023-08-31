

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_adaptive_text.dart';
import 'package:flutter_templet_project/basicWidget/n_slide_transition_builder.dart';
import 'package:flutter_templet_project/extension/overlay_ext.dart';

class NToast{
  /// overlay 层集合
  static final List<OverlayEntry> _entriesList = [];
  /// 当前弹窗
  static OverlayEntry? get currentOverlayEntry {
    if (_entriesList.isEmpty) {
      return null;
    }
    return _entriesList[_entriesList.length - 1];
  }

  /// 有 OverlayEntry 显示中
  bool get isLoading => _entriesList.isNotEmpty;

  /// OverlayEntry 弹窗展示
  static OverlayEntry? showEntry({
    required BuildContext context,
    required Widget child,
    bool isReplace = false,
    bool maintainState = false,
  }){
    final OverlayState? _overlayState = Overlay.of(context);
    if (_overlayState == null) {
      return null;
    }

    if (isReplace) {
      hideEntry();
    }

    final overlayEntry = OverlayEntry(
      maintainState: maintainState,
      builder: (_) => child,
    );

    _overlayState.insert(overlayEntry);
    _entriesList.add(overlayEntry);
    return overlayEntry;
  }

  /// OverlayEntry 弹窗移除
  static hideEntry({duration = const Duration(milliseconds: 350)}) {
    if (currentOverlayEntry == null) {
      return;
    }
    Future.delayed(duration, () { });
    currentOverlayEntry?.remove();
    _entriesList.remove(currentOverlayEntry!);
  }

  /// OverlayEntry 清除
  static clearEntry() {
    for (final entry in _entriesList) {
      entry.remove();
    }
    _entriesList.clear();
  }

  /// 展示 OverlayEntry 弹窗
  static showToast({
    required BuildContext context,
    String text = "showToast",
    Widget? child,
    Alignment alignment = Alignment.center,
    Duration duration = const Duration(milliseconds: 2000),
    bool barrierDismissible = true,
    Color? barrierColor = Colors.transparent,
    VoidCallback? onBarrier,
    bool isLast = false,
  }) {
    Widget content = NAdaptiveText(
      data: text,
      alignment: alignment,
      child: child,
    );

    if (barrierColor != null) {
      content = Stack(
        children: [
          Material(
            color: barrierColor,
            child: InkWell(
              onTap: onBarrier,
              child: Container(
                decoration: BoxDecoration(
                  color: barrierColor,
                ),
              ),
            ),
          ),
          content,
        ],
      );
    }
    showEntry(context: context, child: content);

    if (barrierDismissible) {
      Future.delayed(duration, hideEntry);
    }
  }

  /// 滑进滑出弹窗
  static presentModalView({
    required BuildContext context,
    bool isReplace = false,
    bool maintainState = false,
    Alignment alignment = Alignment.bottomCenter,
    duration = const Duration(milliseconds: 350),
    bool barrierDismissible = true,
    required OverlayWidgetBuilder builder,
  }) {
    final globalKey = GlobalKey<NSlideTransitionBuilderState>();

    onHide() async {
      if (alignment != Alignment.center) {
        await globalKey.currentState?.controller.reverse();
      }
      hideEntry();
    }

    showEntry(
        context: context,
        isReplace: isReplace,
        maintainState: maintainState,
        child: Material(
          color: Colors.black.withOpacity(0.1),
          child: InkWell(
            onTap: !barrierDismissible ? null : onHide,
            child: NSlideTransitionBuilder(
              key: globalKey,
              alignment: alignment,
              duration: duration,
              hasFade: false,
              child: builder(context, onHide),
            ),
          ),
        )
    );
  }

}