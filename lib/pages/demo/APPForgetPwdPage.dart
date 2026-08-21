//
//  APPForgetPwdPage.dart
//  flutter_templet_project
//
//  Created by shang on 6/3/21 10:48 AM.
//  Copyright © 6/3/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class APPForgetPwdPage extends StatefulWidget {

  const APPForgetPwdPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _APPForgetPwdPageState createState() => _APPForgetPwdPageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
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
