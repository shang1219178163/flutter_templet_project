

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/network/RequestManager.dart';
// import 'package:flutter_templet_project/network/RequestManager.dart';

class NUploadButton extends StatefulWidget {

  NUploadButton({
    Key? key,
    // required this.id,
    required this.path,
    this.url,
    this.urlBlock,
    this.onDelete,
    this.radius = 8,
  }) : super(key: key);


  /// 文件本地路径
  final String path;
  /// 文件网络路径
  final String? url;
  /// 上传成功获取 url 回调
  final ValueChanged<String>? urlBlock;
  /// 返回删除元素的 id
  final VoidCallback? onDelete;
  /// 圆角 默认8
  final double radius;

  @override
  _NUploadButtonState createState() => _NUploadButtonState();
}

class _NUploadButtonState extends State<NUploadButton> {
  /// 防止触发多次上传动作
  var _isLoading = false;
  /// 请求成功或失败
  final _successVN = ValueNotifier(true);
  /// 上传进度
  final _percentVN = ValueNotifier(0.0);

  @override
  void initState() {
    // TODO: implement initState
    onRefresh();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NUploadButton oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    debugPrint("didUpdateWidget:${widget.path == oldWidget.path}");
    if (widget.path == oldWidget.path) {
      // BrunoUtil.showInfoToast("path相同");
      return;
    }

    if (widget.url?.isNotEmpty == true) {
      // BrunoUtil.showInfoToast("url 不为空");
      return;
    }
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final imgChild = ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
      child: Image.file(
        File(widget.path),
        fit: BoxFit.cover,
      )
    );

    if (widget.url?.isNotEmpty == true) {
      debugPrint("url 不为空");
      return imgChild;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, right: 10),
          child: imgChild,
        ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: buildUploading(),
        ),
      ],
    );
  }

  Widget buildUploading() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _successVN,
        _percentVN,
      ]),
      builder: (context, child) {
        if (_successVN.value == false) {
          return buildUploadFail();
        }
        final value = _percentVN.value;
        if (value >= 1) {
          return SizedBox();
        }
        return Container(
          color: Colors.black45,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NText(
                data: value.toStringAsPercent(2),
                fontSize: 16,
                color: Colors.white,
              ),
              NText(
                data: "上传中",
                fontSize: 14,
                color: Colors.white,
              ),
            ],
          ),
        );
      }
    );
  }

  Widget buildUploadFail() {
    return Stack(
      children: [
        InkWell(
          onTap: (){
            debugPrint("onTap");
            onRefresh();
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, color: Colors.red),
                NText(
                  data: "点击重试",
                  fontSize: 14,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: widget.onDelete,
            icon: Icon(Icons.cancel, color: Colors.red,),
          ),
        ),
      ],
    );
  }

  Future<String?> uploadFile({
    required String path,
  }) async {
    // 上传url
    String uploadUrl = 'api/yft/common/oss/upload/stream';
    var res = await RequestManager().upload(uploadUrl, path,
        onSendProgress: (int count, int total){
          _percentVN.value = (count/total);
          // debugPrint("${count}/${total}_${_percentVN.value}_${_percentVN.value.toStringAsPercent(2)}");
        }
    );
    if (res['code'] == 'OK') {
      debugPrint("res: $res");
    }
    return res['result'];
  }

  onRefresh() {
    if (widget.url?.isNotEmpty == true) {
      debugPrint("url 不为空");
      return;
    }
    debugPrint("onRefresh");
    if (_isLoading) {
      debugPrint("_isLoading: $_isLoading");
      return;
    }
    _isLoading = true;
    _successVN.value = true;
    uploadFile(
      path: widget.path,
    ).then((value) {
      if (value?.isNotEmpty == false) {
        _successVN.value = false;
        debugPrint("上传失败:${widget.path}");
        return;
      }
      _successVN.value = true;
      widget.urlBlock?.call(value!);
    }).catchError((err){
      debugPrint("err:${err}");
      _successVN.value = false;
    }).whenComplete(() {
      _isLoading = false;
    });
  }
}
