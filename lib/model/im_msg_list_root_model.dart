import 'dart:convert';

import 'package:flutter_templet_project/vendor/isar/db_mixin.dart';

class IMMsgDetailModel with DbMixin {
  IMMsgDetailModel({
    this.restructureMsgBody,
    this.cloudCustomData,
    this.avatar,
    this.nickName,
    this.sequence,
    this.time,
    this.isOwner,
  });

  @override
  Id get isarId => (sequence ?? "").fastHash;

  String? restructureMsgBody;
  String? cloudCustomData;

  String? avatar;
  String? nickName;

  /// 序列号
  String? sequence;

  int? time;

  bool? isOwner;

  /// sequence 对应的 int 值
  int? get seqIntValue {
    if (sequence?.isNotEmpty != true) {
      return null;
    }

    try {
      final result = int.tryParse(sequence ?? "");
      return result;
    } catch (e) {
      DLog.d("$this sequenceIntValue $e");
    }
    return null;
  }

  /// 会话列表时间显示
  /// App 时间显示总结：
  /// 今天之内30分钟之内不显示(自定义卡片没有30分钟的限制)
  /// 今天超过30分钟显示：时分
  /// 超过今天显示：月日：时分
  /// 今年之前的显示： 年月日：时分
  String? get timeDes {
    if (time == null) {
      return null;
    }

    final msgTime = DateTime.fromMillisecondsSinceEpoch((time ?? 0) * 1000);
    var dateStr = msgTime.toString().substring(0, 19);
    final hide = DateTime.now().difference(msgTime).inSeconds <= 60; // 最新60秒内不显示
    if (hide) {
      dateStr = "";
    }
    return dateStr;
  }

  IMMsgDetailModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    restructureMsgBody = json['restructureMsgBody'];
    final restructure = jsonDecode(json['restructureMsgBody']);
    cloudCustomData = json['cloudCustomData'];
    avatar = json['avatar'];
    nickName = json['nickName'];
    sequence = json['sequence'].toString();
    time = json['time'];
    isOwner = json['isOwner'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['restructureMsgBody'] = restructureMsgBody;
    data['cloudCustomData'] = cloudCustomData;
    data['avatar'] = avatar;
    data['nickName'] = nickName;
    data['sequence'] = sequence;
    data['time'] = time;
    data['isOwner'] = isOwner;

    return data;
  }
}
