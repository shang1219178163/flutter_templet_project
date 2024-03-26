//
//  RequestApiTemplet.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/26 14:12.
//  Copyright © 2024/3/26 shang. All rights reserved.
//

/// api 模板
class ApiCreateTemplet{
  
  static String createApi({required String appScheme, required String className,}) {
    return """
    
    
import 'package:$appScheme/http/request_manager.dart';

class $className extends BaseRequestAPI {
  $className({
    this.pageNo = 1,
    this.pageSize = 30,
    this.packageId,
    this.servicePackageName,
    this.doctorName,
  });

  int pageNo;

  int pageSize;

  String? packageId;
  String? servicePackageName;
  String? doctorName;

  @override
  String get requestURI {
    const url = '*';
    return url;
  }

  @override
  HttpMethod get requestType => HttpMethod.POST;

  @override
  Map<String, dynamic> get requestParams {
    final map = <String, dynamic>{};
    map["pageNo"] = pageNo;
    map["pageSize"] = pageSize;
    
    if (packageId != null) {
      map["packageId"] = packageId;
    }
    if (servicePackageName != null) {
      map["servicePackageName"] = servicePackageName;
    }
    if (doctorName != null) {
      map["doctorName"] = doctorName;
    }
    return map;
  }

  /// 使用新的参数校验方法
  @override
  bool get useValidateParamsTuple => true;

  /// 参数校验
  @override
  (bool, String) get validateParamsTuple {
    if (packageId == null) {
      return (false, 'packageId 不能为空');
    }
    if (servicePackageName == null) {
      return (false, 'servicePackageName 不能为空');
    }
    if (doctorName == null) {
      return (false, 'doctorName 不能为空');
    }
    return (true, "");
  }
}  
""";
  }
}
