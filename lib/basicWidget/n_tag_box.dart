//
//  NTagBox.dart
//  flutter_templet_project
//
//  Created by shang on 2023/11/18 11:17.
//  Copyright © 2023/11/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 标签编辑
class NTagBox<E> extends StatelessWidget {
  const NTagBox({
    Key? key,
    this.keywords = "",
    required this.items,
    required this.titleCb,
    required this.onDelete,
    required this.onAdd,
    this.onChanged,
    this.radius = const Radius.circular(8),
    this.tagColor = Colors.blue,
    this.tagAddColor = Colors.deepOrange,
    this.max = 9,
  }) : super(key: key);

  /// 标签主题关键字
  final String keywords;
  final List<E> items;
  final String Function(E e) titleCb;
  final ValueChanged<E> onDelete;
  final VoidCallback onAdd;
  final ValueChanged<List<E>>? onChanged;
  final Radius radius;
  final Color tagColor;
  final Color tagAddColor;
  final int max;

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
        ...items.map((e) {
          return buildTagItem<E>(
            e: e,
            titleCb: titleCb,
            onSelected: (_) {},
            onDelete: (e) {
              onDelete.call(e);
              onChanged?.call(items);
            },
            primaryColor: tagColor,
          );
        }).toList(),
        if (items.length < 9)
          buildTagItem<String>(
            e: "+添加$keywords",
            titleCb: (e) => "+添加$keywords",
            onSelected: (selected) {
              // debugPrint('onSelected: $selected');
              onAdd.call();
              onChanged?.call(items);
            },
            primaryColor: tagAddColor,
          ),
      ]),
    );
  }

  Widget buildTagItem<T>({
    required T e,
    required String Function(T e) titleCb,
    // required StringValueChanged<T> titleCb,
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
        selectedColor: primaryColor,
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
