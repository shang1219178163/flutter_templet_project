//
//  CopyWithConvert.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/9 09:33.
//  Copyright © 2024/8/9 shang. All rights reserved.
//

import 'package:flutter_templet_project/extension/date_time_ext.dart';
import 'package:flutter_templet_project/extension/src/string_ext.dart';
import 'package:flutter_templet_project/extension/src/type_util.dart';
import 'package:flutter_templet_project/pages/demo/convert/ConvertProtocol.dart';

typedef LineRecord = ({String line, double num, String? comment});

class CopyWithConvert extends ConvertProtocol {
  @override
  String get name => "类生成 CopyWith|merge";

  @override
  String get message => "";

  @override
  String exampleTemplet() {
    return """
class UserModel with SelectableMixin {
  UserModel({
    this.id,
    this.avatar,
    this.name,
    this.nickName,
    this.jobTitle,
    this.email,
    this.address,
    this.phone,
    this.website,
    this.company,
  });

  String? id;
  String? avatar;
  String? name;
  String? nickName;
  String? jobTitle;
  String? email;
  AddressDetailModel? address;
  String? phone;
  String? website;
  Company? company;

  @override
  String get selectableId => id.toString();

  @override
  String get selectableName => name ?? "";

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    name = json['name'];
    nickName = json['nickName'];
    jobTitle = json['jobTitle'];
    email = json['email'];
    address = json['address'] != null
        ? AddressDetailModel.fromJson(json['address'])
        : null;
    phone = json['phone'];
    website = json['website'];
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;

    isSelected = json['isSelected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data['id'] = id;
    data['avatar'] = avatar;
    data['jobTitle'] = jobTitle;
    data['name'] = name;
    data['nickName'] = nickName;
    data['email'] = email;
    data['address'] = address?.toJson();
    data['phone'] = phone;
    data['website'] = website;
    data['company'] = company?.toJson();

    data['isSelected'] = isSelected;
    return data;
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

    final className = content.splitSet(["class ", "with "].toSet())[1].trim();
    final list = content.splitSet(["});", "$className.fromJson("].toSet()).toList();

    final exports = list[1].split("\n").map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    exports.removeWhere((e) {
      final content = e.trim();
      final result =
          content.isEmpty || content.startsWith("@") || content.contains(" get ") || content.startsWith(className);
      return result;
    });

    final propertys = exports.map((e) {
      final list = e.split(" ");
      return (name: list.last.replaceAll(";", ""), type: list.first, comment: "");
    }).toList();

    var clsName = "BigFile";
    var clsNameNew = clsName;

    final fileName = "${clsNameNew.toUncamlCase("_")}_${DateTime.now().toString19()}"
        ".dart";
    final contentNew = _createFileContent(className: className, propertys: propertys);

    return ConvertModel(
      productName: productName,
      name: name ?? clsName,
      content: content,
      nameNew: fileName,
      contentNew: contentNew,
    );
  }

  String _createFileContent({
    required String className,
    required List<PropertyRecord> propertys,
  }) {
    return """
    

extension on $className {    
  @override
  $className copyWith({
${propertys.map((e) => """
\t\t${e.type} ${e.name},
""").join("")}
  }) =>
      $className(
    ${propertys.map((e) => """
      ${e.name}: ${e.name} ?? this.${e.name},
    """).join("")}
      );

  /// 合并
  $className merge($className? val) {
    if (val == null) {
      return this;
    }
    return copyWith(
        ${propertys.map((e) => """
      ${e.name}: val.${e.name},
    """).join("")}
    );
  }
}
    """;
  }
}
