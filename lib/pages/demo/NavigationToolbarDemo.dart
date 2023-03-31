//
//  NavigationToolbarDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 5:42 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/nn_picker_tool_bar.dart';

class NavigationToolbarDemo extends StatefulWidget {

  final String? title;

  const NavigationToolbarDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _NavigationToolbarDemoState createState() => _NavigationToolbarDemoState();
}

class _NavigationToolbarDemoState extends State<NavigationToolbarDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Column(
          children: [
            _buildBody(),
            Divider(),

            NNPickerToolBar(
              onCancel: (){
                debugPrint("Cancel");
              },
              onConfirm: (){
                debugPrint("onConfirm");
              },
            ),
            Divider(),
          ],
        ),
    );
  }

  _buildBody() {
    return Container(
      height: 50,
      // decoration: BoxDecoration(
      //     border: Border.all(color: Colors.blueAccent)
      // ),
      child: NavigationToolbar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () { debugPrint("leading"); },
        ),
        middle: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () { debugPrint("middle"); },
        ),
        trailing: IconButton(
          icon: Icon(Icons.home),
          onPressed: () { debugPrint("trailing"); },
        ),
      ),
    );
  }
}



