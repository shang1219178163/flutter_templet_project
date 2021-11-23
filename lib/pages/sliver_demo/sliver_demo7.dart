import 'package:flutter/material.dart';

class SliverDemo7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SliverOpacity/SliverPadding'
        ),
      ),
      body: CustomScrollView(
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
                  child: Text(
                    '透明效果'
                  ),
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
              child: Text(
                'SliverPadding'
              ),
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
      ),
    );
  }
}