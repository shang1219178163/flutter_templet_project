//
//  ImConversationDetailModel.dart
//  projects
//
//  Created by shang on 2024/11/18 09:11.
//  Copyright © 2024/11/18 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter_templet_project/cache/cache_service.dart';

import 'package:flutter_templet_project/mixin/equal_identical_mixin.dart';
import 'package:flutter_templet_project/vendor/isar/db_mixin.dart';

/// V2TimConversation
/// 自定义会话模型(用于数据库存储, sdk 类无法标记)

class ImConversationDetailModel with DbMixin, EqualIdenticalMixin {
  ImConversationDetailModel({
    required this.conversationID,
    this.type,
    this.userID,
    this.groupID,
    this.showName,
    this.faceUrl,
    this.groupType,
    this.unreadCount,
    this.lastMessageString,
    this.draftText,
    this.draftTimestamp,
    this.groupAtInfoListString,
    this.isPinned,
    this.recvOpt,
    this.orderkey,
    this.markList,
    this.customData,
    this.conversationGroupList,
    this.c2cReadTimestamp,
    this.groupReadSequence,
    this.loginUserId,
    this.loginAccount,
  });

  @override
  Id get isarId => ("$conversationID,${loginUserId ?? ""}").fastHash;

  /// 当前登录用户id
  String? loginUserId = CacheService().userID;
  String? loginAccount = CacheService().loginAccount;

  late String conversationID;
  int? type;
  String? userID;
  String? groupID;
  String? showName;
  String? faceUrl;
  String? groupType;
  int? unreadCount;

  // V2TimMessage? lastMessage;
  String? lastMessageString;

  String? draftText;
  int? draftTimestamp;
  bool? isPinned;
  int? recvOpt;

  // List<V2TimGroupAtInfo?>? groupAtInfoList = List.empty(growable: true);
  String? groupAtInfoListString;

  int? orderkey;
  List<int?>? markList;
  String? customData;
  List<String?>? conversationGroupList;
  int? c2cReadTimestamp;
  int? groupReadSequence;

  // @ignore
  // V2TimMessage? get lastMessage {
  //   V2TimMessage? lastMessage;
  //   try {
  //     final lastMessageJson = jsonDecode(lastMessageString ?? "");
  //     if (lastMessageJson == null) {
  //       return null;
  //     }
  //     lastMessage = V2TimMessage.fromJson(lastMessageJson);
  //   } catch (e) {
  //     YLog.d("❌ $this lastMessage $e");
  //   }
  //   return lastMessage;
  // }
  //
  // @ignore
  // List<V2TimGroupAtInfo?> get groupAtInfoList {
  //   List<V2TimGroupAtInfo?> groupAtInfoList = List.empty(growable: true);
  //   try {
  //     final List<Map<String, dynamic>> groupAtInfoListJson =
  //         List<Map<String, dynamic>>.from(jsonDecode(groupAtInfoListString ?? "") ?? []);
  //     groupAtInfoList = groupAtInfoListJson.map((e) => V2TimGroupAtInfo.fromJson(e)).toList();
  //   } catch (e) {
  //     YLog.d("❌ $this groupAtInfoList $e");
  //   }
  //   return groupAtInfoList;
  // }
  //
  // /// 转 V2TimConversation
  // V2TimConversation toV2TimConversation() {
  //   // V2TimMessage? lastMessage;
  //   // List<V2TimGroupAtInfo?>? groupAtInfoList = List.empty(growable: true);
  //   // try {
  //   //   final lastMessageJson = jsonDecode(lastMessageString ?? "");
  //   //   lastMessage = V2TimMessage.fromJson(lastMessageJson);
  //   //
  //   //   final List<Map<String, dynamic>> groupAtInfoListJson = jsonDecode(groupAtInfoListString ?? "") ?? [];
  //   //   groupAtInfoList = groupAtInfoListJson.map((e) => V2TimGroupAtInfo.fromJson(e)).toList();
  //   // } catch (e) {
  //   //   YLog.d("$this toV2TimConversation $e");
  //   // }
  //
  //   return V2TimConversation(
  //     conversationID: conversationID,
  //     type: type,
  //     userID: userID,
  //     groupID: groupID,
  //     showName: showName,
  //     faceUrl: faceUrl,
  //     groupType: groupType,
  //     unreadCount: unreadCount,
  //     lastMessage: lastMessage,
  //     draftText: draftText,
  //     draftTimestamp: draftTimestamp,
  //     groupAtInfoList: groupAtInfoList,
  //     isPinned: isPinned,
  //     recvOpt: recvOpt,
  //     orderkey: orderkey,
  //     markList: markList,
  //     customData: customData,
  //     conversationGroupList: conversationGroupList,
  //     c2cReadTimestamp: c2cReadTimestamp,
  //     groupReadSequence: groupReadSequence,
  //   );
  // }

