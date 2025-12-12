//
//  NTagBox.dart
//  flutter_templet_project
//
//  Created by shang on 2023/11/18 11:17.
//  Copyright © 2023/11/18 shang. All rights reserved.
//

///type '((int, String)) => void' is not a subtype of type '((dynamic) => void)?'

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

typedef StringValueChanged<T> = String Function(T value);

/// 标签编辑
class NTagBoxNew<E> extends StatefulWidget {
  const NTagBoxNew({
    Key? key,
    this.keywords = "",
    required this.items,
    required this.titleCb,
    this.canDelete,
    required this.onAdd,
    required this.onChanged,
    this.radius = const Radius.circular(8),
    this.tagColor = Colors.blue,
    this.tagAddColor = Colors.deepOrange,
    this.max = 9,
  }) : super(key: key);

  /// 标签主题关键字
  final String keywords;

  /// 标签内容列表
  final List<E> items;

  /// 标题回调
  // final String Function(E e) titleCb;
  final String Function(dynamic e) titleCb;

  /// 删除拦截
  final bool Function(dynamic value, Function(E e))? canDelete;

  final VoidCallback onAdd;
  // final void Function(List<E> value) onChanged;/// 勿删!!!
  /// 更新会掉
  final void Function(List<dynamic> value) onChanged;

  final Radius radius;
  final Color tagColor;
  final Color tagAddColor;
  final int max;

  @override
  State<NTagBoxNew> createState() => _NTagBoxNewState<E>();
}

class _NTagBoxNewState<E> extends State<NTagBoxNew> {
  @override
  Widget build(BuildContext context) {
    return buildTags();
  }

  Widget buildTags(
      //     {
      //   String keywords = "",
      //   required List<E> items,
      //   required String Function(E e) titleCb,
      //   required ValueChanged<E> onDelete,
      //   required VoidCallback onAdd,
      //   ValueChanged<List<E>>? onDeleteAfter,
      //   Radius radius = const Radius.circular(8),
      //   int max = 9,
      // }
      ) {
    return Container(
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blue),
      ),
      child: Wrap(spacing: 4, runSpacing: 4, children: [
        ...widget.items.map((e) {
          return buildTagItem<E>(
            e: e,
            titleCb: widget.titleCb,
            onSelected: (_) {},
            onDelete: (e) {
              if (widget.canDelete?.call(e, onDelete) != true) {
                return;
              }
              onDelete(e);
            },
            primaryColor: widget.tagColor,
          );
        }).toList(),
        if (widget.items.length < 9)
          buildTagItem<String>(
            e: "+添加${widget.keywords}",
            titleCb: (e) => "+添加${widget.keywords}",
            onSelected: (selected) {
              // debugPrint('onSelected: $selected');
              widget.onAdd.call();
              widget.onChanged.call(widget.items);
              setState(() {});
            },
            primaryColor: widget.tagAddColor,
          ),
      ]),
    );
  }

  onDelete(dynamic e) {
    widget.items.remove(e);
    widget.onChanged.call(widget.items);
    setState(() {});
  }

  Widget buildTagItem<T>({
    required T e,
    // required String Function(T e) titleCb,
    required StringValueChanged<T> titleCb,
    ValueChanged<bool>? onSelected,
    ValueChanged<T>? onDelete,
    Radius radius = const Radius.circular(8),
    Color primaryColor = Colors.blue,
  }) {
    final child = Container(
      padding: const EdgeInsets.only(top: 4, right: 4),
      child: ChoiceChip(
        pressElevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          radius,
        )),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
        onSelected: onSelected,
        selected: true,
        selectedColor: context.primaryColor,
        label: Text(titleCb(e)),
      ),
    );
    if (onDelete == null) {
      return child;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Stack(
        // alignment: Alignment.bottomLeft,
        clipBehavior: Clip.none,
        children: [
          child,
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              onTap: () => onDelete.call(e),
              child: Container(
                decoration: ShapeDecoration(color: Colors.white, shape: CircleBorder()),
                child: Image(
                  image: "icon_delete.png".toAssetImage(),
                  width: 16,
                  height: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
