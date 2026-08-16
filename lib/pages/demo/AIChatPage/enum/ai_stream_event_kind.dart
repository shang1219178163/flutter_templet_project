/// 流式事件类型
enum AiStreamEventKind {
  /// 增量文本
  delta('增量'),

  /// 正常结束
  done('结束'),

  /// 错误（含服务端 error JSON）
  error('错误');

  const AiStreamEventKind(this.desc);

  /// 中文描述
  final String desc;
}
