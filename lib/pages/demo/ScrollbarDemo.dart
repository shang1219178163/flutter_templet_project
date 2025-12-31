import 'package:flutter/material.dart';

class ScrollbarDemo extends StatefulWidget {
  const ScrollbarDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ScrollbarDemoState createState() => _ScrollbarDemoState();
}

class _ScrollbarDemoState extends State<ScrollbarDemo> {
  final scrollControllerHeader = ScrollController();

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
    return Column(
      children: [
        Text("ListView 横向滚动需要 嵌套 MediaQuery.removePadding(ontext: context, removeBottom: true,"),
        buildHeader(),
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
  }

  Widget buildHeader() {
    return Container(
      height: 120,
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: Scrollbar(
          controller: scrollControllerHeader,
          thumbVisibility: true,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          child: ListView.separated(
            controller: scrollControllerHeader,
            scrollDirection: Axis.horizontal,
            itemCount: 20,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            padding: const EdgeInsets.only(bottom: 4),
            itemBuilder: (_, i) => Container(
              width: 150,
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Text("index_$i"),
            ),
          ),
        ),
      ),
    );
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
