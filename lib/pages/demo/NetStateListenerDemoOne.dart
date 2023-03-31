//
//  ValueListenableBuilderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 5:09 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/service/connectivity_service.dart';

class NetStateListenerDemoOne extends StatefulWidget {

  const NetStateListenerDemoOne({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _NetStateListenerDemoOneState createState() => _NetStateListenerDemoOneState();
}

class _NetStateListenerDemoOneState extends State<NetStateListenerDemoOne> with NetConnectivityMixin
    implements NetConnectivityListener {

  final netConnectResult = ValueNotifier<ConnectivityResult>(ConnectivityResult.mobile);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: onPressed,
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: Column(
        children: [
          ValueListenableBuilder<ConnectivityResult>(
            valueListenable: netConnectResult,
            builder: (context, value, child) {
              print('ValueListenableBuilder: netConnectResult:$value');

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  child!,
                  Text('$value'),
                ],
              );
            },
            child: Text("监听 netConnectResult"),
          ),
        ],
      ),
    );
  }

  onPressed(){
    final list = [];
    list.remove("1");
    print(list);
  }

  @override
  NetConnectivityListener get connectivityListener => this;

  @override
  void onNetStateChaneged(ConnectivityResult result) {
    print("onNetStateChaneged $result ${result != ConnectivityResult.none}");
    netConnectResult.value = result;
    if (result == ConnectivityResult.none) {
      return;
    }
  }
}
