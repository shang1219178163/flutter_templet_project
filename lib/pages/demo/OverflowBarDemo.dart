//
//  OverflowBarDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/11/22 5:34 PM.
//  Copyright © 10/11/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class OverflowBarDemo extends StatefulWidget {

  final String? title;

  const OverflowBarDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _OverflowBarDemoState createState() => _OverflowBarDemoState();
}

class _OverflowBarDemoState extends State<OverflowBarDemo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      color: Colors.black.withOpacity(0.15),
      child: Material(
        color: Colors.white,
        elevation: 24,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 128, child: Placeholder()),
                SizedBox(height: 5,),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: OverflowBar(
                    spacing: 8,
                    overflowAlignment: OverflowBarAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {},
                          child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Really Really Cancel'),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('OK'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}


