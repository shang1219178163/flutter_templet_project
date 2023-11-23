

import 'dart:convert';

import 'package:flutter_templet_project/cache/CacheService.dart';
import 'package:flutter_templet_project/network/base_request_api.dart';
import 'package:flutter_templet_project/vendor/easy_toast.dart';

// https://doc.yljt.cn/docs/platform//5245

/// 【通用】获取患者标签
class TagGetApi extends BaseRequestAPI{

  TagGetApi({
    this.ownerId,
    this.ownerType,
    this.diseaseDepartmentId,
    this.agencyId,
  });

  /// 机构ID，执业版调用传医生所在的科室ID
  String? agencyId;
  /// 对象ID
  String? ownerId;
  /// 对象类型，患者：PUBLIC_USER ，医生：DOCTOR
  String? ownerType;
  /// 机构ID，执业版调用传医生所在的科室ID
  String? diseaseDepartmentId;

  @override
  String get requestURI{
    const url = 'api/yft/disease_course/tags/get';
    return url;
  }

  @override
  HttpMethod get requestType => HttpMethod.GET;

  @override
  Map<String, dynamic> get requestParams{
    final map = <String, dynamic>{};
    if (agencyId != null) {
      map["tagsId"] = agencyId;
    }
    if (ownerId != null) {
      map["ownerId"] = ownerId;
    }
    if (ownerType != null) {
      map["ownerType"] = ownerType;
    }

    map["agencyId"] = diseaseDepartmentId;
    return map;
  }


  bool get validateParamsOld {

    if (diseaseDepartmentId == null) {
      EasyToast.showInfoToast('diseaseDepartmentId 不能为空', needLogin: true);
      return false;
    }

    return true;
  }

}