//
//  NestedScrollViewDemo.dart
//  fluttertemplet
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
          return <Widget>[SliverAppBar(title: Text("hello title"))];
        },
        body: ListView.builder(
            itemCount: 50,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 100,
                color: Colors.green,
                child: Center(
                  child: Text("hello world $index"),
                ),
              );
            }));
  }
}