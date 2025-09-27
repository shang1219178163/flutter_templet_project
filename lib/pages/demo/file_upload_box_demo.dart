//
//  NFileUploadBoxDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/7 11:01.
//  Copyright © 2024/9/7 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/upload_file/n_file_upload_box.dart';
import 'package:flutter_templet_project/basicWidget/upload_file/n_file_upload_model.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/file_ext.dart';
import 'package:get/get.dart';

/// 文件选择demo
class FileUploadBoxDemo extends StatefulWidget {
  const FileUploadBoxDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<FileUploadBoxDemo> createState() => _FileUploadBoxDemoState();
}

class _FileUploadBoxDemoState extends State<FileUploadBoxDemo> {
  bool get hideApp =>
      Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  final fileUploadBoxController = NFileUploadBoxController();
  final isAllUploadFinished = ValueNotifier(false);

  var selectedFiles = [].map((e) => NFileUploadModel(url: e)).toList();

  @override
  void didUpdateWidget(covariant FileUploadBoxDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: NFileUploadBox(
                controller: fileUploadBoxController,
                title: "上传音视频文件",
                description: "支持格式avi、mpeg、mp4、wmv、wav、flv、mov、mkv、rmvb、3gp"
                    "，单个文件大小不超过100m，最多支持10个文件",
                maxCount: 9,
                allowedExtensions: [
                  ...NFileType.audio.exts,
                  ...NFileType.video.exts,
                  ...NFileType.doc.exts,
                  ...NFileType.excel.exts,
                  ...NFileType.ppt.exts,
                  ...NFileType.pdf.exts,
                ],
                items: selectedFiles,
                // showFileSize: true,
                onChanged: (List<NFileUploadModel> value) {
                  selectedFiles = value;
                  DLog.d("$widget selectedFiles: $selectedFiles");
                  isAllUploadFinished.value = true;
                },
                onCancel: () {
                  isAllUploadFinished.value = true;
                },
                onStart: () {
                  isAllUploadFinished.value = false;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
