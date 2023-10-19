//
//  NTargetFollower.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/18 14:05.
//  Copyright © 2023/10/18 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/custom_type_util.dart';


class NTargetFollower extends StatefulWidget {

  NTargetFollower({
    Key? key,
    this.targetAnchor = Alignment.topCenter,
    this.followerAnchor = Alignment.bottomCenter,
    this.showWhenUnlinked = true,
    this.offset = Offset.zero,
    this.onTap,
    this.onLongPressEnd,
    required this.target,
    required this.follower,
    this.followerBuilder,
    this.entries = const [],
  }) : super(key: key);


  final Alignment followerAnchor;
  final Alignment targetAnchor;

  final bool showWhenUnlinked;
  final Offset offset;

  final GestureTapCallback? onTap;

  final GestureLongPressEndCallback? onLongPressEnd;

  VoidCallbackWidgetBuilder? followerBuilder;


  final List<OverlayEntry> entries;


  final Widget target;
  final Widget? follower;


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
    if (widget.follower == null) {
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
          child: widget.followerBuilder?.call(context, _hideOverlay) ?? widget.follower,
        ),
      ),
    );
  }
}