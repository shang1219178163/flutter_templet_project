//
//  OssAuthModel.dart
//  flutter_templet_project
//
//  Created by shang on 2024/6/21 21:58.
//  Copyright © 2024/6/21 shang. All rights reserved.
//

class OssAuthModel {
  String? accessKeyId;
  String? accessKeySecret;
  String? securityToken;
  String? regionId;
  String? bucket;
  String? basePath;
  int? expiration;

  OssAuthModel({
    this.accessKeyId,
    this.accessKeySecret,
    this.securityToken,
    this.regionId,
    this.bucket,
    this.basePath,
    this.expiration,
  });

  OssAuthModel.fromJson(Map<String, dynamic> json) {
    accessKeyId = json['accessKeyId'];
    accessKeySecret = json['accessKeySecret'];
    securityToken = json['securityToken'];
    regionId = json['regionId'];
    bucket = json['bucket'];
    basePath = json['basePath'];
    expiration = json['expiration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessKeyId'] = accessKeyId;
    data['accessKeySecret'] = accessKeySecret;
    data['securityToken'] = securityToken;
    data['regionId'] = regionId;
    data['bucket'] = bucket;
    data['basePath'] = basePath;
    data['expiration'] = expiration;
    return data;
  }
}
