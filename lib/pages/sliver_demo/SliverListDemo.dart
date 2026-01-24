import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_decorated.dart';

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

  buildBody() {
    List<Color> colors = Colors.primaries.sublist(5, 10);
    var list = colors.map((e) => _buildItem(color: e)).toList();

    return CustomScrollView(
      slivers: <Widget>[
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
        margin: EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: 20,
        ),
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
    return NSliverDecorated(
      // position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        // color: themeProvider.color242434OrWhite,
        // border: Border.all(color: Colors.blue),
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
                color: Colors.primaries[index % Colors.primaries.length],
              );
            },
            childCount: 20,
          ),
        ),
      ),
    );
  }
}
