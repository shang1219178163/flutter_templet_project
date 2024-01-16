import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/list_subtitle_cell.dart';
import 'package:flutter_templet_project/extension/divider_ext.dart';
import 'package:flutter_templet_project/extension/scroll_controller_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/model/mock_data.dart';
import 'package:tuple/tuple.dart';

typedef KeyCallback = void Function(BuildContext context, int index, GlobalKey key);

class ListViewDemo extends StatefulWidget {

  final String? title;

  const ListViewDemo({ Key? key, this.title}) : super(key: key);


  @override
  _ListViewDemoState createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  final _scrollController = ScrollController();
  final _scrollController1 = ScrollController();

  final _globalKey = GlobalKey();
  final _globalKey2 = GlobalKey();
  final _scrollController2 = ScrollController();

  double height = 100;
  bool flag = true;

  var items = [
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
        'item_$index${'z'*index}',
        '海尔｜无边界其他',
        '跳转url',
        false
    )),
  ];

  final offsetY = ValueNotifier(0.0);

  @override
  void initState() {
    // TODO: implement initState
    _scrollController2.addListener(() {
      offsetY.value = _scrollController2.position.pixels;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          TextButton(
            onPressed: () {
              test();
              debugPrint("$_scrollController");
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
      // body: _buildListViewSeparated(),
      body: Column(
        children: [
          // _buildListViewSeparated(),
          // _buildListViewSeparatedNew(),
          _buildListView(
            height: 100,
            key: _globalKey,
            controller: _scrollController,
              scrollDirection: Axis.horizontal,
              onKeyCallback: (context, index, itemKey) {
              _scrollController.jumToHorizontal(
                key: itemKey,
                offsetX: (MediaQuery.of(context).size.width / 2)
              );
            }
          ),
          Expanded(
            child: _buildListView(
              height: 600,
              key: _globalKey2,
              controller: _scrollController2,
              scrollDirection: Axis.vertical,
              onKeyCallback: (context, index, itemKey) {
                // _scrollController2.scrollToItem(
                //   itemKey: itemKey,
                //   scrollKey: _globalKey2,
                // );

                _scrollController2.scrollToItemNew(
                  itemKey: itemKey,
                  scrollKey: _globalKey2,
                  scrollDirection: Axis.vertical,
                );

                _scrollController2.printInfo();
              }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("${_scrollController2.position.printInfo()}");
          scrollToBottom(controller: _scrollController2);

        },
        child: ValueListenableBuilder<double>(
           valueListenable: offsetY,
           builder: (context,  value, child){

              return Container(
                child: Text("${value.toStringAsFixed(1)}"),
              );
            }
        ),
      ),
    );
  }


  Widget _buildListView({
    required GlobalKey key,
    required ScrollController? controller,
    required KeyCallback onKeyCallback,
    Axis scrollDirection = Axis.vertical,
    IndexedWidgetBuilder? itemBuilder,
    required double height,
    double gap = 8,
  }) {

    return Container(
      height: height,
      padding: EdgeInsets.all(8),
      child: Scrollbar(
        controller: controller,
        thumbVisibility: true,
        child: ListView.separated(
            key: key,
            // reverse: true,
            controller: controller,
            scrollDirection: scrollDirection,
            padding: EdgeInsets.all(0),
            itemCount: items.length,
            // cacheExtent: 10,
            itemBuilder: itemBuilder ?? (context, index) {
              final e = items[index];

              final itemKey = GlobalKey(debugLabel: e.item1);
              return InkWell(
                key: itemKey,
                onTap: () {
                  onKeyCallback(context, index, itemKey);
                },
                child: Container(
                  color: Colors.green,
                  child: e.item1.startsWith('http') ? FadeInImage(
                    placeholder: 'img_placeholder.png'.toAssetImage(),
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
      ),
    );
  }


  _buildListViewSeparated({
    IndexedWidgetBuilder? itemBuilder,
    EdgeInsets padding = const EdgeInsets.all(0),
    double gap = 8,
  }) {
    return Container(
      height: height,
      padding: EdgeInsets.all(8),
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView.separated(
          key: _globalKey,
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(0),
          itemCount: items.length,
          // cacheExtent: 10,
          itemBuilder: itemBuilder ?? (context, index) {
            final e = items[index];

            final itemKey = GlobalKey(debugLabel: e.item1);
            return InkWell(
              key: itemKey,
              onTap: () {
                debugPrint("$e");
                _scrollController.jumToHorizontal(
                    key: itemKey,
                    offsetX: (MediaQuery.of(context).size.width / 2)
                );

                // _scrollController.scrollToItem(
                //   itemKey: itemKey,
                //   scrollKey: _globalKey,
                // );
              },
              child: Container(
                padding: padding,
                color: Colors.green,
                // width: 200,
                child: e.item1.startsWith('http') ? FadeInImage(
                    placeholder: 'img_placeholder.png'.toAssetImage() ,
                    image: NetworkImage(e.item1),
                    fit: BoxFit.cover,
                ) : Center(child: Text('Index:${e.item1}')),
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(
            indent: gap,
            // color: Colors.blue,
          )
        ),
      ),
    );
  }

  _buildListViewSeparatedOne({
    IndexedWidgetBuilder? itemBuilder,
    EdgeInsets padding = const EdgeInsets.all(0),
    double gap = 8,
  }) {
    return Container(
      height: 600,
      padding: EdgeInsets.all(8),
      child: ListView.separated(
        key: _globalKey2,
        controller: _scrollController2,
        // scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(0),
        itemCount: items.length,
        // cacheExtent: 10,
        itemBuilder: itemBuilder ?? (context, index) {
          final e = items[index];

          final itemKey = GlobalKey(debugLabel: e.item1);
          return InkWell(
            key: itemKey,
            onTap: () {
              // _scrollController2.scrollToItem(
              //     itemKey: itemKey,
              //     scrollKey: _globalKey2,
              // );
              _scrollController2.scrollToItemNew(
                scrollDirection: Axis.vertical,
                itemKey: itemKey,
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
                    placeholder: 'img_placeholder.png'.toAssetImage() ,
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
        separatorBuilder: (context, index) => Divider(
          indent: gap,
          // color: Colors.blue,
        )
      ),
    );

  }

  _buildListViewSeparatedTwo({
    IndexedWidgetBuilder? itemBuilder,
    EdgeInsets padding = const EdgeInsets.all(0),
    double gap = 8,
  }) {
    return ListView.separated(
      cacheExtent: 180,
      itemCount: kAliPayList.length,
      itemBuilder: (context, index) {
        final data = kAliPayList[index];
        return ListSubtitleCell(
          padding: EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              data.imageUrl,
              width: 40,
              height: 40,
            ),
          ),
          title: Text(
            data.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          subtitle: Text(data.content,
            // maxLines: 1,
            // overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF999999),
            ),
          ),
          trailing: Text(data.time,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF999999),
            ),
          ),
          subtrailing: Text("已完成",
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );

  }

  scrollToBottom({required ScrollController controller}) {
    Future.delayed(
      const Duration(milliseconds: 100),
          () {
        if (!controller.hasClients) {
          return;
        }
        controller.jumpTo(controller.position.maxScrollExtent);
        // controller.animateTo(
        //   controller.position.maxScrollExtent,
        //   duration: const Duration(milliseconds: 350),
        //   curve: Curves.linear,
        // );
      },
    );
  }

  test() {
    debugPrint("Testing:${[GlobalKey(),GlobalKey(),]}");
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
  double? get itemWidth => itemMap[showCount] ?? itemMap['1'];

  @override
  Widget build(BuildContext context) {
    return _buildbody();
  }

  _buildbody() {
    final items = List.generate(3, (index) => "$index");

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(0),
      itemCount: items.length,
      cacheExtent: 10,
      itemBuilder: (context, index) {
        final e = items[index];
        return InkWell(
          onTap: () => debugPrint("$e"),
          child: Container(
            color: Colors.green,
            width: 200,
            child: Text('Index:$index'),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        indent: 8,
        // color: Colors.blue,
      )
    );
  }
}


