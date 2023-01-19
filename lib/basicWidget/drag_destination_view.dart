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

  DragDestinationView({ Key? key,}) : super(key: key);

  @override
  _DragDestinationViewState createState() => _DragDestinationViewState();
}

class _DragDestinationViewState extends State<DragDestinationView> {

  XFile? file;

  List<XFile> files = [];

  bool dragging = false;

  @override
  Widget build(BuildContext context) {

    return _buildBody();
  }

  _buildBody() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.red)
      ),
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          Stack(
            children: [
              _buildDropTarget(),

              if(file != null) Positioned(
                top: 0,
                right: 0,
                child:
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Container(
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 12
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        files = [];
                        file = null;
                      });
                    },
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _buildDropTarget() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.blue)
      ),
      child: DropTarget(
        child: _buildDraggingShow(file != null),
        onDragDone: (detail) {
          files = detail.files;
          if (files.isEmpty) return;
          // 读取第一个文件
          file = files.first;
          print("file: ${file?.path}_${file?.name}");

          setState(() {});
        },
        onDragEntered: (detail) {
          setState(() {
            dragging = true;
          });
        },
        onDragExited: (detail) {
          setState(() {
            dragging = false;
          });
        },
      ),
    );
  }

  _buildDraggingShow(bool existFile) {
    double iconSize = 75;
    double textWidth = 100;

    Widget icon = existFile ? Image.asset('images/icon_json_file.png', width: iconSize, height: iconSize) : Icon(Icons.undo, size: iconSize,);
    String text = existFile ? file?.name ?? "" : '拖拽文件';

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          // Text(text, style: TextStyle(fontSize: 12)),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: textWidth,
              minWidth: textWidth,
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
          ),
        ]
      ),
    );
  }

}



