/// 一轮回复相位：idle → streaming（收流/打字）→ draining（排空缓冲）→ idle
enum AiReplyPhase {
  idle('空闲'),
  streaming('收流中'),
  draining('排空缓冲');

  const AiReplyPhase(this.desc);

  /// 中文描述
  final String desc;
}
