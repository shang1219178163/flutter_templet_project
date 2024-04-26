

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_transform_view.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:get/get.dart';

class NTransformViewDemo extends StatefulWidget {

  NTransformViewDemo({
    super.key, 
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NTransformViewDemo> createState() => _NTransformViewDemoState();
}

class _NTransformViewDemoState extends State<NTransformViewDemo> {

  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};
  /// id
  late final id = arguments["id"];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp ? null : AppBar(
        title: Text("$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: NTransformView(
        title: '测试',
        message: '提示信息',
        onGenerate: (text){
          final result = text * 2;
          return result;
        },
        onCreate: (val){
          ddlog("onCreate: $val");
        },
      ),
    );
  }

  
}