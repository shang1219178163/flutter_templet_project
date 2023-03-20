//
//  DioUploadService.dart
//  flutter_templet_project
//
//  Created by shang on 3/20/23 9:52 AM.
//  Copyright © 3/20/23 shang. All rights reserved.
//



import 'dart:async';
import 'dart:io';
import 'package:mime/mime.dart';

import 'package:dio/dio.dart';
///这里用来进行Base64编码，UTF-8编码的
import 'dart:convert';
///这里用来获取文件file的文件名称的
import 'package:path/path.dart';
///HMAC-SHA1加密用的（这个是第三方库需要依赖）
import 'package:crypto/crypto.dart';


///阿里云主账号AccessKey拥有所有API的访问权限，风险很高。强烈建议您创建并使用RAM账号进行API访问或日常运维，请登录RAM控制台创建RAM账号。
const String OSSAccessKeyId = '<yourAccessKeyId>';
///用于来生成Signature的
const accessKeySecret = '<yourAccessKeySecret>';

const policy = "{\"expiration\": \"2120-01-01T12:00:00.000Z\",\"conditions\": [[\"content-length-range\", 0, 104857600]]}";

///这里yourBucketName替换成你们的BucketName
///oss-cn-hangzhou： Endpoint以杭州为例，其它Region请按实际情况填写
final String url = 'https://yourBucketName.oss-cn-hangzhou.aliyuncs.com';

class UploadSevice{
  static final UploadSevice _instance = UploadSevice._();
  UploadSevice._();
  factory UploadSevice() => _instance;
  static UploadSevice get instance => _instance;

  ///上传图片到阿里云OSS
  FutureOr<String?> uploadImage(File imgFile) async{
    //查询mime type
    String? mimeType = lookupMimeType(imgFile.path); // 'image/jpeg'
    // 将Policy进行Base64编码
    String encodePolicy = base64Encode(utf8.encode(policy));
    // 生成签名
    String signature = getSignature(encodePolicy);
    // 用 package:path/path.dart 库获取图片名称
    String fileName = basename(imgFile.path);
    // 让阿里云创建一个flutter的文件夹
    fileName = 'flutter/$fileName';
    var formData = FormData.fromMap({
      'key': fileName,
      'success_action_status':200,///如果该域的值设置为200或者204，OSS返回一个空文档和相应的状态码。
      'OSSAccessKeyId': OSSAccessKeyId,
      'policy': encodePolicy,
      'Signature':signature,
      'Content-Type': mimeType ?? 'image/jpeg',
      'file': await MultipartFile.fromFile(imgFile.path),
    });

    Dio dio = Dio();
    var response = await dio.post(url, data: formData,onSendProgress: (int sent, int total){
      printLog('$sent $total');///打印 上传数据的进度
    });
    printLog(response.headers);
    printLog("${response.statusCode} ${response.statusMessage}");
    if(response.statusCode != 200){///图片上传成功
      return null;
    }
    ///上传图片成功后，该图片的url
    String imageUrl = '$url/$fileName';
    return imageUrl;
  }

  ///获取阿里云oss的加密参数Signature
  String getSignature(String encodePolicy){
    var key = utf8.encode(accessKeySecret);
    var bytes = utf8.encode(encodePolicy);

    var hmacSha1 = new Hmac(sha1, key);
    Digest sha1Result = hmacSha1.convert(bytes);
    printLog("sha1Result:$sha1Result");

    String signature = base64Encode(sha1Result.bytes);
    printLog("signature:$signature");
    return signature;
  }

  printLog(Object? object){
    print("${this}: ${object}");
  }
}
