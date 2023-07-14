

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/upload/n_upload_box.dart';
import 'package:flutter_templet_project/uti/color_uti.dart';
import 'package:image_picker/image_picker.dart';

class UploadFileDemo extends StatefulWidget {

  UploadFileDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _UploadFileDemoState createState() => _UploadFileDemoState();
}

class _UploadFileDemoState extends State<UploadFileDemo> {


  final ImagePicker _picker = ImagePicker();

  var selectedAssets = <XFile>[];
  // var selectedModels = <NUploadModel<XFile>>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: (){
            selectedAssets = [];
            setState(() {});
          },
        )).toList(),
      ),
      body: buildBody(),
    );
  }

  buildAppBar({
    required Widget? title,
    List<Widget>? actions
  }) {
    return AppBar(
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
      actions: actions
    );
  }


  buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          NUploadBox(
            items: selectedAssets,
            showFileSize: true,
            onChange: (items){
              debugPrint("items.length: ${items.length}");
            },
          ),
        ],
      ),
    );
  }
}