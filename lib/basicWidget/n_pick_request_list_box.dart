//
//  PickDrugBox.dart
//  projects
//
//  Created by shang on 2024/9/3 19:20.
//  Copyright © 2024/9/3 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_app_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_refresh_view.dart';
import 'package:flutter_templet_project/basicWidget/n_search_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';

/// 基于接口的搜索选择列表(子类实现 PickerDrugBox)
class NPickRequestListBox<E> extends StatefulWidget {
  const NPickRequestListBox({
    super.key,
    this.title = "请选择",
    this.leading,
    this.placeholder = "搜索",
    required this.items,
    required this.onChanged,
    required this.requestList,
    this.onSelectedTap,
    required this.cbName,
    required this.selected,
    this.nameWidget,
    this.itemBuilder,
  });

  /// 标题
  final String title;

  /// leading 自定义
  final Widget? leading;

  /// 提示语
  final String placeholder;

  /// 默认值
  final List<E> items;

  /// 回调
  final ValueChanged<List<E>> onChanged;

  /// 请求列表
  final Future<List<E>> Function(bool isRefresh, int pageNo, int pageSize, String? search) requestList;

  /// 选择
  final E Function(E e)? onSelectedTap;

  /// E 转 name
  final String Function(E e) cbName;

  final Widget Function(int index, E e)? nameWidget;

  /// 相等对比
  final bool Function(List<E> items, E? b) selected;

  /// 子项卡片自定义
  final Widget Function({int index, E e})? itemBuilder;

  @override
  State<NPickRequestListBox<E>> createState() => _NPickRequestListBoxState<E>();
}

class _NPickRequestListBoxState<E> extends State<NPickRequestListBox<E>> {
  final refreshViewController = NRefreshViewController<E>();

  var search = "";

  E? selecetdModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: NAppBar(
        backgroundColor: Colors.white,
        titleStr: widget.title,
        leadingWidth: 70,
        leading: widget.leading ??
            buildLeading(
              title: "取消",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
      ),
      body: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 12,
            ),
            child: NSearchBar(
              placeholder: widget.placeholder,
              backgroundColor: AppColor.bgColorF3F3F3,
              onChanged: (val) {
                search = val;
                refreshViewController.onRefresh();
              },
              // onCancel: () {
              //   Get.back();
              // },
            ),
          ),
          Expanded(
            child: buildBody(),
          ),
        ],
      ),
    );
  }

  Widget buildLeading({
    required String title,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
            // color: Colors.green,
            // border: Border.all(color: Colors.blue),
            ),
        child: const Text(
          "取消",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: AppColor.fontColor737373,
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return buildSubPage();
  }

  Widget buildSubPage() {
    final primary = context.primaryColor;
    return NRefreshView<E>(
      controller: refreshViewController,
      pageSize: 30,
      onRequest: (bool isRefresh, int page, int pageSize, last) async {
        return widget.requestList(isRefresh, page, pageSize, search);
      },
      itemBuilder: (BuildContext context, int index, model) {
        final isSelected = widget.selected(widget.items, model);
        final textColor = isSelected ? primary : AppColor.fontColor;
        final color = isSelected ? primary : Colors.transparent;

        final name = widget.cbName(model);

        void onTapItem() {
          // YLog.d("${jsonEncode(model.toJson())}");
          selecetdModel = model;
          final modelNew = widget.onSelectedTap?.call(model) ?? model;
          widget.items.add(modelNew);
          widget.onChanged(widget.items);
          Navigator.of(context).pop();
        }

        if (widget.itemBuilder != null) {
          return GestureDetector(
            onTap: onTapItem,
            child: widget.itemBuilder?.call(index: index, e: model),
          );
        }

        return Column(
          children: [
            ListTile(
              dense: true,
              onTap: onTapItem,
              title: widget.nameWidget?.call(index, model) ??
                  NText(
                    name,
                    fontSize: 16,
                    color: textColor,
                  ),
              trailing: Icon(Icons.check, color: color),
            ),
            const Divider(indent: 15, endIndent: 15),
          ],
        );
      },
    );
  }
}
