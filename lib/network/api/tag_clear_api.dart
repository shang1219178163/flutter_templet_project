

import 'dart:convert';

import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/network/base_request_api.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';

// https://doc.yljt.cn/docs/platform//5245

/// 【通用】获取患者标签
class TagClearApi extends BaseRequestAPI{

  TagClearApi({
    this.ownerId,
    this.ownerType,
    this.diseaseDepartmentId,
    this.agencyId,
  });

  /// 对象ID
  String? ownerId;
  /// 对象类型，患者：PUBLIC_USER ，医生：DOCTOR,默认 PUBLIC_USER
  String? ownerType;
  // 医生传 diseaseDepartmentId,护工传agencyId
  String? agencyId;
  /// 机构ID，执业版调用传医生所在的科室ID
  String? diseaseDepartmentId;

  @override
  String get requestURI{
    const url = 'api/yft/disease_course/tags/owner/clear';
    return url;
  }

  @override
  HttpMethod get requestType => HttpMethod.DELETE;

  @override
  Map<String, dynamic> get requestParams{
    final map = <String, dynamic>{};
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
    if (ownerId == null) {
      ToastUtil.info('对象ID 不能为空', needLogin: true);
      return false;
    }

    if (diseaseDepartmentId == null) {
      ToastUtil.info('diseaseDepartmentId 不能为空', needLogin: true);
      return false;
    }
    return true;
  }

}