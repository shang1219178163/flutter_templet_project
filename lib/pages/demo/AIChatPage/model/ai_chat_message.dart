import 'package:flutter_templet_project/pages/demo/AIChatPage/enum/ai_chat_role.dart';

/// 单条聊天消息（content / isStreaming 可变，供流式更新）
class AiChatMessage {
  AiChatMessage({
    required this.id,
    required this.role,
    required this.content,
    this.isStreaming = false,
  });

  /// 本会话内唯一 id
  final String id;
  final AiChatRole role;

  /// 展示文本；流式时由打字缓冲逐步追加
  String content;

  /// 是否仍在流式输出（气泡显示光标）
  bool isStreaming;

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.name,
        'content': content,
      };

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    final roleName = json['role'] as String? ?? 'user';
    final role = AiChatRole.values.asNameMap()[roleName] ?? AiChatRole.user;
    return AiChatMessage(
      id: json['id'] as String? ?? '',
      role: role,
      content: json['content'] as String? ?? '',
    );
  }
}
