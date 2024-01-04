

import 'package:flutter/cupertino.dart';


class NExpansionCrossFade extends StatelessWidget {

  const NExpansionCrossFade({
    super.key,
    required this.child,
    required this.expandedChild,
    required this.isExpanded,
  });

  final Widget child;
  final Widget expandedChild;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final curve = const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn);
    return AnimatedCrossFade(
      firstChild: child,
      secondChild: expandedChild,
      firstCurve: curve,
      secondCurve: curve,
      sizeCurve: Curves.decelerate,
      crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }
}