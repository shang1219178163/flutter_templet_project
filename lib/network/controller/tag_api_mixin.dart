//
//  TagApiMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/4 08:24.
//  Copyright © 2024/4/4 shang. All rights reserved.
//


import 'package:flutter_templet_project/mixin/dialog_tag_select.dart';
import 'package:flutter_templet_project/network/api/tag_clear_api.dart';
import 'package:flutter_templet_project/network/api/tag_list_api.dart';
import 'package:flutter_templet_project/network/api/tag_set_api.dart';
import 'package:flutter_templet_project/vendor/easy_toast.dart';


/// 标签API管理器
mixin TagApiMixin<T extends TagDetailModel> {


  /// 获取标签
  Future<({bool isSuccess, String message, List<T> list})> requestTagList({
    required String diseaseDepartmentId,
    required String agencyId,
  }) async {
    var api = TagListApi(
      diseaseDepartmentId: diseaseDepartmentId,
      agencyId: agencyId,
    );
    var tuple = await api.fetchModels<T>(
      onModel: (json) => TagDetailModel.fromJson(json) as T,//dart 泛型传递有问题,必须声明一下
      // onModels: (jsons) => jsons.map((e) => TagDetailModel.fromJson(e) as T).toList(),
    );
    return tuple;
  }

  /// 更新标签
  Future<({bool isSuccess, String message, bool result})> requestUpdateTag({
    required List<T> selectTags,
    required String? publicUserId,
  }) async {
    final tagIds = selectTags.map((e) => e.id ?? "").toList();
    var diseaseDepartmentId = "";
    var agencyId = diseaseDepartmentId;

    final api = tagIds.isEmpty
        ? TagClearApi(
      ownerId: publicUserId,
      ownerType: "PUBLIC_USER",
      agencyId: agencyId,
      diseaseDepartmentId: diseaseDepartmentId,
    )
        : TagSetApi(
      tagsId: tagIds,
      ownerId: publicUserId,
      ownerType: "PUBLIC_USER",
      agencyId: agencyId,
      diseaseDepartmentId: diseaseDepartmentId,
    );
    final tuple = await api.fetchBool(hasLoading: true);
    if (tuple.isSuccess == false) {
      EasyToast.showToast(tuple.message);
    }
    return tuple;
  }

}

