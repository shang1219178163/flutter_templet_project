import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/list_subtitle_cell.dart';
import 'package:flutter_templet_project/basicWidget/scroll/scroll_physics/no_top_over_scroll_physics.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/model/mock_data.dart';
import 'package:tuple/tuple.dart';

typedef KeyCallback = void Function(BuildContext context, int index, GlobalKey key);

class ListViewDemo extends StatefulWidget {
  final String? title;

  const ListViewDemo({Key? key, this.title}) : super(key: key);

  @override
  _ListViewDemoState createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  var initialIndex = 0;

  late var tabItems = <Tuple2<Tab, Widget>>[
    Tuple2(
      Tab(text: "默认"),
      buildBody(),
    ),
    Tuple2(
      Tab(text: "one"),
      buildListViewSeparated(),
    ),
  ];

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
    Tuple4('https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg', '海尔｜无边界其他', '跳转url', false),
    ...List.generate(19, (index) => Tuple4('item_$index${'z' * index}', '海尔｜无边界其他', '跳转url', false)),
  ];

  final offsetY = ValueNotifier(0.0);

  final options = <Map<String, dynamic>>[
    {"lable": "禁止顶部滚动", "value": false},
  ];

  @override
  void initState() {
    _scrollController2.addListener(() {
      offsetY.value = _scrollController2.position.pixels;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: tabItems.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            IconButton(
              onPressed: () {
                height = height == 100 ? 200 : 100;
                setState(() {});
              },
              icon: Icon(Icons.all_inclusive),
            ),
          ],
          bottom: TabBar(
            tabs: tabItems.map((e) => e.item1).toList(),
          ),
        ),
        body: TabBarView(
          children: tabItems.map((e) => e.item2).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint("${_scrollController2.position.printInfo()}");
          },
          child: ValueListenableBuilder<double>(
            valueListenable: offsetY,
            builder: (context, value, child) {
              return Container(
                child: Text(value.toStringAsFixed(1)),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        buildListView(
          height: 100,
          key: _globalKey,
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          onKeyCallback: (context, index, itemKey) {
            _scrollController.jumToHorizontal(key: itemKey, offsetX: (MediaQuery.of(context).size.width / 2));
          },
        ),
        Expanded(
          child: buildListView(
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

                _scrollController2.position.printInfo();
              }),
        ),
      ],
    );
  }

  Widget buildExpandMenu() {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 10),
        leading: Icon(
          Icons.ac_unit,
          // color: selectedColor.value,
        ),
        title: Text(
          '配置',
          // style: TextStyle(color: selectedColor.value),
        ),
        initiallyExpanded: false,
        children: <Widget>[
          Column(
            children: options.map((e) {
              final lable = e["lable"] ?? "";
              final value = e["value"] ?? false;

              return ListTile(
                title: Text(lable),
                trailing: Switch(
                  onChanged: (bool value) {
                    e["value"] = value;
                    setState(() {});
                  },
                  value: value,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildListView({
    required GlobalKey key,
    required ScrollController? controller,
    required KeyCallback onKeyCallback,
    Axis scrollDirection = Axis.vertical,
    required double height,
    double gap = 8,
  }) {
    controller ??= ScrollController();
    return Container(
      height: height,
      padding: EdgeInsets.all(8),
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: Scrollbar(
          controller: controller,
          thumbVisibility: true,
          // scrollbarOrientation: ScrollbarOrientation.left,
          child: ListView.separated(
            key: key,
            // reverse: true,
            controller: controller,
            scrollDirection: scrollDirection,
            physics: NoTopOverScrollPhysics(),
            padding: EdgeInsets.all(0),
            itemCount: items.length,
            // cacheExtent: 10,
            itemBuilder: (context, index) {
              final e = items[index];

              final itemKey = GlobalKey(debugLabel: e.item1);
              return InkWell(
                key: itemKey,
                onTap: () {
                  onKeyCallback(context, index, itemKey);
                },
                child: Container(
                  color: Colors.green,
                  child: e.item1.startsWith('http')
                      ? FadeInImage(
                          placeholder: 'img_placeholder.png'.toAssetImage(),
                          image: NetworkImage(e.item1),
                          fit: BoxFit.cover,
                          height: 60,
                        )
                      : Container(height: 60, child: Text('Index:${e.item1}')),
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(indent: gap),
          ),
        ),
      ),
    );
  }

  Widget buildListViewSeparated({
    IndexedWidgetBuilder? itemBuilder,
    EdgeInsets padding = const EdgeInsets.all(0),
    double gap = 8,
  }) {
    return ListView.builder(
      itemCount: 20,
      // 使用 itemExtentBuilder 为每个下标指定不同的高度
      itemExtentBuilder: (int index, dimensions) {
        // 在这里，你可以根据下标和 dimensions 的信息来返回不同的值
        final itemHeight = index.isEven ? 60.0 : 100.0;
        return itemHeight;
      },
      itemBuilder: (context, index) {
        return Container(
          color: index.isEven ? Colors.blue[200] : Colors.green[200],
          alignment: Alignment.center,
          child: Text(
            '列表项 $index',
            style: const TextStyle(fontSize: 20),
          ),
        );
      },
    );
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
            onTap: () => debugPrint(e),
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
            ));
  }
}
