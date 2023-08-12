

import 'package:flutter/material.dart';

class ToastWidget extends StatefulWidget {
  ToastWidget({
    Key? key,
    required this.text,
    this.alignment = Alignment.center,
    this.margin = const EdgeInsets.only(left: 16, right: 16, top: 56, bottom: 56,),
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12,),
    this.builder,
    this.duration = const Duration(milliseconds: 2000),
    this.transitionDuration = const Duration(milliseconds: 250),
  }) : super(key: key);

  final String text;
  final Alignment alignment;
  final EdgeInsets margin;
  final EdgeInsets padding;

  final StatefulWidgetBuilder? builder;

  final Duration duration;
  final Duration transitionDuration;

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget> with SingleTickerProviderStateMixin {
  late final opacityAnim = AnimationController(
    vsync: this,
    duration: widget.transitionDuration,
  );

  @override
  void initState() {
    super.initState();
    opacityAnim.forward();

    // final startFadeOutAt = widget.duration - widget.transitionDuration;
    // print('startFadeOutAt: $startFadeOutAt');
    // Future.delayed(startFadeOutAt, opacity.reverse);
  }

  @override
  void dispose() {
    opacityAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnim,
      child: Align(
        alignment: widget.alignment,
        child: widget.builder?.call(context, setState) ?? _buildDefaultContainer(widget.text,
            margin: widget.margin,
            padding: widget.padding
        ),
      ),
    );
  }

  //默认样式
  _buildDefaultContainer(String text, {
    EdgeInsets margin = const EdgeInsets.all(16),
    EdgeInsets padding = const EdgeInsets.all(12)
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.65),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: margin,
      padding: padding,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

