//
//  MergeableMaterialDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/13/23 6:27 PM.
//  Copyright © 3/13/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class MergeableMaterialDemo extends StatefulWidget {

  const MergeableMaterialDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _MergeableMaterialDemoState createState() => _MergeableMaterialDemoState();
}

class _MergeableMaterialDemoState extends State<MergeableMaterialDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => print("done"),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
        )).toList(),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          Column(
            children: [
              Container(
                height: 500,
                width: double.infinity,
                padding: EdgeInsets.all(8),
                child: Wrap(
                  children: [
                    ElevatedButton(onPressed: onPressed, child: Text("button")),
                    buildMergeableMaterial(),
                  ],
                ),
              )
            ],
          ),
        ].map((e) => SliverToBoxAdapter(child: e)).toList(),
      ),
    );
  }
  
  onPressed() {

  }


  final items = <MergeableMaterialItem>[];
  bool currIndex = false;
  int currIndexNum = 0;

  _isChildExpanded() {
    setState(() {
      currIndex = !currIndex;
      ++currIndexNum;
    });
  }

  Widget buildMergeableMaterial() {
    items.add(_buildItem());

    return Column(
      children: <Widget>[
        MergeableMaterial(hasDividers: false, children: items),
        ElevatedButton(
          onPressed: () {
            _isChildExpanded();
          },
          child: Text("点击添加"),
        )
      ],
    );
  }

  _buildItem() {
    return MaterialSlice(
      // key:  ValueKey<int>(currIndexNum),
        key: UniqueKey(),
        child:  Column(
          children: <Widget>[
            // header,
            AnimatedCrossFade(
              firstChild:  Container(
                height: 20.0,
                width: 20.0,
                color: Colors.green,
              ),
              secondChild:  Container(
                height: 20.0,
                width: 20.0,
                color: Colors.red,
              ),
              crossFadeState: currIndex ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
              secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
              sizeCurve: Curves.fastOutSlowIn,
              duration: Duration(microseconds: 6),
            )
          ]
        )
    );
  }
}
