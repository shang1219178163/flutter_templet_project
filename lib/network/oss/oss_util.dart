/*
 * @Author: wangchun 
 * @Date: 2024-05-02 14:49:08 
 * @Last Modified by: wangchun 
 * @Last Modified time: 2024-05-02 14:49:08 
 */

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/upload/image_service.dart';
import 'package:flutter_templet_project/basicWidget/upload/video_service.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/network/oss/oss_auth_api.dart';
import 'package:flutter_templet_project/network/oss/oss_auth_model.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:path/path.dart';

/// OSS 上传工具类
class OssUtil {
  ///授权策略
  static const _policyText =
      '{"expiration": "2120-01-01T12:15:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';

  //进行utf8编码
  static final _policyTextUtf8 = utf8.encode(_policyText);

  //进行base64编码
  static final policy = base64.encode(_policyTextUtf8);

  ///上传图片到阿里云OSS
  static Future<String?> upload({
    required String filePath,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool needCompress = true,
  }) async {
    //获取OSS STS 临时登录凭证
    var api = OssAuthApi();
    var response = await api.fetch();
    if (response['code'] != 'OK') {
      DLog.d("❌OssUtil oss 认证失败!!!");
      return null;
    }
    final result = response['result'] as Map<String, dynamic>? ?? {};
    final ossModel = OssAuthModel.fromJson(result);

    /// 阿里云oss路径
    final url = 'https://${ossModel.bucket}.oss-cn-beijing.aliyuncs.com';

    File file = File(filePath);

    /// 用 package:path/path.dart 库获取图片名称
    String fileName = basename(file.path);

    /// 让阿里云创建一个flutter的文件夹
    fileName = '${ossModel.basePath}/$fileName';

    if (needCompress) {
      final isVideo = GetUtils.isVideo(file.path);
      DLog.d("UploadOss isVideo: $isVideo, ${file.path}");
      file = isVideo
          ? await VideoService.compressVideo(file, showToast: true)
          : await ImageService().compressAndGetFile(file, needLogInfo: false);
    }

    /// sts数据
    final formData = FormData.fromMap({
      'key': fileName,
      'success_action_status': 200,
      'OSSAccessKeyId': ossModel.accessKeyId,
      'policy': policy,
      'Signature': getSignature(ossModel: ossModel),
      'x-oss-security-token': ossModel.securityToken,
      'file': MultipartFile.fromFileSync(file.path, filename: fileName),
    });

    try {
      Dio dio = Dio();
      dio.options.responseType = ResponseType.plain;

      ///通过FormData上传文件
      final resp = await dio.post(
        url,
        data: formData,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      ///图片上传成功
      if (resp.statusCode == 200) {
        ///上传图片成功后，该图片的url
        return '$url/$fileName';
      }
    } catch (e) {
      DLog.d(e);
    }
    return null;
  }

  ///获取阿里云oss的加密参数Signature
  static String getSignature({
    required OssAuthModel ossModel,
  }) {
    assert(ossModel.accessKeySecret != null, "accessKeySecret 不能为空");
    //进行utf8 编码
    final secretUtf8 = utf8.encode(ossModel.accessKeySecret ?? "");

    //进行utf8编码
    final policyUtf8 = utf8.encode(policy);

    //通过hmac,使用sha1进行加密
    List<int> signaturePre = Hmac(sha1, secretUtf8).convert(policyUtf8).bytes;

    //最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signaturePre);

    return signature;
  }
}
