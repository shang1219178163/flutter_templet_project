//
//  PickDrugBoxNew.dart
//  projects
//
//  Created by shang on 2024/9/3 19:20.
//  Copyright © 2024/9/3 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter_templet_project/basicWidget/n_picker_request_list_box'
    '.dart';
import 'package:flutter_templet_project/model/tag_detail_model.dart';
import 'package:flutter_templet_project/network/api/tag_list_api.dart';

/// 网络选择盒子
class PickerDrugBox extends NPickerRequestListBox {
  PickerDrugBox({
    super.key,
    super.title,
    required super.items,
    required super.onChanged,
  }) : super(
          requestList: (isRefresh, pageNo, pageSize, search) async {
            var api = TagListApi(
              pageNo: pageNo,
              pageSize: pageSize,
              search: search,
            );

            var tuple = await api.fetchModels<TagDetailModel>(
              onValue: (respone) => respone["result"]?["content"],
              onModel: (e) => TagDetailModel.fromJson(e),
            );

            final list = tuple.result ?? <TagDetailModel>[];
            // YLog.d("$widget requestList: ${list.length}");
            return list;
          },
          cbName: (e) => e.name,
          equal: (items, b) {
            return false;

            final result = items.map((e) => e.id).contains(b?.id);
            return result;
          },
        );
}
