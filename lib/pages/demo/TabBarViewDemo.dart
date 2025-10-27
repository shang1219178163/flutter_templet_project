import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/AppRes.dart';

class TabBarViewDemo extends StatefulWidget {
  TabBarViewDemo({
    super.key,
    this.title,
  });

  final String? title;

  @override
  State<TabBarViewDemo> createState() => _TabBarViewDemoState();
}

class _TabBarViewDemoState extends State<TabBarViewDemo> with SingleTickerProviderStateMixin {
  /// 当前索引
  int currentIndex = 0;

  int selectedIndex = 0;

  List<String> titles = List.generate(9, (index) => 'item_$index').toList();

  late final tabController = TabController(length: titles.length, vsync: this);

  final tabIndex = ValueNotifier<int>(0);

  Color get primary => Theme.of(context).colorScheme.primary;

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        tabIndex.value = tabController.index;
        debugPrint("indexVN:${tabIndex.value}_${tabController.index}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Material(
          color: primary,
          child: TabBar(
            isScrollable: true,
            controller: tabController,
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
            )),
            tabs: titles
                .map((e) => Tab(
                      child: ValueListenableBuilder<int>(
                          valueListenable: tabIndex,
                          builder: (BuildContext context, int value, Widget? child) {
                            final index = titles.indexOf(e);
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

                            final url = (value == index) ? AppRes.image.urls[1] : AppRes.image.urls[0];
                            return Tab(
                              child: FadeInImage(
                                image: NetworkImage(url),
                                placeholder: "flutter_logo.png".toAssetImage(),
                              ),
                            );
                          }),
                    ))
                .toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            //构建
            controller: tabController,
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
        ),
      ],
    );
  }
}
