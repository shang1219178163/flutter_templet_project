/// AI 对话角色
enum AiChatRole {
  /// 用户发送
  user('用户'),

  /// 助手回复（流式过程中 content 会持续追加）
  assistant('助手'),

  /// 系统提示（预留）
  system('系统');

  const AiChatRole(this.desc);

  /// 中文描述
  final String desc;
}
