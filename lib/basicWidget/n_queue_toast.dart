import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/tool_util.dart';

/// 队列 Toast 动画
class NQueueToast {
  static final GlobalKey navigatorKey = ToolUtil.navigatorKey;

  /// 监听列表
  static final List<bool Function(String? routeName, Map<String, dynamic> v)> _listeners = [];

  // 添加监听
  static void addListener(bool Function(String? routeName, Map<String, dynamic> v) cb) {
    if (_listeners.contains(cb)) {
      return;
    }
    _listeners.add(cb);
  }

  // 移除监听
  static void removeListener(bool Function(String? routeName, Map<String, dynamic> v) cb) {
    _listeners.remove(cb);
  }

  /// 通知所有监听器
  static bool notify({
    required String? routeName,
    required Map<String, dynamic> v,
    bool Function(String? routeName)? test,
  }) {
    for (var ltr in _listeners) {
      if (test != null) {
        if (test(routeName)) {
          final result = ltr(routeName, v);
          if (result) {
            return result;
          }
        }
      } else {
        final result = ltr(routeName, v);
        if (result) {
          return result;
        }
      }
    }
    return false;
  }

  /// 数据列表
  static final List<_NQueueToastModel> _models = [];

  /// 展示进球动画
  ///
  /// data 比赛信息
  /// isHomeGoal 主队进球
  /// isAwayGoal 客队进球
  /// predicate 进球动画过滤条件,为空默认展示进球
  /// onTap 点击事件
  static show({
    required Map<String, dynamic> data,
    required int Function(Map<String, dynamic> e) idCb,
    bool Function(Map<String, dynamic> e)? predicate,
    int? maxCount,
    void Function(int id)? onTap,
    double bottom = 100,
    double height = 56,
    double spacing = 12,
    double horizalSpacing = 30,
    required Widget child,
  }) {
    final overlayState = Overlay.of(navigatorKey.currentContext!);

    // 若已经显示，则忽略
    final matchShowing = _models.any((e) => idCb(e.data) == idCb(data));
    final needShow = predicate?.call(data) ?? true;
    if (matchShowing || !needShow) {
      return;
    }

    if (maxCount != null) {
      if (_models.length >= maxCount) {
        remove(idCb(_models.last.data));
      }
    }

    final key = GlobalKey<_NQueueToastItemState>();
    final entry = OverlayEntry(
      builder: (context) {
        int index = _models.indexWhere((e) => idCb(e.data) == idCb(data));
        return _NQueueToastItem(
          key: key,
          index: index,
          data: data,
          idCb: idCb,
          onTap: onTap,
          onDismiss: (int? id) {
            remove(id);
          },
          bottom: bottom,
          height: height,
          spacing: spacing,
          horizalSpacing: horizalSpacing,
          child: child,
        );
      },
    );

    _models.insert(0, _NQueueToastModel(data: data, idCb: idCb, entry: entry, key: key));
    overlayState.insert(entry);
    _rebuildAll();
  }

  static void remove(int? id) {
    if (id == null) {
      return;
    }

    final index = _models.indexWhere((e) => e.idCb(e.data) == id);
    if (index != -1) {
      final e = _models[index];
      e.entry.remove();
      e.key.currentState?.dismissWithAnimation(); // 右滑;
      _models.removeAt(index);
      _rebuildAll();
    }
  }

  static void _rebuildAll() {
    for (final e in _models) {
      e.entry.markNeedsBuild();
    }
  }

  static int indexOf(Map<String, dynamic> data) {
    return _models.indexWhere((e) => e.idCb(e.data) == e.idCb(data));
  }

  static void removeAll({Duration stagger = const Duration(milliseconds: 60)}) {
    final entries = List<_NQueueToastModel>.from(_models);

    for (int i = 0; i < entries.length; i++) {
      final e = entries[i];
      Future.delayed(stagger * i, () {
        e.key.currentState?.dismissWithAnimation();
      });
    }
  }
}

class _NQueueToastModel {
  _NQueueToastModel({
    required this.data,
    required this.idCb,
    required this.entry,
    required this.key,
  });

  final Map<String, dynamic> data;
  final int Function(Map<String, dynamic> e) idCb;
  final OverlayEntry entry;
  final GlobalKey<_NQueueToastItemState> key;
}

class _NQueueToastItem extends StatefulWidget {
  const _NQueueToastItem({
    super.key,
    required this.data,
    required this.idCb,
    required this.index,
    required this.onDismiss,
    this.onTap,
    this.bottom = 100,
    this.height = 56,
    this.spacing = 12,
    this.horizalSpacing = 30,
    required this.child,
  });

  final int index;
  final Map<String, dynamic> data;
  final int Function(Map<String, dynamic> e) idCb;
  final ValueChanged<int?> onDismiss;
  final void Function(int id)? onTap;

  /// 距离屏幕底部间距
  final double bottom;

  /// 组件高度
  final double height;

  /// 垂直边距
  final double spacing;

  /// 水平边距
  final double horizalSpacing;
  final Widget child;

