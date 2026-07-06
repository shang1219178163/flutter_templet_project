import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// 图片选择器
class AssetUploadModel {
  AssetUploadModel({
    required this.entity,
    this.url,
    this.file,
    this.time,
    this.isTakePicture,
    this.extraMap,
    this.errorMap,
  });

  /// 证件占位图
  AssetImage? assetImage;

  AssetEntity? entity;

  /// 上传之后的文件 url
  String? url;

  /// 压缩之后的文件
  File? file;

  /// 上传成功时间
  String? time;

  /// 是否拍照
  bool? isTakePicture;

  /// 额外信息
  Map<String, dynamic>? extraMap;

  /// 错误日志
  Map<String, dynamic>? errorMap;

  /// url 有效
  bool get urlValid => url?.startsWith("http") == true;

  /// 可以再次上传
  bool get againUpload => url?.startsWith("http") != true && entity != null;

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['assetImage'] = assetImage?.assetName;
    data['entity'] = entity;
    data['url'] = url;
    data['file'] = file;
    data['time'] = time;
    data['isTakePicture'] = isTakePicture;
    data['extraMap'] = extraMap;
    data['errorMap'] = errorMap;
    return data;
  }

  clear() {
    entity = null;
    url = null;
    file = null;
    extraMap = null;
    time = null;
  }

  @override
  String toString() {
    return "$runtimeType:${toJson()}";
  }
}
