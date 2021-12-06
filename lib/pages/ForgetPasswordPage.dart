//
//  ForgetPasswordPage.dart
//  flutter_templet_project
//
//  Created by shang on 6/3/21 10:48 AM.
//  Copyright © 6/3/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {

  final String? title;

  ForgetPasswordPage({ Key? key, this.title}) : super(key: key);

  
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {




  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Text(arguments.toString())
    );
  }

}
