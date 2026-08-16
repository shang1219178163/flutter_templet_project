/// 钉钉机器人通知：发送 markdown 消息，支持加签模式。
library;

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'package:publish_cli/src/logger.dart';

/// 钉钉通知内容
class DingTalkMessage {
  DingTalkMessage({
    required this.title,
    required this.markdown,
  });

  final String title;
  final String markdown;
}

/// 钉钉机器人发送器
class DingTalkNotifier {
  DingTalkNotifier({required this.webhook, this.secret = '', required this.logger});

  final String webhook;
  final String secret;
  final Logger logger;

  /// 发送 markdown 消息
  Future<void> send(DingTalkMessage message) async {
    if (webhook.isEmpty) {
      logger.warn('未配置钉钉 webhook，跳过通知');
      return;
    }
    final uri = _signedUri();
    final body = {
      'msgtype': 'markdown',
      'markdown': {'title': message.title, 'text': message.markdown},
    };

    logger.info('发送钉钉通知...');
    final response = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['errcode'] != 0) {
      throw HttpException('钉钉通知失败: ${data['errmsg'] ?? data}');
    }
    logger.success('钉钉通知已发送');
  }

  /// 加签模式：按时间戳 + secret 生成签名参数
  ///
  /// 注意：sign 不要手动 encodeComponent——`replace(queryParameters:)` 会做百分号编码，
  /// 再 encode 一次会双重编码导致签名校验失败。
  Uri _signedUri() {
    if (secret.isEmpty) {
      return Uri.parse(webhook);
    }
    final timestamp = (DateTime.now().millisecondsSinceEpoch).toString();
    final stringToSign = '$timestamp\n$secret';
    final digest = Hmac(sha256, utf8.encode(secret)).convert(utf8.encode(stringToSign));
    final sign = base64Encode(digest.bytes);
    final uri = Uri.parse(webhook);
    final query = Map<String, String>.from(uri.queryParameters)
      ..['timestamp'] = timestamp
      ..['sign'] = sign;
    return uri.replace(queryParameters: query);
  }
}
