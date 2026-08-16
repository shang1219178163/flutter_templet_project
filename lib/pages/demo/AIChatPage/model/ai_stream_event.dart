import 'package:flutter_templet_project/pages/demo/AIChatPage/enum/ai_stream_event_kind.dart';

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