  ImConversationDetailModel.fromJson(Map json) {
    // json = Utils.formatJson(json);
    String? gid = json['groupID'] == "" ? null : json['groupID'];
    String? uid = json['userID'] == "" ? null : json['userID'];
    c2cReadTimestamp = json["c2cReadTimestamp"] ?? 0;
    groupReadSequence = json["groupReadSequence"] ?? 0;
    conversationID = json['conversationID'];
    type = json['type'];
    userID = uid;
    groupID = gid;
    showName = json['showName'];
    faceUrl = json['faceUrl'];
    groupType = json['groupType'];
    unreadCount = json['unreadCount'];
    isPinned = json['isPinned'];
    recvOpt = json['recvOpt'];
    orderkey = json['orderkey'];

    try {
      final lastMessageJson = json['lastMessage'] as Map<String, dynamic>?;
      lastMessageString = jsonEncode(lastMessageJson);
    } catch (e) {
      DLog.d("❌ $this lastMessageString $e");
    }

    draftText = json['draftText'];
    customData = json['customData'];
    draftTimestamp = json['draftTimestamp'];
    if (json['markList'] != null) {
      markList = List.empty(growable: true);
      json['markList'].forEach((v) {
        markList?.add(v);
      });
    }
    if (json['conversationGroupList'] != null) {
      conversationGroupList = List.empty(growable: true);
      json['conversationGroupList'].forEach((v) {
        conversationGroupList?.add(v);
      });
    }

    try {
      final groupAtInfoListItems = (json['groupAtInfoList'] as List<Map<String, dynamic>>? ?? <Map<String, dynamic>>[]);
      groupAtInfoListString = jsonEncode(groupAtInfoListItems);
    } catch (e) {
      DLog.d("❌ $this groupAtInfoListString $e");
    }

    loginUserId ??= CacheService().userID;
    loginAccount ??= CacheService().loginAccount;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['conversationID'] = conversationID;
    data['type'] = type;
    data['userID'] = userID;
    data['groupID'] = groupID;
    data['showName'] = showName;
    data['faceUrl'] = faceUrl;
    data['groupType'] = groupType;
    data['unreadCount'] = unreadCount;
    data['isPinned'] = isPinned;
    data['recvOpt'] = recvOpt;
    data['orderkey'] = orderkey;
    data['customData'] = customData;
    data['c2cReadTimestamp'] = c2cReadTimestamp ?? 0;
    data['groupReadSequence'] = groupReadSequence ?? 0;

    // if (lastMessage != null) {
    //   data['lastMessage'] = lastMessage!.toJson();
    // }
    data['draftText'] = draftText;
    data['draftTimestamp'] = draftTimestamp;

    // if (groupAtInfoList != null) {
    //   data['groupAtInfoList'] = groupAtInfoList!.map((v) => v!.toJson()).toList();
    // }

    if (conversationGroupList != null) {
      data['conversationGroupList'] = conversationGroupList!.map((v) => v).toList();
    }
    if (markList != null) {
      data['markList'] = markList!.map((v) => v).toList();
    }
    data['loginUserID'] = loginUserId;
    data['loginAccount'] = loginAccount;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (other is! ImConversationDetailModel) return false;
    return isarId == other.isarId;
  }

  @override
  int get hashCode => isarId.hashCode;
}
