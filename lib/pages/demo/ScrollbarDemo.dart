import 'package:flutter/material.dart';

class ScrollbarDemo extends StatefulWidget {
  const ScrollbarDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ScrollbarDemoState createState() => _ScrollbarDemoState();
}

class _ScrollbarDemoState extends State<ScrollbarDemo> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        //滑动指示器是否在头部 true在前端，false在末端
        debugPrint('notification:${notification.leading}');
        return true;
      },
      child: Scrollbar(
        radius: Radius.circular(10),
        thickness: 10,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('item $index'),
            );
          },
          itemCount: 30,
        ),
      ),
    );
  }
}
