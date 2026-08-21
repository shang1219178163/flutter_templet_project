import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/app_update_card.dart';
import 'package:flutter_templet_project/basicWidget/section_list_view.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/model/mock_data.dart';
import 'package:flutter_templet_project/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class ListViewStyleDemo extends StatefulWidget {
  const ListViewStyleDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ListViewStyleDemoState createState() => _ListViewStyleDemoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _ListViewStyleDemoState extends State<ListViewStyleDemo> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: _pages.length, vsync: this);

  List<Tuple2<String, Widget>> _pages = [];

  @override
  void initState() {
    super.initState();
    // _tabController.index = _pages.length - 1;

    _pages = [
      Tuple2('升级列表', buildPage2()),
      Tuple2('列表(泛型)', buildPage3()),
      Tuple2('列表(折叠)', buildPage4()),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // titleTextStyle: TextStyle(color: Colors.red),
        // toolbarTextStyle: TextStyle(color: Colors.orange),
        // iconTheme: IconThemeData(color: Colors.green),
        actionsIconTheme: IconThemeData(color: Colors.yellow),
        title: Text(widget.title ?? "$widget"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _pages.map((e) => Tab(key: PageStorageKey<String>(e.item1), text: e.item1)).toList(),
          // indicatorSize: TabBarIndicatorSize.label,
          // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _pages.map((e) => e.item2).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
          // testData();
          getTitles(tuples: tuples);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildPage2() {
    return ListView.separated(
      cacheExtent: 180,
      itemCount: kUpdateAppList.length,
      itemBuilder: (context, index) {
        final data = kUpdateAppList[index];
        if (index == 0) {
          return AppUpdateCard(
            data: data,
            isExpand: true,
            showExpand: false,
          );
        }
        return AppUpdateCard(data: data);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Widget buildPage3() {
    return SectionListView<String, Tuple2<String, String>>(
      headerList: tuples.map((e) => e.item1).toList(),
      itemList: tuples
          .map((e) => e.item2)
          .toList()
          .map((e) => e.sorted((a, b) => a.item1.toLowerCase().compareTo(b.item1.toLowerCase())))
          .toList(),
      headerBuilder: (e) {
        return Container(
          // color: Colors.red,
          padding: EdgeInsets.only(top: 10, bottom: 8, left: 10, right: 15),
          child: Text(
            e,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      },
      itemBuilder: (section, row, e) {
        return ListTile(
          title: Text(e.item2),
          subtitle: Text(e.item2.toCapitalize()),
          trailing: Icon(Icons.keyboard_arrow_right_rounded),
          dense: true,
          onTap: () {
            // Get.toNamed(e.item1, arguments: e);
            if (e.item1.toLowerCase().contains("loginPage".toLowerCase())) {
              Get.offNamed(e.item1, arguments: e.item1);
            } else {
              Get.toNamed(e.item1, arguments: e.item1);
            }
          },
        );
      },
    );
  }

  Widget buildPage4() {
    return EnhanceExpandListView(
      children: tuples
          .map<ExpandPanelModel<Tuple2<String, String>>>((e) => ExpandPanelModel(
                canTapOnHeader: true,
                isExpanded: false,
                arrowPosition: EnhanceExpansionPanelArrowPosition.none,
                // backgroundColor: Color(0xFFDDDDDD),
                headerBuilder: (contenx, isExpand) {
                  final trailing = isExpand
                      ? Icon(Icons.keyboard_arrow_up, color: Colors.blue)
                      : Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.blue,
                        );
                  return Container(
                    // color: Colors.green,
                    color: isExpand ? Colors.black12 : null,
                    child: ListTile(
                      title: Text(
                        e.item1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // subtitle: Text("subtitle"),
                      trailing: trailing,
                    ),
                  );
                },
                bodyChildren: e.item2,
                bodyItemBuilder: (context, e) {
                  return ListTile(
                      title: Text(
                        e.item1,
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        e.item2,
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Icon(Icons.chevron_right),
                      dense: true,
                      // contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      onTap: () {
                        if (e.item1.toLowerCase().contains("loginPage".toLowerCase())) {
                          Get.offNamed(e.item1, arguments: e.item1);
                        } else {
                          Get.toNamed(e.item1, arguments: e.item1);
                        }
                      });
                },
              ))
          .toList(),
    );
  }

  List<String> getTitles({required List<Tuple2<String, List<Tuple2<String, String>>>> tuples}) {
    final titles = tuples.expand((e) => e.item2.map((e) => e.item1)).toList();
    final result = List<String>.from(titles);
    // print('titles runtimeType:${titles.runtimeType},${titles.every((element) => element is String)},');
    debugPrint('result runtimeType:${result.runtimeType}');
    return result;
  }
}
