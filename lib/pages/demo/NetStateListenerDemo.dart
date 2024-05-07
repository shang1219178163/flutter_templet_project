//
//  ValueListenableBuilderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 5:09 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_network/n_network_online.dart';
import 'package:flutter_templet_project/service/connectivity_service.dart';

class NetStateListenerDemo extends StatefulWidget {
  NetStateListenerDemo({Key? key, this.title}) : super(key: key);

  String? title;

  @override
  _NetStateListenerDemoState createState() => _NetStateListenerDemoState();
}

class _NetStateListenerDemoState extends State<NetStateListenerDemo> {
  late final _easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: () => debugPrint(e),
                  child: Text(
                    e,
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: Column(
        children: [
          _buildNetState(),
          _buildNetOnline(),
          _buildNet(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
              onPressed: () => _easyRefreshController.callRefresh(),
              child: Text("callRefresh"),
            ),
            ElevatedButton(
              onPressed: () => _easyRefreshController.callLoad(),
              child: Text("callLoad"),
            ),
          ]),
        ],
      ),
    );
  }

  _buildNetState() {
    return ValueListenableBuilder<ConnectivityResult>(
      valueListenable: ConnectivityService().netState,
      builder: (context, value, child) {
        debugPrint('ValueListenableBuilder: netState:$value');

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            child!,
            Text('$value'),
          ],
        );
      },
      child: Text("监听 ConnectivityService().netState"),
    );
  }

  _buildNetOnline() {
    return ValueListenableBuilder<bool>(
      valueListenable: ConnectivityService().onLine,
      builder: (context, value, child) {
        debugPrint('ValueListenableBuilder: onLine:$value');

        // netState.value = value == false ? NNetState.offline : NNetState.normal;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            child!,
            Text('$value'),
          ],
        );
      },
      child: Text("监听 ConnectivityService().onLine"),
    );
  }

  _buildNet() {
    return NNetworkOnLine(
      builder: (ctx, child) {
        return ElevatedButton(
          onPressed: () => debugPrint("ElevatedButton"),
          child: Text("ElevatedButton"),
        );
      },
      offlineBuilder: (ctx, child) {
        return TextButton(
          onPressed: () => debugPrint("offlineBuilder"),
          child: Text("offlineBuilder"),
        );
      },
    );
  }
}
