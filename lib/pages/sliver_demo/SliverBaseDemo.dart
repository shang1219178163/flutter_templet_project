import 'package:flutter/material.dart';

class SliverBaseDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SliverBase'
        ),
      ),
      // body: _buildSliverOpacityAndPadding(),
      body: createExample1(),
      // body: createExample2(),
      // body: createExample3(),

    );
  }

  _buildHeader({Widget? child}) {
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

  /// SliverChildListDelegate
  createExample1() {
    List<Widget> list = Colors.primaries.map((e) => _buildItem(color: e)).toList();

    return CustomScrollView(
      slivers: <Widget>[
        _buildHeader(child: Text('list')),
        SliverList(
          delegate: SliverChildListDelegate(list,),
        ),

        _buildHeader(child: Text('grid')),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          delegate: SliverChildListDelegate(list,),
        )
      ],
    );
  }

  /// SliverChildBuilderDelegate和SliverGridDelegateWithFixedCrossAxisCount
  createExample2() {
    return CustomScrollView(
      slivers: <Widget>[
        _buildHeader(child: Text('SliverList')),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return _buildItem(color: Colors.primaries[index]);
          },
              childCount: Colors.primaries.length
          ),
        ),

        _buildHeader(child: Text('SliverGrid')),
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

  /// SliverGridDelegateWithMaxCrossAxisExtent
  createExample3() {
    // print(MediaQuery.of(context).size.width.toString());
    return CustomScrollView(
      slivers: <Widget>[
        _buildHeader(child: Text('SliverFixedExtentList')),
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

        _buildHeader(child: Text('SliverGrid')),
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

  _buildSliverOpacityAndPadding() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              bottom: 20,
            ),
            child: Text(
                'SliverOpacity'
            ),
          ),
        ),
        SliverOpacity(
          opacity: 0.5,
          alwaysIncludeSemantics: true,
          sliver: SliverToBoxAdapter(
            child: Container(
              height: 200,
              color: Colors.red,
              child: Center(
                child: Text('透明效果'),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              bottom: 20,
            ),
            color: Colors.grey,
            child: Text('SliverPadding'),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(10),
          sliver: SliverToBoxAdapter(
            child: Container(
              height: 200,
              color: Colors.blueAccent,
              child: Center(
                child: Text(
                  '设置padding',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}