  @override
  State<_NQueueToastItem> createState() => _NQueueToastItemState();
}

class _NQueueToastItemState extends State<_NQueueToastItem> with TickerProviderStateMixin {
  /// 当前主 View
  FlutterView get current => PlatformDispatcher.instance.views.first;

  /// 屏幕宽高
  Size get screenSize => current.physicalSize / current.devicePixelRatio;

  late final animController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final offsetAnimation = Tween<Offset>(
    begin: const Offset(1.0, 0.0),
    end: const Offset(0, 0.0),
  ).animate(CurvedAnimation(
    parent: animController,
    curve: Curves.easeInOut,
  ));

  late final opacityAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: animController,
    curve: Curves.easeOut,
  ));

  AnimationController? reboundController;
  StreamSubscription? _hideSubscription;

  double dragOffsetX = 0.0;
  double? _hoverHeight;

  @override
  void initState() {
    super.initState();

    animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _hideAfterDelay();
      }
    });

    animController.forward();
  }

  void _hideAfterDelay([Duration delay = const Duration(seconds: 5)]) {
    _hideSubscription?.cancel();
    _hideSubscription = Stream.fromFuture(Future.delayed(delay)).listen((_) async {
      if (!mounted) {
        return;
      }
      await animController.reverse();
      widget.onDismiss(widget.idCb(widget.data));
    });
  }

  void dismissWithSlideOut({bool toRight = true}) {
    reboundController?.dispose();
    reboundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    final animation = Tween<double>(
      begin: dragOffsetX,
      end: toRight ? screenSize.width : -screenSize.width,
    ).animate(CurvedAnimation(
      parent: reboundController!,
      curve: Curves.easeOut,
    ));

    reboundController!.addListener(() {
      dragOffsetX = animation.value;
      setState(() {});
    });

    reboundController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onDismiss(widget.idCb(widget.data));
      }
    });

    reboundController!.forward();
  }

  void _reboundToOrigin() {
    reboundController?.dispose();
    reboundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    final animation = Tween<double>(
      begin: dragOffsetX,
      end: 0,
    ).animate(CurvedAnimation(
      parent: reboundController!,
      curve: Curves.easeOut,
    ));

    reboundController!.addListener(() {
      dragOffsetX = animation.value;
      setState(() {});
    });

    reboundController!.forward();
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    dragOffsetX += details.delta.dx;
    dragOffsetX = dragOffsetX.clamp(-screenSize.width, screenSize.width);
    setState(() {});
    _hideSubscription?.cancel();
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    const double threshold = 100;

    if (dragOffsetX > threshold) {
      dismissWithSlideOut(toRight: true); // 右滑
    } else if (dragOffsetX < -threshold) {
      dismissWithSlideOut(toRight: false); // 左滑
    } else {
      _reboundToOrigin(); // 回弹
      _hideAfterDelay();
    }
  }

  void onTapDown(TapDownDetails details) {
    _hideSubscription?.cancel();
    _hoverHeight = widget.bottom + NQueueToast.indexOf(widget.data) * (widget.height + widget.spacing);
  }

  void onTapUp(TapUpDetails details) {
    _hideAfterDelay(const Duration(seconds: 2));
  }

  Future<void> dismissWithAnimation() async {
    _hideSubscription?.cancel();
    if (!mounted) {
      return;
    }

    await animController.reverse();
    widget.onDismiss(widget.idCb(widget.data));
  }

  @override
  void dispose() {
    animController.dispose();
    reboundController?.dispose();
    _hideSubscription?.cancel();
    widget.onDismiss(widget.idCb(widget.data));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom =
        _hoverHeight ?? widget.bottom + (NQueueToast.indexOf(widget.data) + 1) * (widget.height + widget.spacing);
    return AnimatedPositioned(
      bottom: bottom,
      left: 0,
      duration: const Duration(milliseconds: 300),
      child: SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: opacityAnimation,
          child: Transform.translate(
            offset: Offset(dragOffsetX, 0),
            child: GestureDetector(
              onTap: () => widget.onTap?.call(widget.idCb(widget.data)),
              onHorizontalDragUpdate: onHorizontalDragUpdate,
              onHorizontalDragEnd: onHorizontalDragEnd,
              onTapDown: onTapDown,
              onTapUp: onTapUp,
              child: Container(
                width: screenSize.width,
                padding: EdgeInsets.symmetric(horizontal: widget.horizalSpacing),
                child: Container(
                  height: widget.height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF86571).withOpacity(0.95),
                    // borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 进球动画展示监听 mixin
mixin GoalAnimToastMixin<T extends StatefulWidget> on State<T> {
  @override
  void dispose() {
    NQueueToast.removeListener(goalAnimToastListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    NQueueToast.addListener(goalAnimToastListener);
  }

  bool goalAnimToastListener(String? routeName, Map<String, dynamic> v) {
    // DLog.d("${[routeName, v.matchId]}");
    throw UnimplementedError("❌$this Not implemented enterGoalAnimToastLtr");
  }
}
