

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class NExpansionCrossFade extends StatefulWidget {

  NExpansionCrossFade({
    super.key,
    this.isExpanded = false,
    required this.childBuilder,
    required this.expandedChildBuilder,
  });

  /// 是否展开,默认false
  final bool isExpanded;

  final Widget Function(bool isExpanded, VoidCallback onToggle)? childBuilder;

  final Widget Function(bool isExpanded, VoidCallback onToggle)? expandedChildBuilder;

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
      secondChild: widget.expandedChildBuilder?.call(isExpanded, onToggle) ?? InkWell(
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