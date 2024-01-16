

import 'dart:convert';

import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/network/base_request_api.dart';
import 'package:flutter_templet_project/vendor/easy_toast.dart';


/// 【科室端】标签列表（无分页）
class TagListApi extends BaseRequestAPI{

  TagListApi({
    this.name,
    this.diseaseDepartmentId,
    this.agencyId,
  });

  /// 标签名称
  String? name;
  /// 机构ID，执业版调用传医生所在的科室ID
  String? diseaseDepartmentId;

  String? agencyId;

  @override
  String get requestURI{
    const url = 'api/yft/disease_course/tags/list';
    return url;
  }

  @override
  HttpMethod get requestType => HttpMethod.GET;

  @override
  Map<String, dynamic> get requestParams{
    final map = <String, dynamic>{};
    if (name != null) {
      map["name"] = name;
    }

    map["agencyId"] = diseaseDepartmentId;
    return map;
  }


  bool get validateParamsOld {
    if (diseaseDepartmentId == null) {
      EasyToast.showInfoToast('diseaseDepartmentId 不能为空', needLogin: true);
      return false;
    }
    if (name == null) {
      EasyToast.showInfoToast('name 不能为空', needLogin: true);
      return false;
    }
    return true;
  }

  // (bool, String) get validateParamsNew {
  //   if (diseaseDepartmentId == null) {
  //     return (false, 'diseaseDepartmentId 不能为空');
  //   }
  //   if (name == null) {
  //     return (false, 'name 不能为空');
  //   }
  //   return (true, '');
  // }

  @override
  bool get shouldCache => false;

  String get _cacheKey => requestURI + jsonEncode(requestParams);

  @override
  bool saveJsonOfCache(Map<String, dynamic>? map) {
    return CacheService().setMap(_cacheKey, map) ?? false;
  }

  @override
  Map<String, dynamic>? jsonFromCache() {
    final result = CacheService().getMap(_cacheKey);
    return result;
  }

  @override
  Future<bool>? removeCache(){
    return CacheService().remove(_cacheKey);
  }

}