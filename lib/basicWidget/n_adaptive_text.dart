import 'package:flutter/material.dart';

/// 自适应文本组件
class NAdaptiveText extends StatelessWidget {
  const NAdaptiveText({
    Key? key,
    this.data = "自适应文本组件",
    this.child,
    this.alignment = Alignment.center,
    this.margin = const EdgeInsets.symmetric(horizontal: 30),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.decoration,
  }) : super(key: key);

  final String data;

  final Widget? child;

  final Alignment alignment;

  final EdgeInsets margin;
  final EdgeInsets padding;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: decoration ??
            BoxDecoration(
              color: Colors.black.withOpacity(.65),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
        child: child ??
            Text(
              data,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal,
              ),
            ),
      ),
    );
  }
}
