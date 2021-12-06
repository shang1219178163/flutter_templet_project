//
//  StateManagerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 11/22/21 9:16 AM.
//  Copyright © 11/22/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';


class StateManagerDemo extends StatefulWidget {

  final String? title;

  StateManagerDemo({ Key? key, this.title}) : super(key: key);


  @override
  _StateManagerDemoState createState() => _StateManagerDemoState();
}

class _StateManagerDemoState extends State<StateManagerDemo> {

  final _tuples = [
    Tuple2("ValueNotifier<T>", APPRouter.providerListDemo),
    Tuple2("RxDart+Provider", APPRouter.rxDartProviderDemo),
    Tuple2("getx", APPRouter.getxStateDemo),

  ];

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        // body: Text(arguments.toString())
        body: _buildBody(),
    );
  }

  _buildBody() {
    return ListView.builder(
      itemCount: _tuples.length,
      itemBuilder: (BuildContext context, int index) {
        final e = _tuples[index];
        return ListTile(
          title: Text(e.item1),
          subtitle: Text(e.item2),
          trailing: Icon(Icons.keyboard_arrow_right_rounded),
          onTap: (){
            Get.toNamed(e.item2, arguments: e.item1);
          },
        );
      }
    );
  }

}





