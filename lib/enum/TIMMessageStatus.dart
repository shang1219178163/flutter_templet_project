


/// 消息状态
enum TIMMessageStatus {
  /// 未知 0
  unknow(""),
  /// 文本消息 1
  sending("消息发送中"),
  /// 自定义消息 2
  succ("消息发送成功"),
  /// 图片消息	3
  fail("消息发送失败"),
  /// 语音消息	4
  hasDeleted("消息被删除"),
  /// 视频消息	5
  localImported("导入到本地的消息"),
  /// 文件消息	6
  localRevoked("被撤回的消息");

  const TIMMessageStatus(this.desc);

  final String desc;

}