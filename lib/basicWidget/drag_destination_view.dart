//
//  drag_destination_view.dart
//  flutter_templet_project
//
//  Created by shang on 10/10/22 3:38 PM.
//  Copyright © 10/10/22 shang. All rights reserved.
//
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class DragDestinationView extends StatefulWidget {
  const DragDestinationView({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<List<XFile>> onChanged;

  @override
  _DragDestinationViewState createState() => _DragDestinationViewState();
}

class _DragDestinationViewState extends State<DragDestinationView> {
  List<XFile> files = [];

  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.red),
      ),
      child: buildDropTarget(),
    );
  }

  Widget buildDropTarget() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.blue),
      ),
      child: DropTarget(
        onDragDone: (detail) {
          files = detail.files;
          if (files.isEmpty) {
            return;
          }
          // 读取第一个文件
          debugPrint("file: ${files.map((e) => e.path).join("\n")}");
          widget.onChanged(files);
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
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final spacing = 8.0;
      final rowCount = 3.0;
      final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        // crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...files.map((e) {
            return buildDragBox(e);
          }),
        ],
      );
    });
  }

  Widget buildDragBox(XFile? file) {
    var iconSize = 75.0;
    var textWidth = 100.0;

    var icon = file != null
        ? Image.file(
            File(file.path),
            fit: BoxFit.contain,
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return const Icon(
                Icons.file_present,
                size: 48,
                color: Colors.grey,
              );
            },
          )
        : Icon(
            Icons.file_open_outlined,
            size: iconSize,
            color: Colors.black54,
          );
    var text = file != null ? file.name : '拖拽文件';

    return Stack(
      children: [
        Container(
          height: 120,
          width: 100,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Color(0xFFDEDEDE)),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              buildText(textWidth: textWidth, text: text),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: buildDeleteButton(
            onDelete: () {
              files.remove(file);
              setState(() {});
            },
          ),
        )
      ],
    );
  }

  Widget buildDeleteButton({required VoidCallback onDelete}) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: Colors.red,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.remove, color: Colors.white, size: 12),
        onPressed: onDelete,
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
        maxLines: 3,
        overflow: TextOverflow.visible,
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
