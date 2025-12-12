import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_drag_sort_wrap.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:provider/provider.dart';

/// 标签排序
mixin NTagSortMixin on Object {
  /// 名称
  String get tagName;

  /// 顺序号
  int? _tagOrder;
  int get tagOrder => _tagOrder ?? 0;
  set tagOrder(int value) => _tagOrder = value;

  /// 是否可编辑
  bool? _tagEnable;
  bool get tagEnable => _tagEnable ?? true;
  set tagEnable(bool value) => _tagEnable = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tagOrder'] = tagOrder;
    map['tagName'] = tagName;
    map['tagEnable'] = tagEnable;
    return map;
  }
}

class NTagSortWidget<T extends NTagSortMixin> extends StatefulWidget {
  const NTagSortWidget({
    super.key,
    this.showTab = false,
    required this.tags,
    required this.others,
    required this.onFinish,
    this.onTap,
  });

  final List<T> tags;
  final List<T> others;

  final bool showTab;

  final void Function(List<T> tags, List<T> others) onFinish;

  final void Function(T e)? onTap;

  @override
  State<NTagSortWidget<T>> createState() => _NTagSortWidgetState<T>();
}

class _NTagSortWidgetState<T extends NTagSortMixin> extends State<NTagSortWidget<T>> with TickerProviderStateMixin {
  late List<T> tags = [...widget.tags];
  late List<T> others = [...widget.others];

  late var tabController = TabController(length: tags.length, vsync: this);

  bool canEdit = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final inverseColor = isDark ? Colors.white : Colors.black;

    final bgColor = inverseColor.withOpacity(0.1);
    final titleColor = inverseColor;
    final subtitleColor = titleColor.withOpacity(0.7);

    final actionColor = Color(0xFF999999);

    tabController = TabController(length: tags.length, vsync: this);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showTab)
            Material(
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: TabBar(
                      controller: tabController,
                      isScrollable: true,
                      dividerHeight: 0,
                      tabs: tags.map((e) => Tab(text: e.tagName)).toList(),
                      labelColor: Colors.red,
                      unselectedLabelColor: subtitleColor,
                      indicatorColor: Colors.red,
                      // indicatorSize: TabBarIndicatorSize.label,
                      // indicatorPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      DLog.d("more");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Icon(Icons.keyboard_arrow_down, color: actionColor),
                    ),
                  )
                ],
              ),
            ),
          buildSectionBox(
            titleColor: titleColor,
            subtitleColor: subtitleColor,
            subtitle: !canEdit ? "点击编辑可排序" : "长按拖动可排序",
            onEdit: () {
              if (canEdit) {
                widget.onFinish(tags, others);
              }
              canEdit = !canEdit;
              setState(() {});
            },
          ),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 15),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                const spacing = 8.0;
                const rowCount = 4.0;
                final itemWidth = ((constraints.maxWidth - spacing * (rowCount - 1)) / rowCount).truncateToDouble();

                return NDragSortWrap<T>(
                  spacing: spacing,
                  runSpacing: spacing,
                  items: tags,
                  enableBuilder: (context, item) {
                    return item.tagEnable;
                  },
                  itemBuilder: (context, item, isDragging) {
                    deleteItem() {
                      DLog.d(item.tagName);
                      others.add(item);
                      tags.remove(item);
                      setState(() {});
                    }

                    return GestureDetector(
                      onTap: () {
                        if (canEdit) {
                          deleteItem();
                          return;
                        }
                        widget.onTap?.call(item);
                      },
                      child: buildItem(
                        width: itemWidth,
                        height: 38,
                        bgColor: bgColor,
                        titleColor: titleColor,
                        isDragging: isDragging,
                        item: item,
                        isTopRightVisible: canEdit,
                        topRight: GestureDetector(
                          onTap: deleteItem,
                          child: Icon(Icons.close, size: 12, color: actionColor),
                        ),
                      ),
                    );
                  },
                  onChanged: (newList) {
                    tags = newList;
                    setState(() {});
                  },
                );
              },
            ),
          ),
          buildSectionBox(
            titleColor: titleColor,
            subtitleColor: subtitleColor,
            title: "隐藏频道",
          ),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 15),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                const spacing = 8.0;
                const rowCount = 4.0;
                final itemWidth = ((constraints.maxWidth - spacing * (rowCount - 1)) / rowCount).truncateToDouble();

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    ...others.map(
                      (item) {
                        addItem() {
                          DLog.d(item.tagName);
                          others.remove(item);
                          tags.add(item);
                          setState(() {});
                        }

                        return GestureDetector(
                          onTap: () {
                            if (canEdit) {
                              addItem();
                              return;
                            }
                            widget.onTap?.call(item);
                          },
                          child: buildItem(
                            width: itemWidth,
                            height: 38,
                            bgColor: bgColor,
                            titleColor: titleColor,
                            isDragging: false,
                            item: item,
                            isTopRightVisible: canEdit,
                            topRight: GestureDetector(
                              onTap: addItem,
                              child: Icon(Icons.add, size: 13, color: actionColor),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem({
    double? width,
    double? height,
    required Color bgColor,
    required Color titleColor,
    required bool isDragging,
    required T item,
    bool isTopRightVisible = true,
    required Widget topRight,
  }) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: item.tagEnable ? 1.0 : 0.5,
      child: Badge(
        backgroundColor: Colors.transparent,
        textColor: titleColor,
        offset: Offset(1, -1),
        isLabelVisible: isTopRightVisible && item.tagEnable,
        label: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          child: topRight,
        ),
        smallSize: 18,
        largeSize: 18,
        child: AnimatedContainer(
          width: width,
          height: height,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          alignment: Alignment.center,
          duration: Duration(milliseconds: 150),
          decoration: BoxDecoration(
            // color: isDragging ? Colors.green.withOpacity(0.6) : Colors.green,
            color: bgColor,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            item.tagName,
            style: TextStyle(color: titleColor, fontSize: 13),
          ),
        ),
      ),
    );
  }

  Widget buildSectionBox({
    String title = '我的频道',
    String? subtitle,
    VoidCallback? onEdit,
    required Color titleColor,
    required Color subtitleColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // clipBehavior: Clip.antiAlias,
            // decoration: BoxDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle?.isNotEmpty == true)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      subtitle ?? "",
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Text(
                !canEdit ? '编辑' : '完成',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: !canEdit ? titleColor : Colors.red,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildWrap() {
    final list = List.generate(8, (i) => i);

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final spacing = 8.0;
      final rowCount = 4.0;
      final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        // crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...list.map((e) {
            return Container(
              width: itemWidth,
              height: itemWidth * 1.2,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: Text("card $e"),
            );
          }),
        ],
      );
    });
  }
}
