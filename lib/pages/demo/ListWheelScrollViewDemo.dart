//
//  ListWheelScrollViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/24/23 5:05 PM.
//  Copyright © 3/24/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class ListWheelScrollViewDemo extends StatefulWidget {

  const ListWheelScrollViewDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _ListWheelScrollViewDemoState createState() => _ListWheelScrollViewDemoState();
}

class _ListWheelScrollViewDemoState extends State<ListWheelScrollViewDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => debugPrint(e),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: _buildListWheelScrollView(),
    );
  }

  _buildListWheelScrollView() {
    return ListWheelScrollView.useDelegate(
      itemExtent: 150,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: 100,
        builder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(
                vertical: 10, horizontal: 30
            ),
            color: Colors.primaries[index % 10],
            alignment: Alignment.center,
            child: Text('$index'),
          );
        },
      ),
    );

  }

}

