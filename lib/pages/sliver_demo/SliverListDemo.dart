import 'package:flutter/material.dart';

class SliverListDemo extends StatefulWidget {

  final String? title;

  const SliverListDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _SliverListDemoState createState() => _SliverListDemoState();
}

class _SliverListDemoState extends State<SliverListDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: createExample(),
    );
  }

  sectionHeader({Widget? child}) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: 20,
        ),
        child: child ?? Text('SliverToBoxAdapter'),
      ),
    );
  }

  Widget _buildItem({required Color color}) {
    return Container(
      height: 50,
      color: color,
    );
  }

  createExample() {
    List<Color> colors = Colors.primaries.sublist(5, 10);
    var list = colors.map((e) => _buildItem(color: e)).toList();

    return CustomScrollView(
      slivers: <Widget>[
        sectionHeader(child: Text('SliverList - SliverChildListDelegate')),
        SliverList(
          delegate: SliverChildListDelegate(list,),
        ),

        sectionHeader(child: Text('SliverList - SliverChildBuilderDelegate')),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return _buildItem(color: colors[index]);
          },
              childCount: colors.length
          ),
        ),

        sectionHeader(child: Text('SliverFixedExtentList - SliverChildBuilderDelegate')),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              color: colors[index],
            );
          },
            childCount: colors.length,
          ),
          itemExtent: 50,
        ),
      ],
    );
  }
}