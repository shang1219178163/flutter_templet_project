

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/upload/n_upload_button.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

import 'package:image_picker/image_picker.dart';


class NUploadFileModel{

  NUploadFileModel(
    this.path,
    this.length,
  );

  String path;

  String length;
}

class NUploadModel<T> {

  NUploadModel({
    // required this.id,
    required this.data,
    this.url,
  });
  // /// 唯一标识符,不能重复
  // String id;
  /// 上传之后的文件 url
  String? url;
  /// 挂载数据,一般是模型
  T data;
}

/// 上传组件
class NUploadBox extends StatefulWidget {

  NUploadBox({
    Key? key,
    required this.items,
    this.maxCount = 9,
    this.rowCount = 4,
    this.spacing = 10,
    this.showFileSize = false,
  }) : super(key: key);

  List<XFile> items;

  int maxCount;

  int rowCount;

  double spacing;

  bool showFileSize;

  @override
  _NUploadBoxState createState() => _NUploadBoxState();
}

class _NUploadBoxState extends State<NUploadBox> {

  final ImagePicker _picker = ImagePicker();

  late final selectedAssets = widget.items ?? <XFile>[];
  // var selectedModels = <NUploadModel<XFile>>[];

  @override
  Widget build(BuildContext context) {
    return photoSection(
      items: widget.items,
      maxCount: widget.maxCount,
      rowCount: widget.rowCount,
      spacing: widget.spacing,
    );
  }

  photoSection({
    List<XFile> items = const [],
    int maxCount = 9,
    int rowCount = 4,
    double spacing = 10,
  }) {
    List<NUploadModel<XFile>> selectedModels = items.map((e){
      return NUploadModel(
        // id: "${items.indexOf(e)}",
        data: e,
      );
    }).toList();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints){
        var itemWidth = ((constraints.maxWidth - spacing * (rowCount - 1))/rowCount).truncateToDouble();
        // print("itemWidth: $itemWidth");
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            ...selectedModels.map((e) {
              // final size = await e.length()/(1024*1024);

              final index = selectedModels.indexOf(e);

              return Container(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: SizedBox(
                        width: itemWidth,
                        height: itemWidth,
                        child: NUploadButton(
                          // id: "$index",
                          path: e.data.path ?? "",
                          urlBlock: (url){
                            e.url = url;
                            // debugPrint("e: ${e.data?.name}_${e.url}");
                            final isAllSuccess = selectedModels.where((e) =>
                            e.url == null).isEmpty;
                            debugPrint("isAllSuccess: ${isAllSuccess}");
                            if (isAllSuccess) {
                              final urls = selectedModels.map((e) => e.url).toList();
                              debugPrint("urls: ${urls}");
                            }
                          },
                          onDelete: (){
                            debugPrint("onDelete: $index");
                          },
                        ),
                      ),
                    ),
                    if(widget.showFileSize)buildLengthInfo(
                      length: e.data.length(),
                    ),
                  ],
                ),
              );
            }).toList(),
            if (items.length < maxCount)
              InkWell(
                onTap: () {
                  onPicker(maxCount: maxCount);
                },
                child: Container(
                  width: itemWidth,
                  height: itemWidth,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    // border: Border.all(width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Icon(Icons.add),
                ),
              )
          ]
        );
      }
    );
  }

  Widget buildLengthInfo({required Future<int> length}) {
    return FutureBuilder<int>(
      future: length,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 请求已结束
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // 请求失败，显示错误
            return Text("Error: ${snapshot.error}");
          }
          // 请求成功，显示数据
          final response = snapshot.data/(1024 *1024);
          final desc = response.toStringAsFixed(2) + "MB";
          return Text(desc);
        } else {
          // 请求未结束，显示loading
          return CircularProgressIndicator();
        }
      },
    );
  }

  onPicker({
    int maxCount = 4,
    // required Function(int length, String result) cb,
  }) async {
    try {
      // 打开相册 - 支持多选
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 50,
      );
      if (images.isEmpty) return;
      if (images.length > maxCount) {
        final tips = '最多上传$maxCount张图片';
        showToast(message: tips);
        // BrunoUtil.showToast(tips);
        return;
      }

      for (var item in images) {
        if (selectedAssets.length < maxCount && !selectedAssets.contains(item)) {
          selectedAssets.add(item);
        }
      }
      debugPrint("selectedAssets:$selectedAssets");
      setState(() {});
    } catch (err) {
      debugPrint("err:$err");
      // BrunoUtil.showToast('$err');
      showToast(message: '$err');
    }
  }

  showToast({required String message}) {
    Text(message).toShowCupertinoDialog(context: context);
  }

}