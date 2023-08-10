//
//  ValueListenableBuilderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 5:09 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//

import 'package:connectivity/connectivity.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NNet/NNet.dart';
import 'package:flutter_templet_project/basicWidget/NNet/NNetContainerListView.dart';
import 'package:flutter_templet_project/provider/notifier_demo.dart';
import 'package:flutter_templet_project/service/connectivity_service.dart';

class NetStateListenerDemo extends StatefulWidget {

  NetStateListenerDemo({
    Key? key,
    this.title
  }) : super(key: key);

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
        actions: ['done',].map((e) => TextButton(
          onPressed: () => debugPrint(e),
          child: Text(e,
            style: const TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: Column(
        children: [
          _buildNetState(),
          _buildNetOnline(),
          _buildNet(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _easyRefreshController.callRefresh(),
                child: Text("callRefresh"),
              ),
              ElevatedButton(
                onPressed: () => _easyRefreshController.callLoad(),
                child: Text("callLoad"),
              ),
            ]
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(color: Colors.red, width: 2),
            ),
            height: 400,
            width: double.maxFinite,
            child: NNetContainerListView<String>(
              refreshController: _easyRefreshController,
              onRequest: (bool isRefesh, int page, int pageSize, last) async {

                return await Future.delayed(const Duration(milliseconds: 1500), () {
                  final result = List<String>.generate(3, (i) => 'page_${page}_pageSize_${pageSize}_Item_$i');
                  return Future.value(result);
                });
              },
              onRequestError: (error, stackTree) {
                debugPrint(error.toString());
              },
              itemBuilder: (BuildContext context, int index, data) {

                return ListTile(
                  leading: Icon(Icons.ac_unit),
                  title: Text("$data"),
                );
              },
            ),
          )

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
    return NNet(
      // state: netState,
      childBuilder: (ctx, child) {
        return ElevatedButton(
            onPressed: () => debugPrint("ElevatedButton"),
            child: Text("ElevatedButton"),
        );
      },
      errorBuilder: (ctx, child) {
        return TextButton(
          onPressed: () => debugPrint("offlineBuilder"),
          child: Text("offlineBuilder"),
        );
      },

    );
  }
  

}


