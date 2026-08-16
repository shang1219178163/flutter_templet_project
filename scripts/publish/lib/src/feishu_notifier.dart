/// 飞书机器人通知：发送自定义机器人 markdown 消息，支持签名校验。
library;

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'logger.dart';

/// 飞书通知内容
class FeishuMessage {
  FeishuMessage({required this.title, required this.markdown});

  final String title;
  final String markdown;
}

/// 飞书自定义机器人发送器
///
/// 机器人创建时若选择「签名校验」，需提供 [secret]；否则可留空。
/// 请求体与签名规范见飞书开放平台「自定义机器人」文档。
class FeishuNotifier {
  FeishuNotifier({required this.webhook, this.secret = '', required this.logger});

  final String webhook;
  final String secret;
  final Logger logger;

  /// 发送 markdown 消息
  Future<void> send(FeishuMessage message) async {
    if (webhook.isEmpty) {
      logger.warn('未配置飞书 webhook，跳过通知');
      return;
    }

    // 签名：timestamp + "\n" + secret 做 HmacSHA256，取 base64
    final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final sign = _sign(timestamp);
    final body = {
      'timestamp': timestamp,
      'sign': sign,
      'msg_type': 'interactive',
      'card': {
        'config': {'wide_screen_mode': true},
        'header': {
          'title': {'tag': 'plain_text', 'content': message.title},
        },
        'elements': [
          {'tag': 'markdown', 'content': message.markdown},
        ],
      },
    };

    logger.info('发送飞书通知...');
    final uri = Uri.parse(webhook);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(body),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['StatusCode'] != null && data['StatusCode'] != 0) {
      throw HttpException('飞书通知失败: ${data['StatusMessage'] ?? data}');
    }
    if (data['code'] != null && data['code'] != 0) {
      throw HttpException('飞书通知失败: ${data['msg'] ?? data}');
    }
    logger.success('飞书通知已发送');
  }

  String _sign(String timestamp) {
    final stringToSign = '$timestamp\n$secret';
    final digest = Hmac(sha256, utf8.encode(secret)).convert(utf8.encode(stringToSign));
    return base64Encode(digest.bytes);
  }
}
