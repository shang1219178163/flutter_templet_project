

//https://comm.qq.com/im/doc/flutter/zh/SDKAPI/Enum/MessageElemType.html

/// tencent_cloud_chat_sdk 消息类型(将服务端和客户端定义的消息类型进行融合)
/// desc 为服务器端定义类型;
/// index 为客户端定义类型;
enum TIMMessageElemType {
  /// 没有元素 0
  none("TIMNoneElem", ""),
  /// 文本消息 1
  text("TIMTextElem", "文本消息"),
  /// 自定义消息 2
  custom("TIMCustomElem", "自定义消息"),
  /// 图片消息	3
  image("TIMImageElem", "图片消息"),
  /// 语音消息	4
  sound("TIMSoundElem", "语音消息"),
  /// 视频消息	5
  video("TIMVideoFileElem", "视频消息"),
  /// 文件消息	6
  file("TIMFileElem", "文件消息"),
  /// 地理位置消息	7
  location("TIMLocationElem", "地理位置消息"),
  /// 表情消息	8
  face("TIMFaceElem", "表情消息"),
  /// 群 Tips 消息（存消息列表）	9
  groupTips("TIMGroupTipsElem", "群 Tips 消息"),
  /// 合并消息	10
  merger("TIMMergerElem", "合并消息");


  const TIMMessageElemType(this.msgType, this.desc);
  /// 服务器端定义的 MsgType
  final String msgType;
  /// 消息类型描述
  final String desc;
}

