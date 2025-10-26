//
//  DragAndDropDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/10/22 4:07 PM.
//  Copyright © 10/10/22 shang. All rights reserved.
//

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/drag_destination_view.dart';
import 'package:flutter_templet_project/basicWidget/n_file_viewer/n_file_viewer.dart';
import 'package:flutter_templet_project/basicWidget/n_file_viewer/src/NFileViewer.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/file_ext.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';

class DragAndDropDemo extends StatefulWidget {
  final String? title;

  const DragAndDropDemo({Key? key, this.title}) : super(key: key);

  @override
  _DragAndDropDemoState createState() => _DragAndDropDemoState();
}

class _DragAndDropDemoState extends State<DragAndDropDemo> {
  List<File> fileList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DragDestinationView(
                onChanged: (files) {
                  // fileList = files
                  //     .map((e) {
                  //       final file = File(e.path);
                  //       final content = file.readAsStringSync();
                  //       return content;
                  //     })
                  //     .toList()
                  //     .sorted();

                  fileList = files.map((e) => File(e.path)).toList();
                  DLog.d("files: ${files.map((e) => e.path).join("\n")}");
                  setState(() {});
                  // readFiles(files: files);
                },
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...fileList.map((e) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.blue),
                          ),
                          child: buildFileVier(e: e),
                          // child: NFileViewer(path: e.path),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFileVier({required File e}) {
    return FutureBuilder<String>(
      future: e.readAsString(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        final result = snapshot.data ?? "";

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      e.name,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      FileManager().createFile(fileName: e.name, content: result);
                    },
                    icon: Icon(Icons.download),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(result, softWrap: true),
            ),
          ],
        );
      },
    );
  }

  void readFiles({required List<File> files}) {
    final first = files.first;

    final fileContents = files.map((e) {
      final lines = readContent(e: e).split("\n").map((v) {
        return v.split("-").map((a) => a.trim()).toList();
      }).toList();
      return lines;
    }).toList();

    // final List<String> result = [];

    // for (final e in fileContents[0]) {
    //   for (final f in fileContents[1]) {
    //     final desc = "${e.join("_")} : ${f.join("_")}";
    //     if (e.first == f.first || e.last == f.last || e.first == f.last || e.last == f.first) {
    //       DLog.d("相同歌曲");
    //     } else {
    //       result.add(desc);
    //     }
    //   }
    // }
    // DLog.d(result);
  }

  String readContent({required File e}) {
    if (e.name.endsWith("txt")) {
      final file = File(e.path);
      final content = file.readAsStringSync();
      return content;
    }
    return "";
  }
}
