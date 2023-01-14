import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/tab_bar_segment.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/uti/R.dart';

class SegmentTabBarDemo extends StatefulWidget {

  SegmentTabBarDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SegmentTabBarDemoState createState() => _SegmentTabBarDemoState();
}

class _SegmentTabBarDemoState extends State<SegmentTabBarDemo> {

  // /// 初始索引
  // int initialIndex = 1;
  /// 当前索引
  int currentIndex = 0;

  int selectedIndex = 0;

  List<String> titles = List.generate(9, (index) => 'item_$index').toList();

  GlobalKey<TabBarSegmentState> _globalKey = GlobalKey(debugLabel: "CustomeTabBar");
  GlobalKey<TabBarSegmentState> _globalKey1 = GlobalKey();

  ValueNotifier<int> indexVN = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: ['reset',].map((e) => TextButton(
            child: Text(e,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: onDone,
          )).toList(),
          bottom: buildAppBottom(),
        ),
        body: ListView(
          children: [
            Center(
              child: ValueListenableBuilder<int>(
                valueListenable: indexVN,
                builder: (BuildContext context, int value, Widget? child) {
                  return Text('$value');
                },
              ),
            ),
            buildTabBarSegment(),
          ],
        )
    );
  }

  buildAppBottom({double height = 60}) {
    return TabBarSegment(
      key: _globalKey,
      maxHeight: height,
      initialIndex: 1,
      currentIndex: selectedIndex,
      tabCount: titles.length,
      itemBuilder: (ctx, index, isSelect) {
        final e = titles[index];
        return buildItem(e: e, index: index, isSelect: isSelect, height: height);
      },
      onTap: (index) {
        indexVN.value = index;
        print("onTap $index");
      },
      // onClick: (BuildContext context, int index) {
      //   print("onClick $index");
      //   indexVN.value = index;
      // },
    );
  }

  buildTabBarSegment() {
    return ColoredBox(
      color: Theme.of(context).primaryColor,
      child: TabBarSegment(
        key: _globalKey1,
        initialIndex: 2,
        currentIndex: currentIndex,
        tabCount: titles.length,
        onTap: (index){
          print("onTap: $index");
          selectedIndex = index;
        },
        itemBuilder: (context, index, isSelect) {
          final e = titles[index];
          // print("itemBuilder: $index, $isSelect");
          return Tab(
            // height: 60,
            child: Text(e,
                style: TextStyle(
                color: isSelect ? Colors.red : Colors.yellow,
                // backgroundColor: Colors.greenAccent
              ),
            )
          );
        },
      ),
    );
  }

  /// 通过 context 获取 当前 State 类实例对象
  logInfo(BuildContext context, int index) {
    if (index != 0) {
        return;
    }
    final state = (context as StatefulElement).state as TabBarSegmentState;
    final stateNew = context.getStatefulElementState<TabBarSegmentState>();
    print("state ${state} ${state == stateNew}");
  }

  Widget buildItem({
    required String e,
    required int index,
    required bool isSelect,
    double height = 46
  }) {
    if (index != 1){
      return Tab(height: height, text: e);
    }
    final url = isSelect ? R.image.imgUrls[1] : R.image.imgUrls[0];
    return Tab(
      child: FadeInImage(
        image: NetworkImage(url),
        placeholder: AssetImage("images/flutter_logo.png"),
      ),
    );
  }

  onDone() {
    print("onDone");
    _globalKey.currentState?.reset();
    _globalKey1.currentState?.reset();
  }
}


