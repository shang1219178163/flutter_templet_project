import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/EnhanceTab/enhance_tab_bar.dart';
import 'package:flutter_templet_project/basicWidget/tab_bar_segment.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/uti/R.dart';

class TabBarSegmentDemo extends StatefulWidget {

  TabBarSegmentDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TabBarSegmentDemoState createState() => _TabBarSegmentDemoState();
}

class _TabBarSegmentDemoState extends State<TabBarSegmentDemo> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  // /// 初始索引
  // int initialIndex = 1;
  /// 当前索引
  int currentIndex = 0;

  int selectedIndex = 0;

  List<String> titles = List.generate(9, (index) => 'item_$index').toList();

  final _globalKey = GlobalKey<TabBarSegmentState>(debugLabel: "CustomeTabBar");
  // final _globalKey1 = GlobalKey<TabBarSegmentState>(debugLabel: "1");

  ValueNotifier<int> indexVN = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: titles.length, vsync: this);
    _tabController?.addListener(() {
      print(_tabController?.index);
      indexVN.value = _tabController!.index;
    });
  }

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
      body: TabBarView( //构建
        controller: _tabController,
        children: titles.map((e) {
          return Container(
            alignment: Alignment.center,
            child: Text(e, style: TextStyle(color: Colors.red),),
          );
        }).toList(),
      ),
      // body: ListView(
      //   children: [
      //     Center(
      //       child: ValueListenableBuilder<int>(
      //         valueListenable: indexVN,
      //         builder: (BuildContext context, int value, Widget? child) {
      //           return Text('$value');
      //         },
      //       ),
      //     ),
      //     buildTabBarSegment(),
      //   ],
      // )
    );
  }

  buildAppBottom({double height = 60}) {
    return TabBarSegment(
      key: _globalKey,
      controller: _tabController,
      maxHeight: height,
      initialIndex: 1,
      currentIndex: selectedIndex,
      tabCount: titles.length,
      itemBuilder: (ctx, index) {
        final e = titles[index];
        return buildItem(e: e, index: index, height: height);
      },
      // onTap: (index) {
      //   indexVN.value = index;
      //   print("onTap $index");
      // },
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
        // key: _globalKey1,
        initialIndex: 2,
        currentIndex: currentIndex,
        tabCount: titles.length,
        onTap: (index){
          print("onTap: $index");
          selectedIndex = index;
        },
        itemBuilder: (context, index) {
          final e = titles[index];
          bool isSelect = (index == indexVN.value);
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
    double height = 46
  }) {
    bool isSelect = (index == indexVN.value);

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
    // _globalKey1.currentState?.reset();
  }
}


class TabBarSegmentNewDemo extends StatefulWidget {

  TabBarSegmentNewDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TabBarSegmentNewDemoState createState() => _TabBarSegmentNewDemoState();
}

class _TabBarSegmentNewDemoState extends State<TabBarSegmentNewDemo> with SingleTickerProviderStateMixin {

  // /// 初始索引
  // int initialIndex = 1;
  /// 当前索引
  int currentIndex = 0;

  int selectedIndex = 0;

  List<String> titles = List.generate(9, (index) => 'item_$index').toList();

  TabController? _tabController;

  final _globalKey = GlobalKey<TabBarSegmentState>(debugLabel: "CustomeTabBar");
  // GlobalKey<TabBarSegmentState> _globalKey1 = GlobalKey();

