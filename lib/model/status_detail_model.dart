//
//  StatusDetailModel.dart
//  yl_gcp_app
//
//  Created by shang on 2024/4/23 12:08.
//  Copyright © 2024/4/23 shang. All rights reserved.
//

import 'package:flutter_templet_project/mixin/selectable_mixin.dart';

class StatusRootModel {
  StatusRootModel({
    this.code,
    this.errorCode,
    this.result,
    this.application,
    this.traceId,
    this.message,
  });

  String? code;

  String? errorCode;

  List<StatusDetailModel>? result;

  String? application;

  String? traceId;

  String? message;

  StatusRootModel.fromJson(Map<String, dynamic> json) {
    code = (json['code'] as String?);
    errorCode = (json['errorCode'] as String?);
    if (json['result'] != null) {
      final array = (json['result'] as List).map((e) => StatusDetailModel.fromJson(e as Map<String, dynamic>));
      result = List<StatusDetailModel>.from(array);
    }
    application = (json['application'] as String?);
    traceId = (json['traceId'] as String?);
    message = (json['message'] as String?);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['errorCode'] = errorCode;
    if (result != null) {
      map['result'] = result!.map((v) => v.toJson()).toList();
    }
    map['application'] = application;
    map['traceId'] = traceId;
    map['message'] = message;
    return map;
  }
}

/// 患者状态详情
class StatusDetailModel with SelectableMixin {
  StatusDetailModel({
    this.id,
    this.orderNum,
    this.appId,
    this.dictCode,
    this.itemKey,
    this.itemValue,
    this.name,
    this.lockStatus,
    this.remark,
    this.scope,
  });

  String? id;
  int? orderNum;
  String? appId;
  String? dictCode;
  String? itemKey;
  String? itemValue;
  String? name;
  String? lockStatus;
  String? remark;
  String? scope;

  @override
  String get selectableId => itemKey ?? "";

  @override
  String get selectableName => name ?? itemValue ?? "";

  StatusDetailModel.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as String?);
    appId = (json['appId'] as String?);
    dictCode = (json['dictCode'] as String?);
    itemKey = (json['itemKey'] as String?);
    itemValue = (json['itemValue'] as String?);
    name = (json['itemValue'] as String?);
    orderNum = (json['orderNum'] as int?);
    lockStatus = (json['lockStatus'] as String?);
    remark = (json['remark'] as Null);
    scope = (json['scope'] as String?);
    isSelected = (json['isSelected']) as bool? ?? false;
  }

  @override
  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['appId'] = appId;
    map['dictCode'] = dictCode;
    map['itemKey'] = itemKey;
    map['itemValue'] = itemValue;
    map['name'] = name;
    map['orderNum'] = orderNum;
    map['lockStatus'] = lockStatus;
    map['remark'] = remark;
    map['scope'] = scope;
    map['isSelected'] = isSelected;
    return map;
  }
}
