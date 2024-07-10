//
//  NExpansionCrossFade.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/6 20:46.
//  Copyright © 2024/3/6 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 折叠展开菜单
class NExpansionFade extends StatefulWidget {
  NExpansionFade({
    super.key,
    this.controller,
    this.isExpanded = false,
    required this.childBuilder,
    required this.expandedBuilder,
  });

  final NExpansionFadeController? controller;

  /// 是否展开,默认false
  final bool isExpanded;

  /// 非展开状态
  final Widget Function(bool isExpanded, VoidCallback onToggle)? childBuilder;

  /// 展开状态
  final Widget Function(bool isExpanded, VoidCallback onToggle)?
      expandedBuilder;

  @override
  State<NExpansionFade> createState() => _NExpansionFadeState();
}

class _NExpansionFadeState extends State<NExpansionFade> {
  late bool isExpanded = widget.isExpanded;

  @override
  void dispose() {
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 350),
      firstChild: widget.childBuilder?.call(isExpanded, onToggle) ??
          InkWell(
              onTap: onToggle,
              child: const FlutterLogo(
                  style: FlutterLogoStyle.horizontal, size: 100.0)),
      secondChild: widget.expandedBuilder?.call(isExpanded, onToggle) ??
          InkWell(
              onTap: onToggle,
              child: const FlutterLogo(
                  style: FlutterLogoStyle.stacked, size: 100.0)),
      crossFadeState:
          !isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  onToggle() {
    isExpanded = !isExpanded;
    setState(() {});
  }
}

class NExpansionFadeController {
  _NExpansionFadeState? _anchor;

  bool get isExpanded {
    assert(_anchor != null);
    return _anchor!.isExpanded;
  }

  void onToggle() {
    assert(_anchor != null);
    _anchor?.onToggle();
  }

  void _attach(_NExpansionFadeState anchor) {
    _anchor = anchor;
  }

  void _detach(_NExpansionFadeState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }
}
