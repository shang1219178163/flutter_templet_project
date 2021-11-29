
//
//  GetxDemo.dart
//  flutter_templet_project
//
//  Created by shang on 11/23/21 2:57 PM.
//  Copyright © 11/23/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetxDemo extends StatefulWidget {

  final String? title;

  GetxDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _GetxDemoState createState() => _GetxDemoState();
}

class _GetxDemoState extends State<GetxDemo> {

  var counter = 0.obs;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Text(arguments.toString())

        floatingActionButton: Obx(() {
          return IconButton(onPressed: (){
            counter++;
          }, icon: Icon(Icons.add));
        }),
    );
  }

}


