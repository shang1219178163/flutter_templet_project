//
//  AssetUploadDocumentModel.dart
//  yl_health_app
//
//  Created by shang on 2023/04/30 11:19.
//  Copyright © 2023/04/30 shang. All rights reserved.
//

import 'dart:io';

/// 文档选择器模型
class AssetUploadDocumentModel {
  AssetUploadDocumentModel({
    this.url,
    this.file,
  });

  /// 上传之后的文件 url
  String? url;

  /// 压缩之后的文件
  File? file;

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['url'] = url;
    data['file'] = file?.path;
    return data;
  }
}
