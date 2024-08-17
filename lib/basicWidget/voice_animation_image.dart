// 帧动画Image
import 'package:flutter/material.dart';

class VoiceAnimationImage extends StatefulWidget {
  VoiceAnimationImage({
    Key? key,
    required this.assetList,
    this.width = 100,
    this.height = 100,
    this.isPlaying = false,
    this.interval = 200,
  }) : super(key: key);

  final List<String> assetList;
  final double width;
  final double height;
  int interval = 200;
  bool isPlaying = false;

  @override
  State<StatefulWidget> createState() => VoiceAnimationImageState();
}

class VoiceAnimationImageState extends State<VoiceAnimationImage>
    with SingleTickerProviderStateMixin {
  // 动画控制
  late Animation<double> _animation;
  late AnimationController _controller;
  int interval = 200;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final imageCount = widget.assetList.length;
    final maxTime = interval * imageCount;

    // 启动动画controller
    _controller = AnimationController(
        duration: Duration(milliseconds: maxTime), vsync: this);
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _controller.forward(from: 0.0); // 完成后重新开始
      }
    });

    _animation =
        Tween<double>(begin: 0, end: imageCount.toDouble()).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    if (widget.isPlaying) {
      start();
    } else {
      stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var ix = _animation.value.floor() % widget.assetList.length;
    var images = <Widget>[];
    // 把所有图片都加载进内容，否则每一帧加载时会卡顿
    // for (var i = 0; i < widget.assetList.length; ++i) {
    //   if (i != ix) {
    //     images.add(Image.asset(
    //       widget.assetList[i],
    //       width: 0,
    //       height: 0,
    //     ));
    //   }
    // }
    images.add(Image.asset(
      widget.assetList[ix],
      width: widget.width,
      height: widget.height,
    ));
    return Stack(
      alignment: AlignmentDirectional.center,
      children: images,
    );
  }

  start() {
    _controller.forward();
    debugPrint("$this, start");
  }

  stop() {
    // _controller.stop();
    _controller.reset();
    debugPrint("$this, stop");
  }

  change({ValueChanged<bool>? cb}) {
    cb?.call(_controller.value == _controller.lowerBound);
    if (_controller.value == _controller.lowerBound) {
      start();
    } else {
      stop();
    }
  }
}
