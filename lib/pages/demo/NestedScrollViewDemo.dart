//
//  NestedScrollViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/21/21 9:33 AM.
//  Copyright © 10/21/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class NestedScrollViewDemo extends StatefulWidget {

  final String? title;

  NestedScrollViewDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _NestedScrollViewDemoState createState() => _NestedScrollViewDemoState();
}

class _NestedScrollViewDemoState extends State<NestedScrollViewDemo> {




  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          // SliverAppBar(title: Text("hello title")),
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: true,
            expandedHeight: 200,
            forceElevated: innerBoxIsScrolled,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "images/bg.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ];
      },
      body: ListView.builder(
        itemCount: 50,
        itemBuilder: (BuildContext context, int index) {
          return Material(
            child: Container(
                height: 60,
                decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.red))
              ),
              child: ListTile(
                title: Text("row_$index"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              )
            )
          );
        }
      )
    );
  }
}