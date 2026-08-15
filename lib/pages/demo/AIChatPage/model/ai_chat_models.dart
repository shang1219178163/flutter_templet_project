/// AI 对话角色
enum AiChatRole {
  /// 用户发送
  user,

  /// 助手回复（流式过程中 content 会持续追加）
  assistant,

  /// 系统提示（预留）
  system,
}

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

/// 一条历史会话（标题取自首条用户消息）
class AiChatSession {
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
}

/// 流式事件类型
enum AiStreamEventKind {
  /// 增量文本
  delta,

  /// 正常结束
  done,

  /// 错误（含服务端 error JSON）
  error,
}

/// 流式数据源统一事件（Mock / SSE 共用）
class AiStreamEvent {
  const AiStreamEvent._(this.kind, {this.delta, this.message});

  factory AiStreamEvent.delta(String text) => AiStreamEvent._(AiStreamEventKind.delta, delta: text);

  factory AiStreamEvent.done() => const AiStreamEvent._(AiStreamEventKind.done);

  factory AiStreamEvent.error(String message) => AiStreamEvent._(AiStreamEventKind.error, message: message);

  final AiStreamEventKind kind;

  /// [AiStreamEventKind.delta] 时的增量内容
  final String? delta;

  /// [AiStreamEventKind.error] 时的错误文案
  final String? message;

  bool get isDone => kind == AiStreamEventKind.done;
}
