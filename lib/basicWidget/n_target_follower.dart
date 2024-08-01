//
//  n_target_follower.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/18 14:05.
//  Copyright © 2023/10/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/type_util.dart';

/// 关联组件
class NTargetFollower extends StatefulWidget {
  const NTargetFollower({
    super.key,
    this.targetAnchor = Alignment.topCenter,
    this.followerAnchor = Alignment.bottomCenter,
    this.showWhenUnlinked = true,
    this.offset = Offset.zero,
    this.onTap,
    this.onLongPressEnd,
    required this.target,
    required this.followerBuilder,
    this.entries,
  });

  final Alignment targetAnchor;
  final Alignment followerAnchor;

  final bool showWhenUnlinked;

  final Offset offset;

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

  late OverlayEntry _overlayEntry;
  bool show = false;
  Offset indicatorOffset = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    if (widget.followerBuilder == null) {
      return widget.target;
    }

    return GestureDetector(
      onTap: widget.onTap,
      // onTap: _toggleOverlay,
      // onPanStart: (e) => _showOverlay(),
      // onPanEnd: (e) => _hideOverlay(),
      // onPanUpdate: updateIndicator,
      onLongPressStart: (e) => _showOverlay(),
      onLongPressEnd: widget.onLongPressEnd ?? (e) => _hideOverlay(),
      onLongPressMoveUpdate: updateIndicatorLongPress,
      child: CompositedTransformTarget(
        link: layerLink,
        child: widget.target,
      ),
    );
  }

  void _toggleOverlay() {
    if (!show) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
    show = !show;
  }

  void _showOverlay() {
    // if (_entries.isNotEmpty) {
    //   return;
    // }
    _hideOverlay();

    _overlayEntry = _createOverlayEntry(indicatorOffset);
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
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry(Offset localPosition) {
    indicatorOffset = localPosition;
    return OverlayEntry(
      builder: (BuildContext context) => UnconstrainedBox(
        child: CompositedTransformFollower(
          link: layerLink,
          targetAnchor: widget.targetAnchor,
          followerAnchor: widget.followerAnchor,
          offset: widget.offset,
          showWhenUnlinked: widget.showWhenUnlinked,
          child: widget.followerBuilder?.call(context, _hideOverlay),
        ),
      ),
    );
  }
}
