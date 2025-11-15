import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_templet_project/basicWidget/n_adaptive_text.dart';
import 'package:flutter_templet_project/basicWidget/n_slide_transition_builder.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:get/get.dart';

/// 浮层工具类
class NOverlay {
  static final _globalContext = Get.context;

  static final _overlayState = Overlay.of(_globalContext!);

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
  static OverlayEntry? show(
    BuildContext context, {
    bool isReplace = false,
    bool maintainState = false,
    required Widget child,
  }) {
    // var context = AppUtil.globalContext;
    final OverlayState? _overlayState = Overlay.of(context);
    if (_overlayState == null) {
      return null;
    }

    // debugPrint("AppUtil.globalContext: ${_globalContext}");
    // final _overlayState = Overlay.of(_globalContext!);

    if (isReplace) {
      hide();
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
  static hide({duration = const Duration(milliseconds: 350)}) {
    if (currentOverlayEntry == null) {
      return;
    }
    Future.delayed(duration, () {});
    currentOverlayEntry?.remove();
    _entriesList.remove(currentOverlayEntry!);
  }

  /// OverlayEntry 清除
  static clear() {
    for (final entry in _entriesList) {
      entry.remove();
    }
    _entriesList.clear();
  }

  /// 展示 OverlayEntry 弹窗
  static showToast(
    BuildContext context, {
    String message = "showToast",
    Widget? child,
    Alignment alignment = Alignment.center,
    Duration duration = const Duration(milliseconds: 2000),
    bool autoDismiss = true,
    Color? barrierColor = Colors.transparent,
    VoidCallback? onBarrier,
    VoidCallback? onDismiss,
    bool isLast = false,
  }) {
    Widget content = NAdaptiveText(
      data: message,
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
    show(
      context,
      child: content,
    );

    if (autoDismiss) {
      Future.delayed(duration, () {
        hide();
        onDismiss?.call();
      });
    }
  }

  static showLoading(
    BuildContext context, {
    String message = "showToast",
    Widget? child,
  }) {
    NOverlay.showToast(
      context,
      duration: const Duration(milliseconds: 5000),
      autoDismiss: true,
      onDismiss: () {
        debugPrint("onDismiss: ${DateTime.now()}");
      },
      // barrierDismissible: false,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SpinkitWidget(),
              ],
            ),
          ),
          child ??
              NText(
                message,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
        ],
      ),
    );
  }

  /// 滑进滑出弹窗
  static presentModalView(
    BuildContext context, {
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
      hide();
    }

    show(context,
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
        ));
  }
}

class _SpinkitWidget extends StatefulWidget {
  _SpinkitWidget();

  @override
  _SpinkitWidgetState createState() => _SpinkitWidgetState();
}

class _SpinkitWidgetState extends State<_SpinkitWidget> with SingleTickerProviderStateMixin {
  final spinkit = SpinKitFadingCircle(
    color: Colors.white,
    // itemBuilder: (BuildContext context, int index) {
    //   return DecoratedBox(
    //     decoration: BoxDecoration(
    //       color: index.isEven ? Colors.red : Colors.green,
    //     ),
    //   );
    // },
  );

  final spinkit1 = SpinKitCircle(
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return spinkit1;
  }
}
