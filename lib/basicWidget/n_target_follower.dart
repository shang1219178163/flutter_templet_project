//
//  n_target_follower.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/18 14:05.
//  Copyright © 2023/10/18 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 关联组件
class NTargetFollower extends StatefulWidget {
  const NTargetFollower({
    super.key,
    this.controller,
    this.targetAnchor = Alignment.topCenter,
    this.followerAnchor = Alignment.bottomCenter,
    this.targetAnchorBuilder,
    this.followerAnchorBuilder,
    this.showWhenUnlinked = true,
    this.offset = Offset.zero,
    this.offsetBuilder,
    this.onTap,
    this.onLongPressEnd,
    required this.target,
    required this.followerBuilder,
    this.entries,
  });

  final NTargetFollowerController? controller;

  final Alignment targetAnchor;
  final Alignment followerAnchor;

  /// 目标对齐方式(高优先级)
  final Alignment Function(BuildContext context, LongPressStartDetails details)? targetAnchorBuilder;

  /// 跟随者对齐方式(高优先级)
  final Alignment Function(BuildContext context, LongPressStartDetails details)? followerAnchorBuilder;

  final bool showWhenUnlinked;

  final Offset offset;

  /// 跟随者对齐方式(高优先级)
  final Offset Function(BuildContext context, LongPressStartDetails details)? offsetBuilder;

  final GestureTapCallback? onTap;

  /// 实现此方法则弹窗不会自动关闭,需手动关闭
  final GestureLongPressEndCallback? onLongPressEnd;

  /// 传入此参数则页面仅显示一个
  final List<OverlayEntry>? entries;

  final Widget target;

  final VoidCallbackWidgetBuilder? followerBuilder;

  @override
  _NTargetFollowerState createState() => _NTargetFollowerState();
}

class _NTargetFollowerState extends State<NTargetFollower> {
  final LayerLink layerLink = LayerLink();

  late final _entries = widget.entries ?? <OverlayEntry>[];

  /// 是否图层展示中
  bool get isShowing => _entries.isNotEmpty;

  late OverlayEntry _overlayEntry;

  Offset indicatorOffset = const Offset(0, 0);

  @override
  void dispose() {
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  void initState() {
    widget.controller?._attach(this);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NTargetFollower oldWidget) {
    super.didUpdateWidget(oldWidget);
    final canUpdate = oldWidget.controller != widget.controller ||
        oldWidget.targetAnchor != widget.targetAnchor ||
        oldWidget.followerAnchor != widget.followerAnchor ||
        oldWidget.entries != widget.entries ||
        oldWidget.offset != widget.offset ||
        oldWidget.target != widget.target ||
        oldWidget.followerBuilder != widget.followerBuilder;
    if (!canUpdate) {
      return;
    }
    widget.controller?._attach(this);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.followerBuilder == null) {
      return widget.target;
    }

    return GestureDetector(
      onTap: widget.onTap,
      // onTap: _showOverlay,
      // onPanStart: (e) => _showOverlay(),
      // onPanEnd: (e) => _hideOverlay(),
      // onPanUpdate: updateIndicator,
      onLongPressStart: (e) => _showOverlay(e),
      onLongPressEnd: widget.onLongPressEnd ?? (e) => _hideOverlay(),
      onLongPressMoveUpdate: updateIndicatorLongPress,
      child: CompositedTransformTarget(
        link: layerLink,
        child: widget.target,
      ),
    );
  }

  void _showOverlay(LongPressStartDetails details) {
    _hideOverlay();

    _overlayEntry = _createOverlayEntry(indicatorOffset, details: details);
    _entries.add(_overlayEntry);
    Overlay.of(context).insert(_overlayEntry);
  }

  void _hideOverlay() {
    for (final e in _entries) {
      e.remove();
    }
    _entries.clear();
  }

  void updateIndicator(DragUpdateDetails details) {
    indicatorOffset = details.localPosition;
    _overlayEntry.markNeedsBuild();
  }

  void updateIndicatorLongPress(LongPressMoveUpdateDetails details) {
    indicatorOffset = details.localPosition;
    _overlayEntry.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry(
    Offset localPosition, {
    required LongPressStartDetails details,
  }) {
    indicatorOffset = localPosition;
    return OverlayEntry(
      builder: (BuildContext context) => UnconstrainedBox(
        child: CompositedTransformFollower(
          link: layerLink,
          targetAnchor: widget.targetAnchorBuilder?.call(context, details) ?? widget.targetAnchor,
          followerAnchor: widget.followerAnchorBuilder?.call(context, details) ?? widget.followerAnchor,
          offset: widget.offsetBuilder?.call(context, details) ?? widget.offset,
          showWhenUnlinked: widget.showWhenUnlinked,
          child: widget.followerBuilder?.call(context, _hideOverlay),
        ),
      ),
    );
  }
}

class NTargetFollowerController {
  _NTargetFollowerState? _anchor;

  void _attach(_NTargetFollowerState anchor) {
    _anchor = anchor;
  }

  void _detach(_NTargetFollowerState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  bool? get isShowing => _anchor?.isShowing;

  void show() {
    final details = LongPressStartDetails(
      localPosition: Offset.zero,
      globalPosition: Offset.zero,
    );
    _anchor?._showOverlay(details);
  }

  void hide() {
    _anchor?._hideOverlay();
  }

  void toggle() {
    if (isShowing == true) {
      hide();
    } else {
      show();
    }
  }
}
