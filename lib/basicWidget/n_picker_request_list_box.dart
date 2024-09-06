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
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

class NPickerRequestListBox<E> extends StatefulWidget {
  const NPickerRequestListBox({
    super.key,
    this.title = "请选择",
    this.leading,
    this.placeholder = "搜索",
    required this.items,
    required this.onChanged,
    required this.requestList,
    required this.cbName,
    required this.equal,
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
  final Future<List<E>> Function(
      bool isRefresh, int pageNo, int pageSize, String? search) requestList;

  /// E 转 name
  final String Function(E e) cbName;

  /// 相等对比
  final bool Function(List<E> items, E? b) equal;

  /// 子项卡片自定义
  final Widget Function({int index, E e})? itemBuilder;

  @override
  State<NPickerRequestListBox<E>> createState() =>
      _NPickerRequestListBoxState<E>();
}

class _NPickerRequestListBoxState<E> extends State<NPickerRequestListBox<E>> {
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
              backgroundColor: bgColorF3F3F3,
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
            color: fontColor737373,
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
        return await widget.requestList(isRefresh, page, pageSize, search);
      },
      itemBuilder: (BuildContext context, int index, model) {
        final isSelecetd = widget.equal(widget.items, model);
        final textColor = isSelecetd ? primary : fontColor;
        final color = isSelecetd ? primary : Colors.transparent;

        final name = widget.cbName(model) ?? "--";

        void onTapItem() {
          // YLog.d("${jsonEncode(model.toJson())}");
          selecetdModel = model;
          widget.items.add(model);
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
              title: NText(
                name ?? "",
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
