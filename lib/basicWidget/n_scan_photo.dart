//
//  NScanImage.dart
//  flutter_templet_project
//
//  Created by shang on 2024/7/31 11:59.
//  Copyright © 2024/7/31 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';

/// 扫描图片
class NScanPhoto extends StatefulWidget {
  const NScanPhoto({
    super.key,
    required this.image,
    this.tween,
    this.duration = const Duration(milliseconds: 2000),
    required this.onScanning,
    required this.onStop,
  });

  /// 图片
  final File? image;

  /// 动画范围
  final Tween<double>? tween;

  final Duration duration;

  /// 扫描中
  final Future<void> Function() onScanning;

  /// 扫描结束
  final VoidCallback onStop;

  @override
  State<NScanPhoto> createState() => _NScanPhotoState();
}

class _NScanPhotoState extends State<NScanPhoto>
    with SingleTickerProviderStateMixin {
  //扫描动画
  AnimationController? _controller;
  Animation? _animation;

  late final isScaning = ValueNotifier(false);

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _controller = null;
  }

  @override
  void initState() {
    super.initState();
    initAnimate();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.image == null) {
      return SizedBox();
    }

    return Stack(
      children: [
        Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: Image.file(widget.image!),
        ),
        ValueListenableBuilder(
          valueListenable: isScaning,
          builder: (context, value, child) {
            return Opacity(
              opacity: value ? 1 : 0,
              child: AnimatedBuilder(
                animation: _controller!,
                child: Image(
                  image: "icon_ocr_bar.png".toAssetImage(),
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
                builder: (cxt, child) {
                  return Container(
                    height: 53,
                    margin: EdgeInsets.fromLTRB(
                      0,
                      0.0 + _animation!.value,
                      0,
                      0,
                    ),
                    child: child,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  initAnimate() async {
    //创建AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
    );

    //Tween
    //.1创建位移的tween，值必须是double类型
    _animation =
        (widget.tween ?? Tween(begin: 0.0, end: 600)).animate(_controller!);

    //监听动画的状态改变
    _controller?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller?.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller?.forward();
      }
    });

    scanStart();
  }

  Future<void> scanStart() async {
    isScaning.value = true;
    _controller?.forward();
    // setState(() {});
    await onAction();
    scanStop();
    widget.onStop();
  }

  void scanStop() {
    _controller?.stop();
    isScaning.value = false;
  }

  Future<void> onAction() async {
    await widget.onScanning();
  }
}
