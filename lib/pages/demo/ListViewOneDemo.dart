import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/extension/scroll_controller_ext.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';

import 'package:tuple/tuple.dart';

typedef onKeyCallback = void Function(BuildContext context, int index, GlobalKey key);

class ListViewOneDemo extends StatefulWidget {

  ListViewOneDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ListViewOneDemoState createState() => _ListViewOneDemoState();
}

class _ListViewOneDemoState extends State<ListViewOneDemo> {
  final _scrollController = ScrollController();
  final _globalKey = GlobalKey();

  final offset = ValueNotifier(0.0);

  Timer? _timer;

  var items = [
    Tuple4(
      'https://avatar.csdn.net/8/9/A/3_chenlove1.jpg',
      '海尔｜无边界厨房',
      '跳转url',
      true,
    ),
    Tuple4(
      'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
      '海尔｜无边界客厅'*6,
      '跳转url',
      false,
    ),
    Tuple4(
      'https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg',
      '海尔｜无边界厨房',
      '跳转url',
      false,
    ),
    Tuple4(
      'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
      '海尔｜无边界客厅'*6,
      '跳转url',
      false,
    ),
    Tuple4(
      'https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg',
      '海尔｜无边界厨房',
      '跳转url',
      false,
    ),
  ];

  get itemWidgets => items.map((e) => Text(e.item2)).toList();

  get itemCount => itemWidgets.length + (itemWidgets.length - 1) + 2;

  @override
  void initState() {
    // _scrollController.addListener(() {
    //   offset.value = _scrollController.offset;
    //   print("offset:${offset.value}");
    //   if(_scrollController.position.atEdge){
    //     print("atEdge:到边界了");
    //   }
    // });
    _initTimer();
    super.initState();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          TextButton(
            onPressed: () {
              print(_scrollController);
              // _scrollController.jumpTo(200);
            },
              child: Text('done', style: TextStyle(color: Colors.white),)
          ),
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.all_inclusive),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildListView(
            height: 100,
            key: _globalKey,
            controller: _scrollController,
              scrollDirection: Axis.horizontal,
              onKeyCallback: (context, index, itemKey) {
              _scrollController.JumToHorizontal(
                key: itemKey,
                offsetX: (MediaQuery.of(context).size.width / 2)
              );
            }
          ),
          Container(
            height: 30,
            padding: EdgeInsets.symmetric(horizontal:16),
            child: MarqueeWidget(
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index, BoxConstraints constraints) {
                // print("MarqueeWidget: $index ${index % 2 == 0}");
                final isEdge = (index == 0 || index == itemCount - 1);
                if (isEdge) {
                  return Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      // color: Colors.yellow,
                      // border: Border.all(color: Colors.red),
                    ),
                    child: Text("$index"),
                  );
                }

                if (index % 2 == 0) {
                  return Container(
                    width: 100,
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      border: Border.all(color: Colors.red),
                    ),
                    child: Text("$index"),
                  );
                }
                double indexNew = (index - 1) / 2;
                print("MarqueeWidget indexNew: $index $indexNew");
                final e = Text("${index}_${indexNew}_中国人口近61年来首次负增长");
                return Container(
                  color: Colors.green,
                  child: e,
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  _buildListView({
    required GlobalKey key,
    required ScrollController? controller,
    required onKeyCallback onKeyCallback,
    Axis scrollDirection = Axis.vertical,
    bool addToSliverBox = false,
    IndexedWidgetBuilder? itemBuilder,
    required double height,
    double gap = 8,
  }) {
    final child = Container(
      height: height,
      padding: EdgeInsets.all(8),
      child: ListView.separated(
        key: key,
        controller: controller,
        scrollDirection: scrollDirection,
        padding: EdgeInsets.all(0),
        itemCount: items.length,
        // cacheExtent: 10,
        itemBuilder: itemBuilder != null ? itemBuilder : (context, index) {
          final e = items[index];

          final width = this.context.screenSize.width;

          GlobalKey itemKey = GlobalKey(debugLabel: e.item1);
          return InkWell(
            key: itemKey,
            onTap: () {
              onKeyCallback(context, index, itemKey);
            },
            child: Container(
              color: Colors.green,
              width: index != 1 ? width: null,
              child: index == 1 ? Text(e.item2) : e.item1.startsWith('http') ? FadeInImage(
                  placeholder: AssetImage('images/img_placeholder.png') ,
                  image: NetworkImage(e.item1),
                  fit: BoxFit.cover,
                  height: 60,
              ) : Container(
                height: 60,
                child: Text('Index:${e.item1}')
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
              indent: gap,
              // color: Colors.blue,
            )
      ),
    );

    if (addToSliverBox) {
      return SliverToBoxAdapter(
        child: child,
      );
    }
    return child;
  }

  _cancelTimer({bool isContinue = false}) {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
      if (isContinue){
        _initTimer();
      }
    }
  }

  /// 初始化定时任务
  _initTimer() {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(milliseconds: 350), (t) {
        final val = _scrollController.offset + 30;
        _scrollController.animateTo(val, duration: Duration(milliseconds: 350), curve: Curves.linear);
        if(_scrollController.position.outOfRange){
          print("atEdge:到边界了");
          _scrollController.jumpTo(0);
        }
      });
    }
  }
}

