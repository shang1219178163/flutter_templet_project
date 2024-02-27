
import 'package:flutter/material.dart';

/// 顶部弹窗
class TopDrawer extends StatefulWidget {

  TopDrawer({
    super.key,
    this.builder,
  });

  final Widget Function(VoidCallback onHide)? builder;

  @override
  State<TopDrawer> createState() => _TopDrawerState();
}

class _TopDrawerState extends State<TopDrawer> with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();

  late final controller = AnimationController(vsync: this, duration: Duration(milliseconds: 350));
  late final Animation<Offset> slideAnimation = Tween<Offset>(begin: Offset(0.0, -4.0), end: Offset.zero)
      .animate(CurvedAnimation(parent: controller, curve: Curves.decelerate));

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    controller.removeListener(onListener);
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.addListener(onListener);
    controller.forward();
    super.initState();
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
    return SlideTransition(
      position: slideAnimation,
      child: widget.builder?.call(onHide) ?? Scaffold(
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
      ),
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