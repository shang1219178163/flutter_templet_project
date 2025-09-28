import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/EnhanceTab/enhance_tab_bar.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/util/Resource.dart';

class EnhanceTabBarDemo extends StatefulWidget {
  const EnhanceTabBarDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _EnhanceTabBarDemoState createState() => _EnhanceTabBarDemoState();
}

class _EnhanceTabBarDemoState extends State<EnhanceTabBarDemo> with SingleTickerProviderStateMixin {
  final indicatorSizes = EnhanceTabBarIndicatorSize.values;

  // List<String> get indicatorTypes => indicatorSizes.map((e) => e.toString().split(".").last).toList();

  var dropValue = EnhanceTabBarIndicatorSize.tab;

  // /// 初始索引
  // int initialIndex = 1;
  /// 当前索引
  int currentIndex = 0;

  int selectedIndex = 0;

  List<String> titles = List.generate(9, (index) => 'item_$index').toList();

  TabController? _tabController;

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
    // _tabController?.addListener(() {
    //   indexVN.value = _tabController!.index;
    //   print("indexVN:${indexVN.value}_${_tabController?.index}");
    // });
  }

  @override
  Widget build(BuildContext context) {
    // return buildPage();
    // return buildPageOne();
    return buildPageTwo();
  }

  Widget buildItem({required String e, required int index, required bool isSelect, double height = 46}) {
    if (index != 1) {
      return Tab(height: height, text: e);
    }
    final url = isSelect ? Resource.image.urls[1] : Resource.image.urls[0];
    return Tab(
      child: FadeInImage(
        image: NetworkImage(url),
        placeholder: "flutter_logo.png".toAssetImage(),
      ),
    );
  }

  onDone() {
    debugPrint("onDone");
  }

  Widget buildPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Name"),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: titles.map((e) => Tab(text: e * titles.indexOf(e))).toList(),
        ),
      ),
      body: TabBarView(
        //构建
        controller: _tabController,
        children: titles.map((e) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              e,
              style: TextStyle(color: Colors.red),
            ),
          );
        }).toList(),
      ),
    );
  }

  buildEnhanceTabBar({
    required TabController? controller,
    required ValueNotifier<int> indexVN,
    required List<String> items,
    EnhanceTabBarIndicatorSize? indicatorSize = EnhanceTabBarIndicatorSize.fixedWidth,
  }) {
    return EnhanceTabBar(
      isScrollable: true,
      controller: controller,
      // indicatorSize: EnhanceTabBarIndicatorSize.label,
      // indicatorSize: EnhanceTabBarIndicatorSize.fixedWidth,
      indicatorSize: indicatorSize,
      indicatorWidth: 30,
      // labelPadding: EdgeInsets.symmetric(horizontal: 12),
      // indicatorPadding: EdgeInsets.only(left: 8, right: 8),
      indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
        style: BorderStyle.solid,
        width: 4,
        color: Colors.red,
      )),
      tabs: items
          .map((e) => Tab(
                child: ValueListenableBuilder<int>(
                    valueListenable: indexVN,
                    builder: (BuildContext context, int value, Widget? child) {
                      final index = items.indexOf(e);
                      if (index != 1) {
                        if (index == 2) {
                          return Tab(
                            child: Text(
                              e + e,
                            ),
                          );
                        }
                        if (index == 3) {
                          return Tab(
                            child: Text(e + e, style: TextStyle(fontSize: 20)),
                          );
                        }
                        return Tab(text: e);
                      }

                      final url = (value == index) ? Resource.image.urls[1] : Resource.image.urls[0];
                      return Tab(
                        child: FadeInImage(
                          image: NetworkImage(url),
                          placeholder: "flutter_logo.png".toAssetImage(),
                        ),
                      );
                    }),
              ))
          .toList(),
    );
  }

  buildTabBarView({
    required TabController? controller,
    required List<String> items,
  }) {
    return TabBarView(
      //构建
      controller: controller,
      children: items.map((e) {
        return Container(
          color: ColorExt.random,
          alignment: Alignment.center,
          child: Text(
            e,
            style: TextStyle(color: Colors.red),
          ),
        );
      }).toList(),
    );
  }

  Widget buildPageOne() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          _buildDropdownButton(),
        ],
        bottom: buildEnhanceTabBar(controller: _tabController, indexVN: indexVN, items: titles),
      ),
      body: buildTabBarView(controller: _tabController, items: titles),
    );
  }

  Widget buildPageTwo() {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            _buildDropdownButton(),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            Container(
              height: 60,
              color: Colors.lightBlue,
              child: buildEnhanceTabBar(controller: _tabController, indexVN: indexVN, items: titles),
            ).toSliverToBoxAdapter(),
            SliverFillRemaining(
              child: buildTabBarView(controller: _tabController, items: titles),
            ),
            // Container(
            //   height: 400,
            //   color: ColorExt.random,
            //   child: buildTabBarView(
            //     controller: _tabController,
            //     items: titles
            //   ),
            // ),
          ]
          // .map((e) => SliverToBoxAdapter(child: e,)).toList()
          ,
        ));
  }

  Widget _buildDropdownButton() {
    // var dropValue = '语文';
    // var list = ['语文', '数学', '英语'];

    return DropdownButton<EnhanceTabBarIndicatorSize>(
      value: dropValue,
      items: indicatorSizes
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Center(child: Text(e.toString().split(".").last)),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) {
          return;
        }
        dropValue = value;
        debugPrint(dropValue.toString());
        setState(() {});
      },
    );
  }
}
