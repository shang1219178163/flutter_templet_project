import 'package:flutter/material.dart';

class SliverFillRemainingDemo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SliverFillRemaining',
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 600,
              color: Colors.red[400],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: Colors.black12,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'SliverFillRemaining'
                    ),
                    Text(
                      '向上滑动时自动充满视图的剩余空间'
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}