  final indexVN = ValueNotifier<int>(0);

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: titles.length, vsync: this);
    _tabController?.addListener(() {
      if(!_tabController!.indexIsChanging){
        indexVN.value = _tabController!.index;
        print("indexVN:${indexVN.value}_${_tabController?.index}");
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    // return buildPage();
    // return buildPageOne();
    // return buildPageOneNew();
    return buildPageTwo();
  }

  buildAppBottom({double height = 60}) {
    return TabBarSegment(
      controller: _tabController,
      // key: _globalKey,
      maxHeight: height,
      initialIndex: 1,
      currentIndex: selectedIndex,
      tabCount: titles.length,
      itemBuilder: (ctx, index) {
        final e = titles[index];
        return buildItem(e: e, index: index, height: height);
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

  Widget buildItem({
    required String e,
    required int index,
    double height = 46
  }) {
    bool isSelect = (index == indexVN.value);

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
    // _globalKey1.currentState?.reset();
  }

  Widget buildPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Name"),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: titles.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: TabBarView( //构建
        controller: _tabController,
        children: titles.map((e) {
          return Container(
            alignment: Alignment.center,
            child: Text(e, style: TextStyle(color: Colors.red),),
          );
        }).toList(),
      ),
    );
  }

  Widget buildPageOne() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          // indicatorSize: TabBarIndicatorSize.label,
          indicatorSize: TabBarIndicatorSize.tab,
          // indicatorSize: TabBarIndicatorSize.width,
          labelPadding: EdgeInsets.symmetric(horizontal: 12),
          indicatorPadding: EdgeInsets.only(left: 16, right: 16),
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                width: 4,
                color: Colors.red,
              )
          ),
          tabs: titles.map((e) => Tab(
            child: ValueListenableBuilder<int>(
              valueListenable: indexVN,
              builder: (BuildContext context, int value, Widget? child) {
                final index = titles.indexOf(e);
                if (index != 1){
                  if (index == 2){
                    return Tab(child: Text(e + e,),);
                  }
                  if (index == 3){
                    return Tab(child: Text(e + e, style: TextStyle(fontSize: 20)),);
                  }
                  return Tab(text: e);
                }

                final url = (value == index) ? R.image.imgUrls[1] : R.image.imgUrls[0];
                return Tab(
                  child: FadeInImage(
                    image: NetworkImage(url),
                    placeholder: AssetImage("images/flutter_logo.png"),
                  ),
                );
              }),
          )).toList(),
        ),
      ),
      body: TabBarView( //构建
        controller: _tabController,
        children: titles.map((e) {
          return Container(
            alignment: Alignment.center,
            child: Text(e, style: TextStyle(color: Colors.red),),
          );
        }).toList(),
      ),
    );
  }

  Widget buildPageTwo() {
    return Scaffold(
      appBar: AppBar(
        title: Text("buildPageTwo"),
      ),
      body: CustomScrollView(
        slivers: [
          SizedBox(height: 50),
          ColoredBox(
            color: Theme.of(context).primaryColor,
            child: TabBarSegment(
              isScrollable: true,
              controller: _tabController,
              initialIndex: 2,
              currentIndex: currentIndex,
              tabCount: titles.length,
              onTap: (index){
                print("onTap: $index");
                selectedIndex = index;
              },
              itemBuilder: (context, index) {
                final e = titles[index];
                print("TabBarSegment itemBuilder: $index");

                return ValueListenableBuilder<int>(
                  valueListenable: indexVN,
                  builder: (BuildContext context, int value, Widget? child) {
                    print("ValueListenableBuilder111 indexVN: $index");
                    final isSelected = (index == indexVN.value);

                    return Tab(
                      child: Text(e,
                        style: TextStyle(
                          color: isSelected ? Colors.red : Colors.yellow,
                          fontSize: isSelected ? 20 : 15,
                          // backgroundColor: Colors.greenAccent
                        ),
                      ),
                    );
                  }
                );
              },
            ),
          ),
          SizedBox(
            height: 500,
            child: TabBarView( //构建
              controller: _tabController,
              children: titles.map((e) {
                return Container(
                  color: ColorExt.random,
                  alignment: Alignment.center,
                  child: Text(e, style: TextStyle(color: Colors.red),),
                );
              }).toList(),
            ),
          ),
        ].map((e) => SliverToBoxAdapter(child: e,)).toList(),
      )
    );
  }

  Widget buildPageOneNew() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        bottom: EnhanceTabBar(
          isScrollable: true,
          controller: _tabController,
          // indicatorSize: TabBarIndicatorSize.label,
          // indicatorSize: EnhanceTabBarIndicatorSize.tab,
          indicatorSize: EnhanceTabBarIndicatorSize.fixedWidth,
          labelPadding: EdgeInsets.symmetric(horizontal: 12),
          // indicatorPadding: EdgeInsets.only(left: 16, right: 16),
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                width: 4,
                color: Colors.red,
              )
          ),
          tabs: titles.map((e) => Tab(
            child: ValueListenableBuilder<int>(
                valueListenable: indexVN,
                builder: (BuildContext context, int value, Widget? child) {
                  final index = titles.indexOf(e);
                  if (index != 1){
                    if (index == 2){
                      return Tab(child: Text(e + e,),);
                    }
                    if (index == 3){
                      return Tab(child: Text(e + e, style: TextStyle(fontSize: 20)),);
                    }
                    return Tab(text: e);
                  }

                  final url = (value == index) ? R.image.imgUrls[1] : R.image.imgUrls[0];
                  return Tab(
                    child: FadeInImage(
                      image: NetworkImage(url),
                      placeholder: AssetImage("images/flutter_logo.png"),
                    ),
                  );
                }),
          )).toList(),
        ),
      ),
      body: TabBarView( //构建
        controller: _tabController,
        children: titles.map((e) {
          return Container(
            alignment: Alignment.center,
            child: Text(e, style: TextStyle(color: Colors.red),),
          );
        }).toList(),
      ),
    );
  }
}

