/// 蒲公英上传：调用 v2 接口上传 APK/IPA，返回下载信息。
library;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'logger.dart';

/// 蒲公英上传结果
class PgyerUploadResult {
  PgyerUploadResult({
    required this.downloadUrl,
    required this.buildShortcut,
    required this.buildVersion,
    required this.buildBuildVersion,
    required this.appName,
  });

  /// 下载页短链
  final String downloadUrl;

  /// 下载二维码地址
  final String buildShortcut;

  /// 版本名
  final String buildVersion;

  /// 构建号
  final String buildBuildVersion;

  /// 应用名
  final String appName;
}

/// 蒲公英上传器（v2 API）
class PgyerUploader {
  PgyerUploader({
    required this.apiKey,
    this.updateDescription = '',
    this.installPassword = '',
    required this.logger,
  });

  final String apiKey;
  final String updateDescription;
  final String installPassword;
  final Logger logger;

  static const _uploadApi = 'https://www.pgyer.com/apiv2/app/upload';

  /// 上传 [filePath]，返回解析结果
  Future<PgyerUploadResult> upload(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw FileSystemException('要上传的文件不存在: $filePath');
    }

    logger.info('上传蒲公英: $filePath (${_formatSize(file.lengthSync())})');
    final uri = Uri.parse(_uploadApi);
    final request = http.MultipartRequest('POST', uri)
      ..fields['_api_key'] = apiKey
      ..fields['buildInstallType'] = '1'; // 公开安装
      if (installPassword.isNotEmpty) {
        request.fields['buildPassword'] = installPassword;
      }
      if (updateDescription.isNotEmpty) {
        request.fields['buildUpdateDescription'] = updateDescription;
      }
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        filePath,
        filename: p.basename(filePath),
      ),
    );

    final client = http.Client();
    try {
      final streamed = await client.send(request);
      final response = await http.Response.fromStream(streamed);
      return _parse(response);
    } finally {
      client.close();
    }
  }

  PgyerUploadResult _parse(http.Response response) {
    if (response.statusCode != 200) {
      throw HttpException('蒲公英上传失败，HTTP ${response.statusCode}: ${response.body}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['code'] != 0) {
      throw HttpException('蒲公英上传失败: ${data['message'] ?? data}');
    }
    final d = (data['data'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
    final result = PgyerUploadResult(
      downloadUrl: d['buildShortcut']?.toString() ?? '',
      buildShortcut: d['buildQRCodeURL']?.toString() ?? '',
      buildVersion: d['buildVersion']?.toString() ?? '',
      buildBuildVersion: d['buildBuildVersion']?.toString() ?? '',
      appName: d['buildName']?.toString() ?? '',
    );
    logger.success('蒲公英上传成功: ${result.downloadUrl}');
    return result;
  }

  static String _formatSize(int bytes) {
    const kb = 1024;
    const mb = 1024 * 1024;
    if (bytes >= mb) {
      return '${(bytes / mb).toStringAsFixed(2)} MB';
    }
    if (bytes >= kb) {
      return '${(bytes / kb).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }
}
