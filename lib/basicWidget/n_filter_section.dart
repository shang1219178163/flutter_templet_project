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
import 'package:flutter_templet_project/util/color_util.dart';


class NFilterSection<T> extends StatefulWidget {
  NFilterSection({
    super.key,
    this.title = "分组",
    this.isExpand = false,
    this.collapseCount = 6,
    required this.items,
    required this.cbID,
    required this.cbName,
    required this.cbSelected,
    required this.onChanged,
  });

  /// 标题
  final String title;

  /// 默认展开还是收起
  final bool isExpand;

  /// 最小折叠数量
  final int collapseCount;

  final List<T> items;

  final String Function(T) cbID;
  final String Function(T) cbName;
  final bool Function(T) cbSelected;
  final ValueChanged<T?> onChanged;

  @override
  State<NFilterSection<T>> createState() => _NFilterSectionState<T>();
}

class _NFilterSectionState<T> extends State<NFilterSection<T>> {
  final _scrollController = ScrollController();

  late bool isExpand = widget.isExpand;

  final weChatTitleColor = Color(0xff1A1A1A);


  @override
  Widget build(BuildContext context) {
    final models = widget.items;
    if (models.isEmpty) {
      return const SizedBox();
    }
    final disable = (models.length <= widget.collapseCount);

    return StatefulBuilder(builder: (context, setState) {
      final items =
      isExpand ? models : models.take(widget.collapseCount).toList();

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
                final tmp = value.isEmpty ? null : value.first.data;
                widget.onChanged(tmp);
              },
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
        collapsedTextColor: fontColor,
        textColor: fontColor,
        iconColor: color,
        collapsedIconColor: color,
        title: Text(
          title,
          style: TextStyle(
            color: weChatTitleColor,
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

    final tuple =
    isExpand ? ("收起", "icon_arrow_up.png") : ("展开", "icon_arrow_down.png");

    return Container(
      padding: const EdgeInsets.only(left: 12, right: 6, top: 4, bottom: 4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tuple.$1,
            style: TextStyle(color: color, fontSize: 12),
          ),
          const SizedBox(
            width: 4,
          ),
          Image(
            image: tuple.$2.toAssetImage(),
            width: 10,
            height: 10,
          ),
        ],
      ),
    );
  }
}
