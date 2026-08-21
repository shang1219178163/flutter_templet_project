//
//  APPForgetPwdPage.dart
//  flutter_templet_project
//
//  Created by shang on 6/3/21 10:48 AM.
//  Copyright © 6/3/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class APPForgetPwdPage extends StatefulWidget {
  final String? title;

  const APPForgetPwdPage({Key? key, this.title}) : super(key: key);

  @override
  _APPForgetPwdPageState createState() => _APPForgetPwdPageState();
}

class _APPForgetPwdPageState extends State<APPForgetPwdPage> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Text(arguments.toString()),
    );
  }
}
