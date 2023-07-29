
import 'package:flutter/material.dart';


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
    bool removeOld = false,
    bool maintainState = false,
  }){
    if (removeOld) {
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
  }) {

    Widget content = NAdaptiveText(
      data: text,
      alignment: alignment,
      child: child,
    );
    if (barrierDismissible) {
      content = Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: barrierColor,
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

/// 自适应文本组件
class NAdaptiveText extends StatelessWidget {

  const NAdaptiveText({
    Key? key,
    this.data = "自适应文本组件",
    this.child,
    this.alignment = Alignment.center,
    this.margin = const EdgeInsets.symmetric(horizontal: 30),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.decoration,
  }) : super(key: key);

  final String data;

  final Widget? child;

  final Alignment alignment;

  final EdgeInsets margin;
  final EdgeInsets padding;
  final BoxDecoration? decoration;


  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: alignment,
      child: Container(
        margin: margin ?? EdgeInsets.symmetric(horizontal: 30),
        padding: padding ?? EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: decoration ?? BoxDecoration(
          color: const Color(0xFF222222),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: child ?? Text(
          data,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}