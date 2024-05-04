//
//  TagChangeNotifier.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/4 10:26.
//  Copyright © 2024/4/4 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/model/tag_detail_model.dart';
import 'package:flutter_templet_project/network/api/tag_clear_api.dart';
import 'package:flutter_templet_project/network/api/tag_list_api.dart';
import 'package:flutter_templet_project/network/api/tag_set_api.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';

/// 标签管理器
class TagViewModel extends ChangeNotifier {
  /// 标签列表
  List<TagDetailModel> _list = [];
  List<TagDetailModel> get list => _list;
  set list(List<TagDetailModel> value) {
    if (_list == value) {
      return;
    }
    _list = value;
    notifyListeners();
  }

  /// 新增或者编辑标签操作是否成功
  bool _isUpdate = false;
  bool get isUpdate => _isUpdate;
  set isUpdate(bool value) {
    if (_isUpdate == value) {
      return;
    }
    _isUpdate = value;
    notifyListeners();
  }

  /// 获取标签
  Future<({bool isSuccess, String message, List<TagDetailModel> result})>
      requestTagList({
    required String departmentId,
  }) async {
    var api = TagListApi(
      departmentId: departmentId,
    );

    // var tuple = await api.fetchList<T>(
    //   onList: (respone){
    //     final result = List<Map<String, dynamic>>.from(response["result"]
    //     ?? []);
    //     return result.map((e) => TagDetailModel.fromJson(e) as T).toList();
    //   },
    // );

    var tuple = await api.fetchModels(
      onValue: (response) =>
          List<Map<String, dynamic>>.from(response["result"] ?? []),
      onModel: (json) => TagDetailModel.fromJson(json), //dart 泛型传递有问题,必须声明一下
    );
    list = tuple.result;
    return tuple;
  }

  /// 更新标签
  Future<({bool isSuccess, String message, bool result})> requestUpdateTag({
    required List<TagDetailModel> selectTags,
    required String? userId,
  }) async {
    final tagIds = selectTags.map((e) => e.id ?? "").toList();
    var departmentId = "";

    final api = tagIds.isEmpty
        ? TagClearApi(
            userId: userId,
            departmentId: departmentId,
          )
        : TagSetApi(
            tagsId: tagIds,
            userId: userId,
            departmentId: departmentId,
          );
    final tuple = await api.fetchBool(hasLoading: true);
    if (tuple.isSuccess == false) {
      ToastUtil.show(tuple.message);
    }
    isUpdate = tuple.isSuccess && tuple.result;
    return tuple;
  }
}
