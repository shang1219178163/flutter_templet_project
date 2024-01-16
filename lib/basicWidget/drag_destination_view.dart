//
//  drag_destination_view.dart
//  flutter_templet_project
//
//  Created by shang on 10/10/22 3:38 PM.
//  Copyright © 10/10/22 shang. All rights reserved.
//
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';

class DragDestinationView extends StatefulWidget {

  const DragDestinationView({ Key? key,}) : super(key: key);

  @override
  _DragDestinationViewState createState() => _DragDestinationViewState();
}

class _DragDestinationViewState extends State<DragDestinationView> {

  XFile? file;

  List<XFile> files = [];

  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.red)
      ),
      child: Column(
        children: [
          Stack(
            children: [
              _buildDropTarget(),
              Positioned(
                top: 0,
                right: 0,
                child: buildDeleteButton(),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDropTarget() {
    if (file == null) {
      return SizedBox();
    }
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.blue)
      ),
      child: DropTarget(
        onDragDone: (detail) {
          files = detail.files;
          if (files.isEmpty) {
            return;
          }
          // 读取第一个文件
          file = files.first;
          debugPrint("file: ${file?.path}_${file?.name}");

          setState(() {});
        },
        onDragEntered: (detail) {
          dragging = true;
          setState(() {});
        },
        onDragExited: (detail) {
          dragging = false;
          setState(() {});
        },
        child: _buildDragBox(file),
      ),
    );
  }

  Widget _buildDragBox(XFile? file) {
    var iconSize = 75.0;
    var textWidth = 100.0;

    var icon = file != null ? Image.file(
        File(file.path),
        fit: BoxFit.contain,
    )  : Icon(Icons.undo, size: iconSize,);
    var text = file != null ? (file.name ?? "") : '拖拽文件';

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          // Text(text, style: TextStyle(fontSize: 12)),
          buildText(textWidth: textWidth, text: text),
        ]
      ),
    );
  }

  Widget buildDeleteButton() {
    return CircleAvatar(
      radius: 12,
      backgroundColor: Colors.blue,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.remove,
          color: Colors.white,
          size: 12
        ),
        onPressed: () {
          setState(() {
            files = [];
            file = null;
          });
        },
      ),
    );
  }

  Widget buildText({double textWidth = 0.0, String text = ""}) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 200,
        minWidth: textWidth,
        minHeight: 20,
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        softWrap:true,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
        ),
      ) ,
    );
  }

}



