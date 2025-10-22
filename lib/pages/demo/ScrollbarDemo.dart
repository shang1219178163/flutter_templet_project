import 'package:flutter/material.dart';

class ScrollbarDemo extends StatefulWidget {
  const ScrollbarDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ScrollbarDemoState createState() => _ScrollbarDemoState();
}

class _ScrollbarDemoState extends State<ScrollbarDemo> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Row(
        children: [
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (notification) {
                //滑动指示器是否在头部 true在前端，false在末端
                debugPrint('notification:${notification.leading}');
                return true;
              },
              child: Scrollbar(
                controller: scrollController,
                radius: Radius.circular(10),
                thickness: 10,
                child: buildListView(
                  controller: scrollController,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildListView({
    required ScrollController controller,
    scrollDirection = Axis.vertical,
  }) {
    return ListView.builder(
      controller: controller,
      scrollDirection: scrollDirection,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('item $index'),
        );
      },
      itemCount: 30,
    );
  }
}
