import 'dart:io';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// 图片选择器
class AssetUploadModel {
  AssetUploadModel({
    required this.entity,
    this.url,
    this.file,
    this.time,
    this.isTakePicture,
    this.extraInfoMap,
  });

  final AssetEntity? entity;

  /// 上传之后的文件 url
  String? url;

  /// 压缩之后的文件
  File? file;

  /// 上传成功时间
  String? time;

  /// 是否拍照
  bool? isTakePicture;

  /// 额外信息
  Map<String, dynamic>? extraInfoMap;

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['entity'] = entity;
    data['url'] = url;
    data['file'] = file;
    data['time'] = time;
    data['isTakePicture'] = isTakePicture;
    data['extraInfoMap'] = extraInfoMap;
    return data;
  }
}
