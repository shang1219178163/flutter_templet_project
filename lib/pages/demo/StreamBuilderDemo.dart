//
//  StreamBuilderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/19/21 9:41 PM.
//  Copyright © 10/19/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class StreamBuilderDemo extends StatefulWidget {

  final String? title;

  StreamBuilderDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _StreamBuilderDemoState createState() => _StreamBuilderDemoState();
}

class _StreamBuilderDemoState extends State<StreamBuilderDemo> {

  Stream<int> counter() {
    return Stream.periodic(Duration(seconds: 1), (i) {
      return i;
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: buildBody(),
    );
  }

  Widget buildBody() {
    return StreamBuilder<int>(
      stream: counter(), //
      //initialData: ,// a Stream<int> or null
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasError)
          return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('没有Stream');
          case ConnectionState.waiting:
            return Text('等待数据...');
          case ConnectionState.active:
            return Text('active: ${snapshot.data}');
          case ConnectionState.done:
            return Text('Stream 已关闭');
        }
        return Text('0'); // unreachable
      },
    );
  }

}