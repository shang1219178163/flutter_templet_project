import 'package:flutter/material.dart';

class SliverDemo6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SliverFillViewport'
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFillViewport(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  color: Colors.primaries[index % Colors.primaries.length],
                );
              }
            ),
            viewportFraction: 1.0,
          ),
        ],
      ),
    );
  }
}