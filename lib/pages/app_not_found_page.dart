//
//  APPNotFoundPage.dart
//  flutter_templet_project
//
//  Created by shang on 5/20/21 5:31 PM.
//  Copyright © 5/20/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';

class APPNotFoundPage extends StatelessWidget {
  final String? title;

  const APPNotFoundPage({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("404"),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 200.0),
      child: Center(
        child: Column(
          children: <Widget>[
            FractionallySizedBox(
              widthFactor: 0.66,
              child: Hero(
                tag: 'avatar',
                child: Image(
                  image: '404.png'.toAssetImage(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('哎呀, 你的页面跑路了!', style: TextStyle(fontSize: 17.0, color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                DLog.d('哎呀, 你的页面跑路了!');
              },
              child: Text('立即捉它回家!', style: TextStyle(fontSize: 17.0)),
            ),
          ],
        ),
      ),
    );
  }
}