/// 跑马灯 Builder 类型
typedef MarqueeWidgetBuilder = Widget Function(BuildContext context, int index, BoxConstraints constraints);

class MarqueeSimpleWidget extends StatelessWidget {

  MarqueeSimpleWidget({
  	Key? key,
  	this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.edgeBuilder,
    this.gapBuilder,
  }) : super(key: key);

  final String? title;

  final int itemCount;

  /// 内容 builder
  MarqueeWidgetBuilder itemBuilder;
  /// 边界 builder
  MarqueeWidgetBuilder? edgeBuilder;
  /// 间距 builder
  MarqueeWidgetBuilder? gapBuilder;

  @override
  Widget build(BuildContext context) {
    final totalCount = itemCount + (itemCount - 1) + 2;

    return MarqueeWidget(
      itemCount: totalCount,
      itemBuilder: (BuildContext context, int index, BoxConstraints constraints) {
        print("MarqueeWidget: $index ${index % 2 == 0}");
        final isEdge = (index == 0 || index == totalCount - 1);
        if (isEdge) {
          return edgeBuilder != null ? edgeBuilder!(context, index, constraints) : Container(
            width: constraints.maxWidth,
            // width: 100,
            decoration: BoxDecoration(
              // color: Colors.yellow,
              // border: Border.all(color: Colors.red),
            ),
            // child: Text("$index"),
          );
        }

        if (index % 2 == 0) {
          return gapBuilder != null ? gapBuilder!(context, index, constraints) : Container(
            width: 100,
            decoration: BoxDecoration(
              // color: Colors.blue,
              // border: Border.all(color: Colors.red),
            ),
            // child: Text("$index"),
          );
        }

        // double indexNew = ((index - 1) / 2);
        int indexNew = (index - 1) ~/ 2;
        print("MarqueeWidget indexNew: $index $indexNew");
        final e = Text("真实索引:${index}_item索引:${indexNew}_AAAAAAAAAAAAAAAAAAAAA");
        return itemBuilder(context, indexNew, constraints);
        return  Container(
          color: Colors.green,
          child: e,
        );
      },
    );
  }
}


/// 跑马灯
class MarqueeWidget extends StatefulWidget {

  MarqueeWidget({
    Key? key,
    this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.itemSpacing = 1,
  }) : super(key: key);

  final String? title;

  int itemCount;

  double itemSpacing;

  MarqueeWidgetBuilder itemBuilder;

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  final _scrollController = ScrollController();
  final _globalKey = GlobalKey();

  final offset = ValueNotifier(0.0);

  Timer? _timer;

  @override
  void initState() {
    _initTimer();
    super.initState();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0) {
      return Container();
    }

    return _buildListView(
      key: _globalKey,
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      gap: widget.itemSpacing,
    );
  }


  _buildListView({
    required GlobalKey key,
    required ScrollController? controller,
    Axis scrollDirection = Axis.vertical,
    bool addToSliverBox = false,
    IndexedWidgetBuilder? itemBuilder,
    double gap = 1,
  }) {
    final child = LayoutBuilder(
      builder: (context, constraints) {
        return ListView.separated(
          key: key,
          controller: controller,
          scrollDirection: scrollDirection,
          padding: EdgeInsets.all(0),
          itemCount: widget.itemCount,
          // cacheExtent: 10,
          itemBuilder: itemBuilder != null ? itemBuilder : (context, index) {
            // final isEdge = (index == 0 || index == widget.itemCount - 1);
            return widget.itemBuilder(context, index, constraints);
          },
          separatorBuilder: (context, index) => Divider(
            indent: gap,
            // color: Colors.blue,
          )
        );
      }
    );

    if (addToSliverBox) {
      return SliverToBoxAdapter(
        child: child,
      );
    }
    return child;
  }

  _cancelTimer({bool isContinue = false}) {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
      if (isContinue){
        _initTimer();
      }
    }
  }

  /// 初始化定时任务
  _initTimer() {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(milliseconds: 350), (t) {
        final val = _scrollController.offset + 30;
        _scrollController.animateTo(val, duration: Duration(milliseconds: 350), curve: Curves.linear);
        if(_scrollController.position.outOfRange){
          print("atEdge:到边界了");
          _scrollController.jumpTo(0);
        }
      });
    }
  }
}

