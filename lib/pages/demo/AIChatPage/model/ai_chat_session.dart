import 'package:flutter_templet_project/pages/demo/AIChatPage/model/ai_chat_message.dart';

/// 一条历史会话（标题取自首条用户消息）
class AiChatSession {

  factory AiChatSession.fromJson(Map<String, dynamic> json) {
    final raw = json['messages'];
    final list = <AiChatMessage>[];
    if (raw is List) {
      for (final e in raw) {
        if (e is Map) {
          list.add(AiChatMessage.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    return AiChatSession(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '新会话',
      messages: list,
      updatedAtMs: json['updatedAtMs'] as int? ?? 0,
    );
  }
  AiChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.updatedAtMs,
  });

  final String id;

  /// 列表展示标题
  String title;

  /// 会话内消息快照
  List<AiChatMessage> messages;

  /// 最后更新时间（毫秒）
  int updatedAtMs;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'updatedAtMs': updatedAtMs,
        'messages': messages.map((e) => e.toJson()).toList(),
      };
}
