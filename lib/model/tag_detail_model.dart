


class TagDetailModel {
  TagDetailModel({
    this.id,
    this.createTime,
    this.updateTime,
    this.createBy,
    this.updateBy,
    this.remark,
    this.agencyId,
    this.agencyType,
    this.name,
    this.color,
    this.deleteStatus,
    this.isSelected = false,
  });

  String? id;
  int? createTime;
  int? updateTime;
  String? createBy;
  String? updateBy;
  String? remark;
  String? agencyId;
  String? agencyType;
  String? name;
  String? color;
  String? deleteStatus;

  /// 非接口返回字段
  bool? isSelected = false;

  TagDetailModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    id = json['id'] ?? json['tagsId'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    createBy = json['createBy'];
    updateBy = json['updateBy'];
    remark = json['remark'];
    agencyId = json['agencyId'];
    agencyType = json['agencyType'];
    name = json['name'] ?? json['tagsName'];
    color = json['color'] ?? json['tagsColor'];
    deleteStatus = json['deleteStatus'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['createBy'] = createBy;
    data['updateBy'] = updateBy;
    data['remark'] = remark;
    data['agencyId'] = agencyId;
    data['agencyType'] = agencyType;
    data['name'] = name;
    data['color'] = color;
    data['deleteStatus'] = deleteStatus;
    data['isSelected'] = isSelected;
    return data;
  }
}