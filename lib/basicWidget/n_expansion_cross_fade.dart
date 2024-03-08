//
//  NExpansionCrossFade.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/6 20:46.
//  Copyright © 2024/3/6 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 折叠展开菜单
class NExpansionCrossFade extends StatefulWidget {

  NExpansionCrossFade({
    super.key,
    this.isExpanded = false,
    required this.childBuilder,
    required this.expandedBuilder,
  });

  /// 是否展开,默认false
  final bool isExpanded;
  /// 非展开状态
  final Widget Function(bool isExpanded, VoidCallback onToggle)? childBuilder;
  /// 展开状态
  final Widget Function(bool isExpanded, VoidCallback onToggle)? expandedBuilder;

  @override
  State<NExpansionCrossFade> createState() => _NExpansionCrossFadeState();
}

class _NExpansionCrossFadeState extends State<NExpansionCrossFade> {

  late bool isExpanded = widget.isExpanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 350),
      firstChild: widget.childBuilder?.call(isExpanded, onToggle) ?? InkWell(
        onTap: onToggle,
        child: const FlutterLogo(style: FlutterLogoStyle.horizontal, size: 100.0)
      ),
      secondChild: widget.expandedBuilder?.call(isExpanded, onToggle) ?? InkWell(
        onTap: onToggle,
        child: const FlutterLogo(style: FlutterLogoStyle.stacked, size: 100.0)
      ),
      crossFadeState: !isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  onToggle() {
    isExpanded = !isExpanded;
    setState(() { });
  }


}