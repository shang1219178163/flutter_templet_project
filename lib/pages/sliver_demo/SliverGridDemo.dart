import 'package:flutter/material.dart';

class SliverGridDemo extends StatefulWidget {

  final String? title;

  SliverGridDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _SliverGridDemoState createState() => _SliverGridDemoState();
}

class _SliverGridDemoState extends State<SliverGridDemo> {


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
    List<Color> colors = Colors.primaries.sublist(5, );
    List<Widget> list = colors.map((e) => _buildItem(color: e)).toList();

    return CustomScrollView(
      slivers: <Widget>[
        sectionHeader(child: Text('SliverGrid - SliverGridDelegateWithFixedCrossAxisCount')),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          delegate: SliverChildListDelegate(list,),
        ),

        sectionHeader(child: Text('SliverGrid - SliverGridDelegateWithMaxCrossAxisExtent')),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 120,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              color: colors[index],
            );
          }, childCount: colors.length),
        ),
      ],
    );
  }
}