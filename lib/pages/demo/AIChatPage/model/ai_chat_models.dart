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
