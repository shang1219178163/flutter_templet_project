//
//  TagApiController.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/4 08:24.
//  Copyright © 2024/4/4 shang. All rights reserved.
//


import 'package:flutter_templet_project/mixin/dialog_tag_select.dart';
import 'package:flutter_templet_project/network/controller/tag_api_mixin.dart';
import 'package:get/get.dart';


/// 标签管理器
class TagGetxController extends GetxController with TagApiMixin {

  /// 标签列表
  late List<TagDetailModel> _list;
  List<TagDetailModel> get list => _list;
  set list(List<TagDetailModel> value) {
    if (_list == value) {
      return;
    }
    _list = value;
    update();
  }

  /// 新增或者编辑标签操作是否成功
  late bool _isUpdate;
  bool get isUpdate => _isUpdate;
  set isUpdate(bool value) {
    if (_isUpdate == value) {
      return;
    }
    _isUpdate = value;
    update();
  }

  /// 查
  @override
  Future<void> update([List<Object>? ids, bool condition = true]) async {
    if (!Get.isRegistered<TagGetxController>()) {
      return;
    }
    super.update(ids, condition);
  }

  /// 获取标签
  @override
  Future<({bool isSuccess, String message, List<TagDetailModel> list})> requestTagList({
    required String diseaseDepartmentId,
    required String agencyId,
  }) async {
    var tuple = await super.requestTagList(
      diseaseDepartmentId: diseaseDepartmentId,
      agencyId: agencyId,
    );
    list = tuple.list;
    return tuple;
  }

  /// 更新标签
  @override
  Future<({bool isSuccess, String message, bool result})> requestUpdateTag({
    required List<TagDetailModel> selectTags,
    required String? publicUserId,
  }) async {
    final tuple = await super.requestUpdateTag(
      selectTags: selectTags,
      publicUserId: publicUserId,
    );
    isUpdate = tuple.isSuccess && tuple.result;
    return tuple;
  }

}

