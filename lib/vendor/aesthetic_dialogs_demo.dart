import 'dart:async';

import 'package:aesthetic_dialogs/aesthetic_dialogs.dart';
import 'package:flutter/material.dart';


class AestheticDialogsDemo extends StatefulWidget {

  final String? title;

  const AestheticDialogsDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _AestheticDialogsDemoState createState() => _AestheticDialogsDemoState();
}

class _AestheticDialogsDemoState extends State<AestheticDialogsDemo> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> buildDialog() async {
    AestheticDialogs.showDialog(
        title: "My Dialog",
        message: "Hello!!!",
        cancelable: true,
        darkMode: false,
        dialogAnimation: DialogAnimation.IN_OUT,
        dialogGravity: DialogGravity.CENTER,
        dialogStyle: DialogStyle.FLASH,
        dialogType: DialogType.SUCCESS,
        duration: 3000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('AestheticDialogs Flutter'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: buildDialog,
            child: Text("Open Dialog"),
          ),
        ),
    );
  }
}