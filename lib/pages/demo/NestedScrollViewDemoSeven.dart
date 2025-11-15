import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:tuple/tuple.dart';

class NestedScrollViewDemoSeven extends StatefulWidget {
  const NestedScrollViewDemoSeven({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NestedScrollViewDemoSeven> createState() => _NestedScrollViewDemoSevenState();
}

class _NestedScrollViewDemoSevenState extends State<NestedScrollViewDemoSeven> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  var initialIndex = 0;

  var items = <Tuple2<Tab, Widget>>[];

  @override
  void initState() {
    items = <Tuple2<Tab, Widget>>[
      Tuple2(
        Tab(icon: Text("汽车")),
        _buildPage(),
      ),
      Tuple2(
        Tab(icon: Text("火车")),
        _buildPage1(),
      ),
      Tuple2(
        Tab(icon: Text("飞机")),
        _buildPage2(),
      ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      initialIndex: initialIndex,
      length: items.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('$widget'),
          // bottom: TabBar(
          //   labelColor: Colors.white,
          //   unselectedLabelColor: Colors.white,
          //   tabs: items.map((e) => e.item1).toList(),
          // ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                final spacing = 8.0;
                final rowCount = 3.0;
                final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  // crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ...List.generate(8, (i) => i).map((e) {
                      return FractionallySizedBox(
                        widthFactor: 0.45,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text("板块 $e"),
                        ),
                      );
                    }),
                  ],
                );
              }),
            ),
            buildBody(),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Material(
          color: Colors.blue,
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: items.map((e) => e.item1).toList(),
          ),
        ),
        Flexible(
          child: TabBarView(
            children: items.map((e) => e.item2).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPage() {
    return buildListView(tab: 0);
  }

  Widget _buildPage1() {
    return buildListView(tab: 1);
  }

  Widget _buildPage2() {
    return buildListView(tab: 2);
  }

  Widget buildListView({required int tab}) {
    return EasyRefresh(
      onRefresh: () {
        DLog.d("onRefresh");
      },
      onLoad: () {
        DLog.d("onLoad");
      },
      child: ListView.separated(
        itemBuilder: (_, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              // border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.8),
                child: Image(
                  image: AssetImage("assets/images/img_placeholder.png"),
                  width: 48,
                  height: 48,
                ),
              ),
              title: NText("$tab 用户 $index"),
              subtitle: NText(
                80.generateChars(),
                fontSize: 12,
                maxLines: 1,
              ),
            ),
          );
        },
        separatorBuilder: (_, index) {
          // return SizedBox(height: 8);
          return Divider(height: 0.5, color: AppColor.lineColor);
        },
        itemCount: 20,
      ),
    );
  }

  void onPressed() {
    debugPrint("onPressed");
  }
}
