import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/pages/FirstPage.dart';
import 'package:flutter_templet_project/pages/SecondPage.dart';
import 'package:flutter_templet_project/pages/ThirdPage.dart';
import 'package:flutter_templet_project/pages/FourthPage.dart';
import 'package:flutter_templet_project/pages/BatterLevelPage.dart';
import 'package:flutter_templet_project/uti/R.dart';

import 'package:flutter_templet_project/pages/demo/TabBarDemo.dart';


class TabBarDemoNew extends StatefulWidget {

  final String? title;

  const TabBarDemoNew({ Key? key, this.title}) : super(key: key);

  @override
  _TabBarDemoNewState createState() => _TabBarDemoNewState();
}

class _TabBarDemoNewState extends State<TabBarDemoNew> with TickerProviderStateMixin{
  late TabController _tabController;
  late TabController _tabController1;

  get list => tabItems.sublist(0, 4);

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabItems.length, vsync: this)
      ..addListener(() {
        if(!_tabController.indexIsChanging){
          debugPrint("_tabController:${_tabController.index}");
        }
      });

    _tabController1 = TabController(length: list.length, vsync: this)
      ..addListener(() {
        if(!_tabController1.indexIsChanging){
          debugPrint("_tabController:${_tabController1.index}");
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    // return buildPage(controller: _tabController, items: tabItems);
    return buildPage1(controller: _tabController1, items: list);
  }

  Widget buildPage({
    required TabController? controller,
    List<Tuple2<Icon, Widget>> items = const [],
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(R.image.urls[5]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        bottom: TabBar(
          controller: controller,
          tabs: items.map((e) => e.item1).toList(),
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: items.map((e) => e.item2).toList(),
      ),
    );
  }

  Widget buildPage1({
    required TabController? controller,
    List<Tuple2<Icon, Widget>> items = const [],
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(R.image.urls[5]),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: _buildTabBarPage(controller: controller, items: items),
    );
  }

  /// TabBar 脱离 AppBar
  Widget _buildTabBarPage({
    required TabController? controller,
    List<Tuple2<Icon, Widget>> items = const [],
    double barHeight = 50,
  }) {
    return LayoutBuilder(
      builder: (context, constraints){

        return Column(
          children: [
            Container(
              color: Colors.blue,
              height: barHeight,
              child: TabBar(
                controller: controller,
                // isScrollable: true,
                // padding: EdgeInsets.symmetric(horizontal: 42),
                // indicatorPadding: EdgeInsets.symmetric(horizontal: 42),
                // labelPadding: EdgeInsets.symmetric(horizontal: 28.5),
                tabs: items.map((e) => Tab(icon: e.item1)).toList(),
              ),
            ),
            Container(
              height: constraints.maxHeight - barHeight,
              child: TabBarView(
                controller: controller,
                children: items.map((e) => e.item2).toList(),
              ),
            ),
          ],
        );
      }
    );
  }
}