//
//  NFilterSection.dart
//  yl_health_app_v2.20.5
//
//  Created by shang on 2024/4/9 18:28.
//  Copyright © 2024/4/9 shang. All rights reserved.
//

import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/app_color.dart';

class NFilterSection<T> extends StatefulWidget {
  NFilterSection({
    super.key,
    required this.title,
    this.isSingle = true,
    this.isExpand = false,
    this.collapseCount = 6,
    required this.items,
    required this.cbID,
    required this.cbName,
    required this.cbSelected,
    this.itemBuilder,
    this.onChanged,
    this.onSingleChanged,
  });

  /// 标题
  final String title;

  final bool isSingle;

  /// 默认展开还是收起
  final bool isExpand;

  /// 最小折叠数量
  final int collapseCount;

  final List<T> items;

  final String Function(T) cbID;
  final String Function(T) cbName;
  final bool Function(T) cbSelected;

  /// 子项样式自定义
  final Widget? Function(T e, bool isSelected)? itemBuilder;

  /// 单选回调
  final ValueChanged<T?>? onSingleChanged;

  /// 多选回调
  final ValueChanged<List<T>>? onChanged;

  @override
  State<NFilterSection<T>> createState() => _NFilterSectionState<T>();
}

class _NFilterSectionState<T> extends State<NFilterSection<T>> {
  late bool isExpand = widget.isExpand;

  @override
  void didUpdateWidget(covariant NFilterSection<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ids = widget.items.map((e) => widget.cbID(e)).join(",");
    final oldWidgetIds = oldWidget.items.map((e) => widget.cbID(e)).join(",");
    if (ids != oldWidgetIds) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final models = widget.items;
    if (models.isEmpty) {
      return const SizedBox();
    }
    final disable = (models.length <= widget.collapseCount);

    return StatefulBuilder(builder: (context, setState) {
      final items = isExpand ? models : models.take(widget.collapseCount).toList();

      return buildExpandMenu(
        title: widget.title,
        disable: disable,
        isExpand: isExpand,
        onExpansionChanged: (val) {
          isExpand = !isExpand;
          setState(() {});
        },
        childrenHeader: (isExpanded, onTap) => Column(
          children: [
            NChoiceBox<T>(
              isSingle: true,
              itemColor: Colors.transparent,
              items: items
                  .map((e) => ChoiceBoxModel<T>(
                        id: widget.cbID(e),
                        title: widget.cbName(e),
                        isSelected: widget.cbSelected(e),
                        data: e,
                      ))
                  .toList(),
              onChanged: (value) {
                if (widget.isSingle) {
                  final tmp = value.isEmpty ? null : value.first.data;
                  widget.onSingleChanged?.call(tmp);
                } else {
                  var tmp = value.map((e) => e.data!).where((e) => e != null).toList();
                  widget.onChanged?.call(tmp);
                }
              },
              itemBuilder: widget.itemBuilder,
            ),
          ],
        ),
        children: [],
      );
    });
  }

  Widget buildExpandMenu({
    required String title,
    List<Widget>? children,
    bool isExpand = true,
    ValueChanged<bool>? onExpansionChanged,
    Color color = const Color(0xff737373),
    bool disable = false,
    ExpansionWidgetBuilder? header,
    ExpansionWidgetBuilder? childrenHeader,
    ExpansionWidgetBuilder? childrenFooter,
  }) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: EnhanceExpansionTile(
        header: header,
        childrenHeader: childrenHeader,
        childrenFooter: childrenFooter,
        tilePadding: const EdgeInsets.symmetric(horizontal: 0),
        trailing: buildExpandMenuTrailing(
          isExpand: isExpand,
          color: color,
          borderColor: color.withOpacity(0.2),
          hide: disable,
        ),
        collapsedTextColor: AppColor.fontColor,
        textColor: AppColor.fontColor,
        iconColor: color,
        collapsedIconColor: color,
        title: Text(
          title,
          style: TextStyle(
            color: AppColor.fontColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        initiallyExpanded: disable ? false : isExpand,
        onExpansionChanged: onExpansionChanged,
        children: children ?? <Widget>[Container()],
      ),
    );
  }

  buildExpandMenuTrailing({
    bool isExpand = true,
    Color color = Colors.blueAccent,
    Color borderColor = Colors.blueAccent,
    bool hide = false,
  }) {
    if (hide) {
      return const SizedBox();
    }

    final tuple = isExpand ? (title: "收起", image: "icon_arrow_up.png") : (title: "展开", image: "icon_arrow_down.png");

    return Container(
      padding: const EdgeInsets.only(left: 12, right: 6, top: 4, bottom: 4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tuple.title,
            style: TextStyle(color: color, fontSize: 12),
          ),
          const SizedBox(width: 4),
          Image(
            image: tuple.image.toAssetImage(),
            width: 10,
            height: 10,
          ),
        ],
      ),
    );
  }
}
