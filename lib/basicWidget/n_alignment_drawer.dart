//
//  NAlignmentDrawer.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/4 23:27.
//  Copyright © 2024/3/4 shang. All rights reserved.
//



import 'package:flutter/material.dart';

/// 弹窗/抽屉/页面展示
class NAlignmentDrawer extends StatefulWidget {

  NAlignmentDrawer({
    super.key,
    this.duration = const Duration(milliseconds: 350),
    this.alignment = Alignment.topCenter,
    this.barrierColor,
    this.onBarrier,
    this.hasFade = true,
    this.builder,
  });

  /// 动画时间
  final Duration duration;
  /// 目标位置
  final Alignment alignment;

  final Color? barrierColor;
  final VoidCallback? onBarrier;

  /// 是否有 fade 动画
  final bool hasFade;

  final Widget Function(VoidCallback onHide)? builder;

  @override
  State<NAlignmentDrawer> createState() => _NAlignmentDrawerState();
}

class _NAlignmentDrawerState extends State<NAlignmentDrawer> with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();

  Tween<Offset> get tween {
    // debugPrint("widget.alignment:${widget.alignment} ${widget.alignment.y}");
    if ([-1, 1].contains(widget.alignment.y)) {
      return Tween<Offset>(
        begin: Offset(0, widget.alignment.y),
        end: const Offset(0, 0),
      );
    }

    if ([-1, 1].contains(widget.alignment.x)) {
      return Tween<Offset>(
        begin: Offset(widget.alignment.x, 0),
        end: const Offset(0, 0),
      );
    }

    return Tween<Offset>(
      begin: Offset(0, 0),
      end: const Offset(0, 0),
    );
  }

  late final controller = AnimationController(duration: widget.duration, vsync: this, );

  late final Animation<Offset> offsetAnimation = tween.animate(CurvedAnimation(
      parent: controller,
      curve: Curves.decelerate,
  ));

  late final Animation<double> fadeAnimation = CurvedAnimation(
    parent: controller,
    curve: Curves.easeIn,
  );


  @override
  void dispose() {
    _scrollController.dispose();
    controller.removeListener(onListener);
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(onListener);
    controller.forward();
  }

  void onListener(){
    setState(() {});
  }

  Future<void> onHide() async {
    await controller.reverse();
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    final defaultWidget = Scaffold(
      appBar: AppBar(
          title: Text("$widget"),
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: onHide,
              child: Text('取消',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ]
      ),
      body: buildBody(),
    );

    Widget child = widget.builder?.call(onHide) ?? defaultWidget;

    if (widget.hasFade) {
      child = FadeTransition(
        opacity: fadeAnimation,
        child: child,
      );
    }

    child = SlideTransition(
      position: offsetAnimation,
      child: child,
    );

    return InkWell(
      onTap: widget.onBarrier ?? onHide,
      child: Container(
        alignment: widget.alignment,
        color: widget.barrierColor ?? Theme.of(context).bottomSheetTheme.modalBarrierColor,
        child: child,
      )
    );
  }

  buildBody() {
    final indexs = List.generate(20, (index) => index);
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: indexs.map((e) {

            return ListTile(
              title: Text("选项$e"),
            );
          },).toList(),
        ),
      ),
    );
  }
  
}