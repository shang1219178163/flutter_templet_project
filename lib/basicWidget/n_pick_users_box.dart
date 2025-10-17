//
//  PickProjectUsersBox.dart
//  projects
//
//  Created by shang on 2024/9/3 19:20.
//  Copyright © 2024/9/3 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_templet_project/basicWidget/n_pick_request_list_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/model/user_model.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

/// 人员选择盒子
class NPickUsersBox extends NPickRequestListBox<UserModel> {
  NPickUsersBox({
    super.key,
    super.title,
    required super.items,
    required super.onChanged,
  }) : super(
          leading: const SizedBox(),
          requestList: (isRefresh, pageNo, pageSize, search) async {
            // var api = UserListApi(
            //   pageNo: pageNo,
            //   pageSize: pageSize,
            //   name: search,
            // );
            //
            // var tuple = await api.fetchModels<UserModel>(
            //   onValue: (respone) => respone["result"]?["content"],
            //   onModel: (e) => UserModel.fromJson(e),
            // );

            // var list = tuple.result ?? <UserModel>[];
            // YLog.d("$widget requestList: ${list.length}");
            if (isRefresh) {
              return List.generate(pageSize, (index) {
                return UserModel(
                  id: "${1000 + index}",
                  name: 3.generateChars(chars: "张王李赵一二三四"),
                  desc: ["教师", "公务员", "个体户", "消防员"].randomOne,
                );
              });
            }

            var list = List.generate(pageSize, (index) {
              return UserModel(
                id: 10.generateChars(chars: "123456789"),
                name: 3.generateChars(chars: "君子自强不息"),
                desc: [
                  "教师",
                  "公务员",
                  "个体户",
                  "消防员",
                ].randomOne,
              );
            });
            return list;
          },
          onSelectedTap: (e) {
            return e;
          },
          cbName: (e) {
            final realName = e.name ?? "-";
            return realName;
          },
          selected: (items, b) {
            final result = items.map((e) => e.id).contains(b?.id);
            return result;
          },
          nameWidget: (index, model) {
            final name = model.name ?? "-";

            var desc = model.desc ?? "";
            if (desc.isNotEmpty) {
              desc = "（$desc）";
            }

            return Row(
              children: [
                Flexible(
                  child: NText(
                    name,
                    fontSize: 16,
                    color: AppColor.fontColor,
                  ),
                ),
                NText(
                  desc,
                  fontSize: 16,
                  color: AppColor.fontColor999999,
                ),
              ],
            );
          },
        );
}
