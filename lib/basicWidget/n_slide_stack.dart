import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NSlideStack extends StatefulWidget {
  const NSlideStack({
    super.key,
    this.fromRight = true,
    this.drawerWidth = 200,
    required this.drawerBuilder,
    required this.childBuilder,
  });

  final bool fromRight;
  final double drawerWidth;
  final Widget Function(VoidCallback onToggle) drawerBuilder;

  final Widget Function(VoidCallback onToggle) childBuilder;

  @override
  State<NSlideStack> createState() => _NSlideStackState();
}

class _NSlideStackState extends State<NSlideStack> {
  late final rightVN = ValueNotifier(-widget.drawerWidth);

  @override
  void initState() {
    super.initState();
  }

  void onToggle() {
    rightVN.value = rightVN.value == 0 ? -widget.drawerWidth : 0;
  }

  @override
  void didUpdateWidget(covariant NSlideStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.drawerWidth != widget.drawerWidth ||
        oldWidget.drawerBuilder != widget.drawerBuilder ||
        oldWidget.fromRight != widget.fromRight ||
        oldWidget.childBuilder != widget.childBuilder) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: rightVN,
      child: widget.childBuilder(onToggle),
      builder: (context, value, child) {
        return Stack(
          children: [
            child ?? SizedBox(),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              right: widget.fromRight ? value : null,
              left: !widget.fromRight ? value : null,
              top: 0,
              bottom: 0,
              child: SizedBox(
                width: widget.drawerWidth,
                child: widget.drawerBuilder(onToggle),
              ),
            ),
          ],
        );
      },
    );
  }
}
