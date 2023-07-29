
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_adaptive_text.dart';


extension OverlayExt<T extends StatefulWidget> on State<T> {

  OverlayState get _overlayState => Overlay.of(context);
  /// overlay 层集合
  static final List<OverlayEntry> _entriesList = [];
  /// 当前弹窗
  static OverlayEntry? _overlayEntry;

  /// 有 OverlayEntry 显示中
  bool get isLoading => _entriesList.isNotEmpty;


  /// OverlayEntry 弹窗展示
  OverlayEntry? showEntry({
    required Widget child,
    bool isReplace = false,
    bool maintainState = false,
  }){
    if (isReplace) {
      hideEntry();
    }
    _overlayEntry ??= OverlayEntry(
      maintainState: maintainState,
      builder: (_) => child,
    );
    _overlayState.insert(_overlayEntry!);
    _entriesList.add(_overlayEntry!);
    return _overlayEntry;
  }

  /// OverlayEntry 弹窗移除
  hideEntry() {
    if (_overlayEntry == null) {
      return;
    }
    _overlayEntry?.remove();
    _entriesList.remove(_overlayEntry!);
    _overlayEntry = null;
  }

  /// OverlayEntry 清除
  clearEntry() {
    for (final entry in _entriesList) {
      entry.remove();
    }
    _entriesList.clear();
  }

  /// 展示 OverlayEntry 弹窗
  showToast({
    String text = "showToast",
    Widget? child,
    Alignment alignment = Alignment.center,
    Duration duration = const Duration(milliseconds: 2000),
    bool isDismiss = true,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    VoidCallback? onBarrier,
  }) {
    Widget content = NAdaptiveText(
      data: text,
      alignment: alignment,
      child: child,
    );

    if (barrierDismissible) {
      content = Stack(
        children: [
          InkWell(
            onTap: onBarrier,
            child: Container(
              decoration: BoxDecoration(
                color: barrierColor,
              ),
            ),
          ),
          content
        ],
      );
    }
    showEntry(child: content);

    if (isDismiss) {
      Future.delayed(duration, hideEntry);
    }
  }

}

