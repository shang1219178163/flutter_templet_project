//
//  ApiCreateConvert.dart
//  flutter_templet_project
//
//  Created by shang on 2025/11/15 14:04.
//  Copyright © 2025/11/15 shang. All rights reserved.
//

import 'package:flutter_templet_project/pages/demo/convert/ConvertProtocol.dart';

class ApiCreateConvert extends ConvertProtocol {
  @override
  String get name => "ApiCreate";

  @override
  String exampleTemplet() {
    return """
GET,/v1/article/catalog/query
TagGetApi
TagSetApi
TagClearApi
""";
  }

  // @override
  // Future<ConvertModel?> convertFile({required File file}) async {
  //   final name = file.path.split("/").last;
  //   String content = await file.readAsString();
  //   return convert(content: content, name: name);
  // }

  @override
  Future<ConvertModel?> convert({
    required String productName,
    String? name,
    required String content,
  }) async {
    if (content.isEmpty) {
      return null;
    }
    final lines = content.split("\n").where((e) => e.isNotEmpty).toList();
    var nameNew = name ?? lines.first;
    if (nameNew.contains("/")) {
      nameNew = "${nameNew.splitByLastNumberAndPascal()}Api";
    }
    final contentNew = _createApi(productName: productName, className: nameNew);

    return ConvertModel(
      productName: productName,
      name: name ?? nameNew,
      content: content,
      nameNew: nameNew,
      contentNew: contentNew,
    );
  }

  String _createApi({
    required String productName,
    required String className,
  }) {
    final copyRights = createCopyRights(productName: productName, className: className);
    return """
$copyRights

import '../base_request_api.dart';

/// 
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
    const url = '';
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
