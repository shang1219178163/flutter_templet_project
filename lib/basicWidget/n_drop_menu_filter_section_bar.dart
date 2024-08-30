//
//  //
//  PatientFilterSectionBar.dart
//  projects
//
//  Created by shang on 2024/8/28 11:17.
//  Copyright © 2024/8/28 shang. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_drop_menu_filter_bar.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/model/section_detail_model.dart';

/// 搜索框加分组选择
class NDropMenuFilterSectionBar extends NDropMenuFilterBar {
  NDropMenuFilterSectionBar({
    super.key,
    super.margin,
    super.padding,
    super.selectedItemVN,
    String placeholder = "请选择分组",
    String Function(String name)? onItemName,
    required ValueChanged<SectionDetailModel> onChanged,
    String searchPlaceholder = "请输入筛选号",
    super.onSearchChanged,
    super.radius,
    BoxConstraints? constraints,
  }) : super(
          values: List.generate(
              19, (i) => SectionDetailModel(id: i.toString(), name: "分组_$i")),
          cbName: (e) => e?.name ?? "",
          equal: (a, b) => a.code == b?.code,
          onItemName: onItemName ?? (name) => "$name${"\t\t" * 3}",
          // onChanged: onChanged,
          onChanged: (e) {
            onChanged(e as SectionDetailModel);
          },
          placeholder: placeholder,
          searchPlaceholder: searchPlaceholder,
          constraints: constraints ?? BoxConstraints(maxHeight: 300),
        );
}
