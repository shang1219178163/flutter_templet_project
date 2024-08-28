//
//  SectionDetailModel.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/28 12:30.
//  Copyright © 2024/8/28 shang. All rights reserved.
//

import 'package:flutter_templet_project/mixin/selectable_mixin.dart';

/// 受试者分组
class SectionRootModel {
  SectionRootModel({
    this.code,
    this.errorCode,
    this.result,
    this.application,
    this.traceId,
    this.message,
  });

  String? code;

  String? errorCode;

  List<SectionDetailModel>? result;

  String? application;

  String? traceId;

  String? message;

  SectionRootModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    code = (json['code'] as String?);
    errorCode = (json['errorCode'] as String?);
    if (json['result'] != null) {
      final array =
          (json['result'] as List).map((e) => SectionDetailModel.fromJson(e));
      result = List<SectionDetailModel>.from(array);
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

/// 受试者分组详情
class SectionDetailModel with SelectableMixin {
  SectionDetailModel({
    this.id,
    this.projectId,
    this.code,
    this.name,
    this.lockStatus,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.subjectUserCount,
  });

  String? id;

  String? projectId;

  String? code;

  String? name;

  String? lockStatus;

  String? createBy;

  int? createTime;

  String? updateBy;

  int? updateTime;

  String? remark;

  int? subjectUserCount;

  /// 是否禁用
  bool get isLockStatus => lockStatus == "Y";

  @override
  String get selectableId => code ?? "";

  @override
  String get selectableName => name ?? "";

  @override
  bool get enable => !isLockStatus;

  SectionDetailModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    id = (json['id'] as String?);
    projectId = (json['projectId'] as String?);
    code = (json['code'] as String?);
    name = (json['name'] as String?);
    lockStatus = (json['lockStatus'] as String?);
    createBy = (json['createBy'] as String?);
    createTime = (json['createTime'] as int?);
    updateBy = (json['updateBy'] as String?);
    updateTime = (json['updateTime'] as int?);
    remark = (json['remark'] as String?);
    subjectUserCount = (json['subjectUserCount'] as int?);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['projectId'] = projectId;
    map['code'] = code;
    map['name'] = name;
    map['lockStatus'] = lockStatus;
    map['createBy'] = createBy;
    map['createTime'] = createTime;
    map['updateBy'] = updateBy;
    map['updateTime'] = updateTime;
    map['remark'] = remark;
    map['subjectUserCount'] = subjectUserCount;

    map['isSelected'] = isSelected;
    return map;
  }
}
