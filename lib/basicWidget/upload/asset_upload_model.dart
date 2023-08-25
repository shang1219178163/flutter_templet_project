


import 'dart:io';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

// uploadUrl

/// 图片选择器
class AssetUploadModel {

  AssetUploadModel({
    required this.entity,
    this.url,
    this.file,
  });

  final AssetEntity? entity;
  /// 上传之后的文件 url
  String? url;
  /// 压缩之后的文件
  File? file;
}
