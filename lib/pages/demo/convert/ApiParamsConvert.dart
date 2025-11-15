//
//  ApiCreateConvert.dart
//  flutter_templet_project
//
//  Created by shang on 2025/11/15 14:04.
//  Copyright © 2025/11/15 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter_templet_project/model/api_property_model.dart';
import 'package:flutter_templet_project/pages/demo/convert/ConvertProtocol.dart';

/// 请求参数转换
class ApiParamsConvert extends ConvertProtocol {
  @override
  String get name => "ApiParams";

  @override
  String exampleTemplet() {
    return """
{
  "customerId": {
    "type": "integer",
    "format": "int64",
    "description": "被举报用户id"
  },
  "pageNum": {
    "type": "integer",
    "format": "int32",
    "description": "分页页数"
  },
  "pageSize": {
    "type": "integer",
    "format": "int32",
    "description": "分页条数",
    "maximum": 500.0,
    "exclusiveMaximum": false
  },
  "multiMaxOdds": {
    "type": "number",
    "description": "本月串关总倍数"
  },
  "startDate": {
    "type": "string"
  },
  "endDate": {
    "type": "string"
  },
  "commentaryHasApply": {
    "type": "boolean",
    "description": "是否有解说申请"
  },
  "desc": {
    "type": "string",
    "description": "反馈描述"
  },
  "proofList": {
    "type": "array",
    "description": "凭证照片",
    "items": {
      "type": "string"
    },
    "maxItems": 6,
    "minItems": 0
  }
}
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

    try {
      final map = jsonDecode(content) as Map<String, dynamic>;
      final keys = map.keys.toList();
      keys.sort();

      final propertys = <ApiPropertyModel>[];
      for (final name in keys) {
        final e = map[name] ?? {};
        final model = ApiPropertyModel.fromJson(e);
        model.name = name;

        switch (model.type) {
          case "integer":
            {
              model.typeDart = "int?";
              model.typeValidate = [
                "if ((${name} ?? 0) > 0) {",
                "return (false, '${name} 必须大于 0');",
                "}",
              ].join("\n");
            }
            break;
          case "number":
            {
              model.typeDart = "double?";
              model.typeValidate = [
                "if ((${name} ?? 0) > 0) {",
                "return (false, '${name} 必须大于 0');",
                "}",
              ].join("\n");
            }
            break;
          case "boolean":
            {
              model.typeDart = "bool?";
            }
            break;
          case "string":
            {
              model.typeDart = "String?";
              model.typeValidate = [
                "if (${name}?.isNotEmpty != true) {",
                "return (false, '${name} 不能为空');",
                "}",
              ].join("\n");
            }
            break;
          case "array":
            {
              model.typeDart = "List?";
              model.typeValidate = [
                "if (${name}?.isNotEmpty != true) {",
                "return (false, '${name} 不能为空');",
                "}",
              ].join("\n");
            }
            break;
          default:
            break;
        }
        propertys.add(model);
      }

      final initStr = """
      ({${propertys.map((e) {
        return "this.${e.name},";
      }).join("\n")}
      });
      """;

      final propertysStr = propertys.map((e) {
        return [
          "/// ${e.description}",
          "${e.typeDart} ${e.name};",
        ].join("\n");
      }).join("\n");

      final propertysRequestParamsStr = """
      @override
      Map<String, dynamic> get requestParams {
        final map = <String, dynamic>{};
           ${propertys.map((e) {
        return [
          "if (${e.name} != null) {",
          "map['${e.name}'] = ${e.name};",
          "}",
        ].join("\n");
      }).join("\n")}
        return map;
      }

      """;

      final propertysParamsValidateStr = """
      @override
      (bool, String) get validateParams {
      ${propertys.map((e) {
        return e.typeValidate;
      }).join("\n")}
      return (true, "");
      }

      """;

      final result = [
        initStr,
        propertysStr,
        propertysRequestParamsStr,
        propertysParamsValidateStr,
      ].join("\n");

      return ConvertModel(
        productName: productName,
        name: name ?? "UnknownAPI",
        content: content,
        nameNew: name ?? "UnknownAPI",
        contentNew: result,
      );
    } catch (e) {
      DLog.d("$this $e");
    }

    return null;
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
