

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';

class ScanAnimationDemo extends StatefulWidget {

  ScanAnimationDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  State<ScanAnimationDemo> createState() => _ScanAnimationDemoState();
}

class _ScanAnimationDemoState extends State<ScanAnimationDemo> with SingleTickerProviderStateMixin{

  final _scrollController = ScrollController();

  //扫描动画
  AnimationController? _controller;
  Animation? _animation;

  // late double animateHeight = MediaQuery.of(context).size.height*4/3;
  late double animateHeight = 500;
  late final isScaning = ValueNotifier(false);

  @override
  void initState() {
    // TODO: implement initState
    initAnimate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Text("$widget"),

            ValueListenableBuilder(
               valueListenable: isScaning,
                builder: (context,  value, child){

                  return Opacity(
                    opacity: value ? 1 : 0,
                    child: AnimatedBuilder(
                      animation: _controller!,
                      child: Image(image: "icon_ocr_bar.png".toAssetImage(), fit: BoxFit.fitWidth, width: double.infinity),
                      builder: (cxt, child) {

                        return Container(
                          height: 53,
                          margin: EdgeInsets.fromLTRB(0, 0.0 + _animation!.value, 0, 0),
                          child: child,
                        );
                      },
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }

  initAnimate() async {
    //创建AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      reverseDuration: const Duration(seconds: 3),
    );

    //Tween
    //.1创建位移的tween，值必须是double类型
    _animation = Tween(begin: 0.0, end: animateHeight - 100).animate(_controller!);

    //监听动画的状态改变
    _controller?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller?.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller?.forward();
      }
    });
  }

  void scanStart() {
    isScaning.value = true;
    _controller?.forward();
    setState(() {});
  }

  void scanStop() {
    _controller?.stop();
    isScaning.value = false;
  }
}