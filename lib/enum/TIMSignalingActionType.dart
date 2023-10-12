//https://comm.qq.com/im/doc/flutter/zh/SDKAPI/Enum/V2SignalingActionType.html


/// tencent_cloud_chat_sdk 信令操作类型
/// desc 为操作;
/// index 为定义 int 类型;
enum TIMSignalingActionType {
  /// 没有动作 0
  none(""),
  /// 邀请方发起邀请 1
  invite("邀请方发起邀请"),
  /// 邀请方取消邀请 2
  cancel("邀请方取消邀请"),
  /// 被邀请方接受邀请 3
  accept("被邀请方接受邀请"),
  /// 被邀请方拒绝邀请 4
  reject("被邀请方拒绝邀请"),
  /// 邀请超时 5
  timeout("邀请超时");


  const TIMSignalingActionType(this.desc);

  /// 消息类型描述
  final String desc;

}