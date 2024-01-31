
//
//  NAppBarColorChangerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/12 21:34.
//  Copyright © 2024/1/12 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NAppBarColorChanger.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/util/debug_log.dart';

class NAppBarColorChangerDemo extends StatefulWidget {

  NAppBarColorChangerDemo({
    super.key, 
    this.title
  });

  final String? title;

  @override
  State<NAppBarColorChangerDemo> createState() => _NAppBarColorChangerDemoState();
}

class _NAppBarColorChangerDemoState extends State<NAppBarColorChangerDemo> {

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return NAppBarColorChanger(
      child: Scaffold(
        backgroundColor: Colors.black12,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: ['保存', '分享'].map((e) => buildAppBarButton(
            title: e,
            onPressed: () {
              DebugLog.d("onTap: $e");
            },
          )).toList(),
        ),
        body: buildBody(),
      ),
    );
  }

  Widget buildAppBarButton({required String title, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed ?? () {
        DebugLog.d("onTap: $title");
      },
      child: Container(
        margin: EdgeInsets.only(right: 16, top: 12, bottom: 12),
        alignment: Alignment.center,
        // color: Colors.red,
        child: Text(title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  buildBody() {
    var indexs = List<int>.generate(30, (index) => index);
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: ClampingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: "bg_beach.jpg".toAssetImage(),
              fit: BoxFit.fill,
            )
          ),
          child: Column(
            children: [
              ...indexs.map((e) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: ListTile(
                        leading: FlutterLogo(size: 48,),
                        title: Text("row_$e"),
                      ),
                    ),
                    Divider(indent: 48 + 12 * 2,),
                  ],
                );
              }).toList(),
            ]
          ),
        ),
      ),
    );
  }



  
}

