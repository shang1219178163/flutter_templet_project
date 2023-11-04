//
//  MenuDemo.dart
//  flutter_templet_project
//
//  Created by shang on 8/17/21 8:42 AM.
//  Copyright © 8/17/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class MenuDemo extends StatefulWidget {

  MenuDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  State<MenuDemo> createState() => _MenuDemoState();
}

class _MenuDemoState extends State<MenuDemo> {

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Text("$widget"),
          ],
        ),
      ),
    );
  }
  
}