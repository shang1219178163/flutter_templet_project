//
//  PageLifecycleFuncTest.dart
//  flutter_templet_project
//
//  Created by shang on 2023/4/4 20:16.
//  Copyright © 2023/4/4 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/pages/PageLifecycleObserverDemo.dart';

class PageLifecycleFuncTest extends StatefulWidget {

  PageLifecycleFuncTest({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _PageLifecycleFuncTestState createState() => _PageLifecycleFuncTestState();
}

class _PageLifecycleFuncTestState extends State<PageLifecycleFuncTest> {

  final titleVN = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
  }

   @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onPressed,)
        ).toList(),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return CustomScrollView(
      slivers: [
        Text(arguments.toString()),
        ValueListenableBuilder<String>(
            valueListenable: titleVN,
            builder: (context, value, child) {
              // debugPrint("$value");
              return Container(
                height: 300,
                child: PageLifecycleObserverDemo(title: value,),
              );
            }
        ),
      ].map((e) => SliverToBoxAdapter(child: e,)).toList(),
    );
  }
  
  onPressed(){
    if (titleVN.value.length > 20) {
      titleVN.value = "z_";
    } else {
      titleVN.value += "z_";
    }
    titleVN.value += "_${titleVN.value.length}";
  }

}