import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/upload/asset_upload_box.dart';
import 'package:flutter_templet_project/basicWidget/upload_document/asset_upload_document_box.dart';
import 'package:flutter_templet_project/basicWidget/upload_document/asset_upload_document_model.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:image_picker/image_picker.dart';

class UploadFileDemo extends StatefulWidget {
  UploadFileDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _UploadFileDemoState createState() => _UploadFileDemoState();
}

class _UploadFileDemoState extends State<UploadFileDemo> {
  /// 初始化数据
  var selectedModels = <AssetUploadDocumentModel>[];

  /// 获取图片链接数组
  List<String> urls = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: fontColor,
          // size: 20,
        ),
        elevation: 0,
        shadowColor: const Color(0xffe4e4e4),
        title: Text(widget.title ?? "$widget"),
        titleTextStyle: const TextTheme(
          titleMedium: TextStyle(
            // headline6 is used for setting title's theme
            color: fontColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ).titleMedium,
        toolbarTextStyle: const TextTheme(
          titleMedium: TextStyle(
            // headline6 is used for setting title's theme
            color: fontColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ).titleMedium,
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: AssetUploadDocumentBox(
              items: selectedModels,
              // showFileSize: true,
              onChanged: (items) {
                selectedModels = items
                    .where((e) => e.url?.startsWith("http") == true)
                    .toList();
                urls = selectedModels.map((e) => e.url ?? "").toList();
              },
            ),
          ),
        ],
      ),
    );
  }
}
