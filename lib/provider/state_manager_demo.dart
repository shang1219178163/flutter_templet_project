//
//  StateManagerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 11/22/21 9:16 AM.
//  Copyright © 11/22/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class StateManagerDemo extends StatefulWidget {
  final String? title;

  const StateManagerDemo({Key? key, this.title}) : super(key: key);

  @override
  _StateManagerDemoState createState() => _StateManagerDemoState();
}

class _StateManagerDemoState extends State<StateManagerDemo> {
  final _tuples = [
    Tuple2("ValueNotifier<T>", AppRouter.providerListDemo),
    Tuple2("RxDart+Provider", AppRouter.rxDartProviderDemo),
    Tuple2("getx", AppRouter.getxStateDemo),
    Tuple2("getxStateDemoNew", AppRouter.getxStateDemoNew),
    Tuple2("proxyProviderDemo", AppRouter.proxyProviderDemo),
    Tuple2("providerDemo", AppRouter.providerDemo),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return ListView.builder(
        itemCount: _tuples.length,
        itemBuilder: (BuildContext context, int index) {
          final e = _tuples[index];
          return ListTile(
            title: Text(e.item1),
            subtitle: Text(e.item2),
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
            onTap: () {
              Get.toNamed(e.item2, arguments: e.item1);
            },
          );
        });
  }
}
