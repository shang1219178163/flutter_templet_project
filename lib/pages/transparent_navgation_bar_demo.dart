//
//  TransparentNavgationBarDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/15/21 10:57 AM.
//  Copyright © 12/15/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

class TransparentNavgationBarDemo extends StatefulWidget {

  final String? title;

  TransparentNavgationBarDemo({ Key? key, this.title}) : super(key: key);


  @override
  _TransparentNavgationBarDemoState createState() => _TransparentNavgationBarDemoState();
}

class _TransparentNavgationBarDemoState extends State<TransparentNavgationBarDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: Colors.blue,
      body: Stack(
          children: [
            SafeArea(
              child: Container(
                color: Colors.white,
                // padding: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'images/bg.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              child: Container(
                  height: 102,
                  child: AppBar(
                    title: Text("title"),
                    actions: [
                      IconButton(
                        onPressed: (){
                          ddlog("share");
                        },
                        icon: Icon(Icons.share)
                      ),
                    ],
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
          ]
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Text(arguments.toString())
    );
  }

  _buildTopBar() {
  
  }

}



