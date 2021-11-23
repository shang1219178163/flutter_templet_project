import 'package:flutter/material.dart';

class SliverDemo1 extends StatefulWidget {
  final String title;

  const SliverDemo1({Key? key, required this.title}) : super(key: key);

  @override
  _SliverDemo1State createState() => _SliverDemo1State();
}

class _SliverDemo1State extends State<SliverDemo1> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,),
      ),
      body: SafeArea(
        child: createExample2(),
      ),
    );
  }

  /// SliverGridDelegateWithMaxCrossAxisExtent
  Widget createExample3() {
    print(MediaQuery.of(context).size.width.toString());
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 20,
            ),
            child: Text('list'),
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                color: Colors.primaries[index],
              );
            },
            childCount: Colors.primaries.length,
          ),
          itemExtent: 50,
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 20,
            ),
            child: Text('grid'),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 120,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              color: Colors.primaries[index],
            );
          }, childCount: Colors.primaries.length),
        ),
      ],
    );
  }

  /// SliverChildBuilderDelegate和SliverGridDelegateWithFixedCrossAxisCount
  Widget createExample2() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 20,
            ),
            child: Text('list'),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              height: 50,
              color: Colors.primaries[index],
            );
          }, childCount: Colors.primaries.length),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 20,
            ),
            child: Text('grid'),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              color: Colors.primaries[index],
            );
          }, childCount: Colors.primaries.length),
        ),
      ],
    );
  }

  /// SliverChildListDelegate
  Widget createExample1() {
    List<Widget> list = [];
    for (var i = 0; i < Colors.primaries.length; i++) {
      list.add(Container(
        height: 50,
        color: Colors.primaries[i],
      ));
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 20,
            ),
            child: Text('list'),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            list,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 20,
            ),
            child: Text('grid'),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          delegate: SliverChildListDelegate(
            list,
          ),
        )
      ],
    );
  }
}
