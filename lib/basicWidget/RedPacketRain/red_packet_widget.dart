import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/RedPacketRain/red_packet_model.dart';

class RedPacketWidget extends StatefulWidget {
  const RedPacketWidget({
    super.key,
    required this.model,
    required this.screenSize,
    required this.onFinish,
    this.onTap,
  });

  final RedPacketModel model;
  final Size screenSize;
  final VoidCallback onFinish;
  final VoidCallback? onTap;

  @override
  State<RedPacketWidget> createState() => _RedPacketWidgetState();
}

class _RedPacketWidgetState extends State<RedPacketWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.model.duration,
      vsync: this,
    )..forward();

    _controller.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        widget.onFinish();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.screenSize.width;
    final height = widget.screenSize.height;

    final startY = widget.model.startY;
    final endY = widget.screenSize.height + widget.model.size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(
            width * widget.model.x,
            // height * _controller.value,
            lerpDouble(startY, endY, _controller.value)!,
          ),
          child: child,
        );
      },
      child: RepaintBoundary(
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.blue),
            // ),
            child: Image(
              image: AssetImage('assets/images/icon_lucky_bag.png'),
              width: widget.model.size,
              height: widget.model.size,
            ),
            // child: Icon(
            //   Icons.card_giftcard,
            //   size: widget.model.size,
            //   color: Colors.red,
            // ),
          ),
        ),
      ),
    );
  }
}
