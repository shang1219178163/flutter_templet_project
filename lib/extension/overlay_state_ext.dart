





import 'package:flutter/cupertino.dart';

extension OverlayStateExt<T extends StatefulWidget> on State<T> {

  OverlayState get overlayState => Overlay.of(context);
  /// overlay 层集合
  static final List<OverlayEntry> _entriesList = [];
  /// 当前弹窗
  static OverlayEntry? overlayEntry;

  /// OverlayEntry 弹窗展示
  showOverlayEntry({
    required Widget child,
    bool removeOld = false,
    bool maintainState = false,
  }){
    if (removeOld) {
      dismissOverlayEntry();
    }
    overlayEntry ??= OverlayEntry(
      maintainState: maintainState,
      builder: (_) => child,
    );
    overlayState.insert(overlayEntry!);
    _entriesList.add(overlayEntry!);
  }

  /// OverlayEntry 弹窗移除
  dismissOverlayEntry() {
    if (overlayEntry == null) {
      return;
    }
    overlayEntry?.remove();
    _entriesList.remove(overlayEntry!);
    overlayEntry = null;
  }

  /// OverlayEntry 清除
  clearOverlayEntry() {
    for (final entry in _entriesList) {
      entry.remove();
    }
    _entriesList.clear();
  }

}

