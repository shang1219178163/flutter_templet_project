import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_decorated.dart';
import 'package:flutter_templet_project/basicWidget/refresh_control/cupertino_sliver_refresh_control_ext.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/AppRes.dart';

class SliverListDemo extends StatefulWidget {
  final String? title;

  const SliverListDemo({Key? key, this.title}) : super(key: key);

  @override
  _SliverListDemoState createState() => _SliverListDemoState();
}

class _SliverListDemoState extends State<SliverListDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    List<Color> colors = Colors.primaries.sublist(5, 10);
    var list = colors.map((e) => _buildItem(color: e)).toList();

    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverRefreshControl(
          builder: CupertinoSliverRefreshControlExt.customRefreshIndicator,
          onRefresh: onRefresh,
        ),
        sectionHeader(title: 'SliverList - NSliverDecorated'),
        buildListView(),
        sectionHeader(title: 'SliverList - SliverChildListDelegate'),
        SliverList(
          delegate: SliverChildListDelegate(
            list,
          ),
        ),
        sectionHeader(title: 'SliverList - SliverChildBuilderDelegate'),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return _buildItem(color: colors[index]);
          }, childCount: colors.length),
        ),
        sectionHeader(title: 'SliverFixedExtentList - SliverChildBuilderDelegate'),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildItem(color: colors[index]);
            },
            childCount: colors.length,
          ),
          itemExtent: 50,
        ),
        sectionHeader(title: 'SliverPrototypeExtentList - SliverChildBuilderDelegate'),
        SliverPrototypeExtentList(
          prototypeItem: Container(
            height: 50,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildItem(color: colors[index]);
            },
            childCount: colors.length,
          ),
        ),
      ],
    );
  }

  sectionHeader({required String title}) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 20, left: 20),
        child: Text(title),
      ),
    );
  }

  Widget _buildItem({required Color color}) {
    return Container(
      height: 50,
      color: color,
    );
  }

  Widget buildListView() {
    final primaries = Colors.primaries.sublist(0, 5);
    return NSliverDecorated(
      // position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(AppRes.image.urls[5]),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue,
            Colors.white.withOpacity(0.0),
          ],
        ),
      ),
      sliver: SliverPadding(
        padding: EdgeInsets.all(20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (content, index) {
              return Container(
                height: 45,
                margin: EdgeInsets.only(bottom: 8),
                color: primaries[index],
              );
            },
            childCount: primaries.length,
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    DLog.d("开始刷新");
    await Future.delayed(Duration(milliseconds: 1500));
    DLog.d("结束刷新");
  }
}
