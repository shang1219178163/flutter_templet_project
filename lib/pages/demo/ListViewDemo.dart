import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/extension/scrollController_extension.dart';
import 'package:tuple/tuple.dart';

class ListViewDemo extends StatefulWidget {

  final String? title;

  ListViewDemo({ Key? key, this.title}) : super(key: key);


  @override
  _ListViewDemoState createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  final _scrollController = ScrollController();
  final _scrollController1 = ScrollController();

  final _globalKey2 = GlobalKey();
  final _scrollController2 = ScrollController();

  double height = 100;
  bool flag = true;

  var items = [
    Tuple4(
      'https://avatar.csdn.net/8/9/A/3_chenlove1.jpg',
      '海尔｜无边界厨房',
      '跳转url',
      true,
    ),
    Tuple4(
      'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
      '海尔｜无边界客厅',
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
      'https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg',
      '海尔｜无边界其他',
       '跳转url',
       false
    ),
    ...List.generate(19, (index) => Tuple4(
        'item_$index' + 'z'*index,
        '海尔｜无边界其他',
        '跳转url',
        false
    )),
  ];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          TextButton(
            onPressed: () {
              test();
              print(_scrollController);
              // _scrollController.jumpTo(200);
            },
              child: Text('done', style: TextStyle(color: Colors.white),)
          ),
          IconButton(
            onPressed: () {
              height = height == 100 ? 200 : 100;
              setState(() {});
            },
            icon: Icon(Icons.all_inclusive),
          ),
        ],
      ),
      // body: _buildSection(),
      // body: _buildListViewSeparated(),
      body: Column(
        children: [
          // _buildListViewSeparated(),
          // _buildSection(),
          _buildListViewSeparatedNew(),
        ],
      ),
    );
  }

  _buildSection() {
    // final items = List.generate(3, (index) => "${index}");

    return Container(
      height: 200,
      child: ListView(
        // controller: _scrollController1,
        children: List.generate(9, (index) => Column(
          children: [
            ListTile(
              leading: Text('Index: $index'),
            ),
            Divider(),
          ],
        )
        ),
        itemExtent: 75,
      ),
    );
  }

  _buildListViewSeparated({
    bool addToSliverBox = false,
    IndexedWidgetBuilder? itemBuilder,
    EdgeInsets padding = const EdgeInsets.all(0),
    double gap = 8,
  }) {

    final child = Container(
      height: height,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(0),
        itemCount: items.length,
        // cacheExtent: 10,
        itemBuilder: itemBuilder != null ? itemBuilder : (context, index) {
          final e = items[index];

          final tabKey = GlobalKey(debugLabel: e.item1);
          return InkWell(
            key: tabKey,
            onTap: () {
              print(e);
              _scrollController.JumToHorizontal(
                  key: tabKey,
                  offsetX: (MediaQuery.of(context).size.width / 2)
              );
            },
            child: Padding(
              padding: padding,
              child: Container(
                color: Colors.green,
                // width: 200,
                child: e.item1.startsWith('http') ? FadeInImage(
                    placeholder: AssetImage('images/img_placeholder.png') ,
                    image: NetworkImage(e.item1),
                    fit: BoxFit.cover,
                    height: double.infinity
                ) : Center(child: Text('Index:${e.item1}')),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          // return Container(
          //   width: gap,
          //   color: Colors.blue,
          // );
          return Divider(
            // height: 8,
            indent: gap,
            // color: Colors.blue,
          );
        },
      ),
    );


    if (addToSliverBox) {
      return SliverToBoxAdapter(
        child: child,
      );
    }
    return child;
  }

  _buildListViewSeparatedNew({
    bool addToSliverBox = false,
    IndexedWidgetBuilder? itemBuilder,
    EdgeInsets padding = const EdgeInsets.all(0),
    double gap = 8,
  }) {
    // final items = List.generate(20, (index) => "${index}");

    final child = Container(
      height: 600,
      child: ListView.separated(
        key: _globalKey2,
        controller: _scrollController2,
        // scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(0),
        itemCount: items.length,
        // cacheExtent: 10,
        itemBuilder: itemBuilder != null ? itemBuilder : (context, index) {
          final e = items[index];

          final tabKey = GlobalKey(debugLabel: e.item1);
          return InkWell(
            key: tabKey,
            onTap: () {
              print(e);
              _scrollController2.scrollToItem(
                  itemKey: tabKey,
                  scrollKey: _globalKey2,
              );

              _scrollController2.printInfo();
            },
            child: Padding(
              padding: padding,
              child: Container(
                color: Colors.green,
                // width: 200,
                child: e.item1.startsWith('http') ? FadeInImage(
                    placeholder: AssetImage('images/img_placeholder.png') ,
                    image: NetworkImage(e.item1),
                    fit: BoxFit.cover,
                    height: 70
                ) : Container(
                    height: 75,
                    child: Center(
                      child: Text('Index:${e.item1}')
                    )
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          // return Container(
          //   width: gap,
          //   color: Colors.blue,
          // );
          return Divider(
            // height: 8,
            indent: gap,
            // color: Colors.blue,
          );
        },
      ),
    );


    if (addToSliverBox) {
      return SliverToBoxAdapter(
        child: child,
      );
    }
    return child;
  }

  test() {
    print("Testing:${[GlobalKey(),GlobalKey(),]}");
  }
}


Map<String, double> itemMap = {
  '1': 327,
  '2': 160,
  '2.5': 125,
  '3': 104,
};

class ScrollWidget extends StatelessWidget {


  const ScrollWidget({
  	Key? key,
  	this.title,
    this.showCount = 1,
  }) : super(key: key);

  final String? title;

  final double showCount;

  /// 获取 item 宽
  double? get itemWidth => itemMap[this.showCount] ?? itemMap['1'];

  @override
  Widget build(BuildContext context) {
    return _buildbody();
  }

  _buildbody() {
    final items = List.generate(3, (index) => "${index}");

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(0),
      itemCount: items.length,
      cacheExtent: 10,
      itemBuilder: (context, index) {
        final e = items[index];
        return InkWell(
          onTap: () => print(e),
          child: Container(
            color: Colors.green,
            width: 200,
            child: Text('Index:${index}'),
          ),
        );
      },
      separatorBuilder: (context, index) {
        // return Container(
        //   width: 8,
        //   color: Colors.blue,
        // );
        return Divider(
          // height: 8,
          indent: 8,
          // endIndent: 15,
          color: Colors.blue,
        );
      },
    );
  }
}


