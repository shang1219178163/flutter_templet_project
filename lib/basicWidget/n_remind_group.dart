//
//  NIndexAvatarGroup.dart
//  yl_health_app
//
//  Created by shang on 2023/12/19 16:13.
//  Copyright © 2023/12/19 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_cross_fade.dart';

/// 提醒列表
class NRemindGroup<T> extends StatefulWidget {
  const NRemindGroup({
    super.key,
    required this.items,
    required this.itemCb,
    this.isFirst = true,
    required this.maxWidth,
    required this.onChanged,
  });

  final List<T> items;

  final String Function(T e) itemCb;

  final bool isFirst;

  final double maxWidth;

  final ValueChanged<T> onChanged;

  @override
  State<NRemindGroup<T>> createState() => _NRemindGroupState<T>();
}

class _NRemindGroupState<T> extends State<NRemindGroup<T>> {
  var isFirst = true;

  late List<T> items = widget.items;

  @override
  void didUpdateWidget(covariant NRemindGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var itemHeight = 35.0;
    var spacing = 8.0;
    var maxWidth = widget.maxWidth;

    final firstChild = Stack(
      children: [
        Container(
          height: itemHeight + spacing * (items.length - 1),
          decoration: BoxDecoration(
              // color: ColorExt.random,
              // border: Border.all(color: Colors.blue),
              ),
        ),
        ...items.map((e) {
          final i = items.indexOf(e);
          final title = widget.itemCb(e);

          return Positioned(
            top: spacing * i,
            child: buildRemindItem(title: title, height: itemHeight, maxWidth: maxWidth),
          );
        })
      ],
    );

    Widget buildSecondChild({required VoidCallback onTap}) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...items.map((e) {
                final i = items.indexOf(e);
                final title = widget.itemCb(e);

                return GestureDetector(
                  onTap: () {
                    onTap();
                    widget.onChanged(e);
                  },
                  child: buildRemindItem(title: title, height: itemHeight),
                );
              })
            ],
          ),
        ),
      );
    }

    return NCrossFade(
      firstChild: (onToggle) => GestureDetector(onTap: onToggle, child: firstChild),
      secondChild: (onToggle) => buildSecondChild(onTap: onToggle),
      isFirst: isFirst,
    );
  }

  Widget buildRemindItem({
    required String title,
    double height = 30,
    double maxWidth = double.infinity,
  }) {
    return Container(
      height: height,
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      margin: EdgeInsets.only(top: 4),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
