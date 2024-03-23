import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:flutter_templet_project/basicWidget/n_section_header.dart';
import 'package:flutter_templet_project/extension/scroll_controller_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/R.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

/// 自定义 ScrollBar
class CustomScrollBarDemo extends StatefulWidget {

  const CustomScrollBarDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _CustomScrollBarDemoState createState() => _CustomScrollBarDemoState();
}

class _CustomScrollBarDemoState extends State<CustomScrollBarDemo> {
  final _scrollController = ScrollController();
  ///标准轮播页码监听
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  ///滚动条监听
  ValueNotifier<double> scrollerOffset = ValueNotifier(0.0);
  ///滚动中监听
  ValueNotifier<bool> isScrolling = ValueNotifier(false);

  final items = R.image.urls;

  double screenWidth = 0;

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

  bool isCustomScrollView = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      // scrollerOffset.value = _scrollController.offset;
      // print("scrollerOffset.value:${scrollerOffset.value}");
      var position = _scrollController.position;
      //滚动进度
      var progress = position.pixels/position.maxScrollExtent;
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
        actions: ['done',].map((e) => TextButton(
          onPressed: () {
            isCustomScrollView = !isCustomScrollView;
            setState(() {});
          },
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: _buildBody(isCustomScrollView: isCustomScrollView),
    );
  }

  _buildBody({isCustomScrollView = false}) {
    final child = ListView(
      children: [
        NSectionHeader(
          title: "${isCustomScrollView ? "CustomScrollView" : "ListView"}(自定义滚动条/ScrollerBar)",
          child: Container(
            height: 100,
            padding: padding,
            child: _buildListView(),
          ),
        )
      ]
    );
    if (isCustomScrollView) {
      return child.toCustomScrollView();
    }
    return child;
  }

  _buildListView({
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
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(0),
                  itemCount: items.length,
                  // cacheExtent: 10,
                  itemBuilder: itemBuilder ?? (context, index) => _buildItem(context, index, itemWidth),
                  separatorBuilder: (context, index) => _buildSeparator(context, index),
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
                    child: _scrollerBar(
                      maxWidth: constraints.maxWidth,
                    ),
                  );
                }
              ),
            ),
          ],
        );
      },
    );
  }

  ///创建子项
  _buildItem(context, index, double itemWidth,) {
    final url = items[index];
    return InkWell(
      onTap: (){
        var offset = (itemWidth + gap)*index;
        _scrollController.position.printInfo();
        var position = _scrollController.position;
        debugPrint("${index}_${itemWidth}_${offset}_");

        if (index > (items.length - showCount.ceil())) {
          debugPrint("$index");
          offset = position.maxScrollExtent;
        }
        _scrollController.animateTo(offset,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear
        );
      },
      child: Container(
        // color: Colors.green,
        width: itemWidth,
        decoration: _buildDecoration(),
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
                top: 1.w,
                bottom: 1.w,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  child: Image.asset('icon_play.png'.toPath(),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //分割区间
  _buildSeparator(context, index) {
    return Divider(
      indent: gap,
      // color: Colors.blue,
    );
  }

  _buildDecoration() {
    return BoxDecoration(
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
    );
  }


  /// 水平滚动条
  Widget _scrollerBar({
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
              )
            );
          }
        ),
      ],
    );
  }

}



