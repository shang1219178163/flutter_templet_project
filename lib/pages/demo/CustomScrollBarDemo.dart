import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_scroll_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/extension/scroll_controller_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/util/AppRes.dart';

/// 自定义 ScrollBar
class CustomScrollBarDemo extends StatefulWidget {
  const CustomScrollBarDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _CustomScrollBarDemoState createState() => _CustomScrollBarDemoState();
}

class _CustomScrollBarDemoState extends State<CustomScrollBarDemo> {
  final scrollController = ScrollController();
  final scrollController1 = ScrollController();
  final scrollController2 = ScrollController();

  ///标准轮播页码监听
  final currentIndex = ValueNotifier(0);

  ///滚动条监听
  final scrollerOffset = ValueNotifier(0.0);

  ///滚动中监听
  final isScrolling = ValueNotifier(false);

  final items = AppRes.image.urls;

  double gap = 8;

  EdgeInsets padding = EdgeInsets.only(left: 15, right: 15);

  BorderRadius borderRadius = BorderRadius.all(Radius.circular(8));

  /// 展示个数
  double get showCount {
    var result = 2.5;
    // result = 2; //add test
    return result;
  }

  /// 是否显示滚动条
  bool get showScrollbar {
    final result = (showCount != items.length);
    return result;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    scrollController.addListener(() {
      // scrollerOffset.value = _scrollController.offset;
      // print("scrollerOffset.value:${scrollerOffset.value}");
      var position = scrollController.position;
      //滚动进度
      var progress = position.pixels / position.maxScrollExtent;
      scrollerOffset.value = progress;
      // print("scrollerOffset.value:${scrollerOffset.value}_${progress}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: buildBody(),
            ),
            Container(
              height: 300,
              child: buildBottom(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    final child = ListView(children: [
      NSectionBox(
        title: "${"ListView"}(自定义滚动条/ScrollerBar)",
        child: Container(
          height: 100,
          padding: padding,
          child: buildListView(),
        ),
      )
    ]);
    return child;
  }

  Widget buildListView({
    IndexedWidgetBuilder? itemBuilder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var itemWidth = (constraints.maxWidth - gap * (showCount.ceil() - 1)) / showCount;

        return Stack(
          children: [
            Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification n) {
                  if (n is! UserScrollNotification) {
                    isScrolling.value = n is! ScrollEndNotification;
                  }
                  // print(n.runtimeType);
                  return false; //为 true，则事件会阻止向上冒泡，不推荐(除非有必要)
                },
                child: ListView.separated(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(0),
                  itemCount: items.length,
                  // cacheExtent: 10,
                  itemBuilder: itemBuilder ?? (context, index) => buildItem(context, index, itemWidth),
                  separatorBuilder: (context, index) => Divider(
                    indent: gap,
                    // color: Colors.blue,
                  ),
                ),
              ),
            ),
            if (showScrollbar)
              Positioned(
                bottom: 0,
                child: ValueListenableBuilder(
                    valueListenable: isScrolling,
                    builder: (context, bool value, child) {
                      // print('isScrolling:${isScrolling.value} value: ${value.toString()}');
                      return Offstage(
                        // offstage: !value,
                        offstage: false,
                        child: buildScrollBar(
                          maxWidth: constraints.maxWidth,
                        ),
                      );
                    }),
              ),
          ],
        );
      },
    );
  }

  ///创建子项
  Widget buildItem(
    context,
    index,
    double itemWidth,
  ) {
    final url = items[index];
    return InkWell(
      onTap: () {
        var offset = (itemWidth + gap) * index;
        scrollController.position.printInfo();
        var position = scrollController.position;
        debugPrint("${index}_${itemWidth}_${offset}_");

        if (index > (items.length - showCount.ceil())) {
          debugPrint("$index");
          offset = position.maxScrollExtent;
        }
        scrollController.animateTo(offset, duration: Duration(milliseconds: 300), curve: Curves.linear);
      },
      child: Container(
        // color: Colors.green,
        width: itemWidth,
        decoration: BoxDecoration(
          // color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.5),
              // spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              FadeInImage(
                placeholder: 'img_placeholder.png'.toAssetImage(),
                image: NetworkImage(url),
                fit: BoxFit.fill,
                // height: double.infinity,
              ),
              if (url.endsWith(".mp4"))
                Positioned(
                  top: 1,
                  bottom: 1,
                  child: Container(
                    width: 24,
                    height: 24,
                    child: Image.asset(
                      'icon_play.png'.toPath(),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  /// 水平滚动条
  Widget buildScrollBar({
    required double maxWidth,
    double barHeight = 3.5,
    Color barColor = Colors.red,
  }) {
    if (items.length <= 1) {
      return SizedBox();
    }

    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            height: barHeight,
            width: maxWidth,
            color: Colors.black.withOpacity(0.08),
          ),
        ),
        ValueListenableBuilder<double>(
            valueListenable: scrollerOffset,
            builder: (context, value, child) {
              // print("value:$value");
              var indicatorWidth = 80.0;
              var left = value * (maxWidth - indicatorWidth);
              return Positioned(
                  left: left,
                  child: Container(
                    height: barHeight,
                    width: indicatorWidth,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ));
            }),
      ],
    );
  }

  /// NScrollBar
  Widget buildBottom() {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Row(
        children: [
          Expanded(
            child: NScrollBar(
              controller: scrollController1,
              scrollDirection: Axis.vertical,
              length: 200,
              indicatorLength: 40,
              // thickness: 20,
              indicator: ShapeDecoration(
                shape: const StadiumBorder(),
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListView.builder(
                controller: scrollController1,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('item $index'),
                  );
                },
                itemCount: 30,
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              return NScrollBar(
                controller: scrollController2,
                scrollDirection: Axis.horizontal,
                length: 200,
                indicatorLength: 40,
                // thickness: 20,
                indicator: ShapeDecoration(
                  shape: const StadiumBorder(),
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                // indicatorBg: ShapeDecoration(
                //   shape: const StadiumBorder(),
                //   gradient: LinearGradient(
                //     colors: [Colors.purple, Colors.green],
                //     begin: Alignment.centerLeft,
                //     end: Alignment.centerRight,
                //   ),
                // ),
                child: ListView.builder(
                  controller: scrollController2,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        // border: Border.all(color: Colors.blue),
                      ),
                      child: ListTile(
                        title: Text('item $index'),
                      ),
                    );
                  },
                  itemCount: 30,
                ),
              );
            }),
          ),
        ],
      );
    });
  }
}
