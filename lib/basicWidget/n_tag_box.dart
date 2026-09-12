//
//  NTagBox.dart
//  flutter_templet_project
//
//  Created by shang on 2023/11/18 11:17.
//  Copyright © 2023/11/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/generated/assets.dart';

/// 标签编辑：展示标签、删除（可拦截）、添加
///
/// 列表由外部维护；删除经 [onDelete] 外抛，可选 [canDelete] 拦截确认。
class NTagBox<E> extends StatelessWidget {
  const NTagBox({
    super.key,
    this.keywords = '',
    required this.items,
    required this.titleCb,
    required this.onDelete,
    required this.onAdd,
    this.canDelete,
    this.onChanged,
    this.radius = const Radius.circular(8),
    this.tagColor = Colors.blue,
    this.tagAddColor = Colors.deepOrange,
    this.max = 9,
    this.itemBuilder,
    this.itemAddBuilder,
  });

  /// 标签主题关键字（用于「+添加xxx」文案）
  final String keywords;

  /// 标签数据（外部持有）
  final List<E> items;

  /// 标签标题
  final String Function(E e) titleCb;

  /// 确认删除后回调（由外部改列表并刷新）
  final ValueChanged<E> onDelete;

  /// 点击添加
  final VoidCallback onAdd;

  /// 删除拦截：返回 true 立即删除；返回 false 时可稍后调用第二个参数执行删除
  final bool Function(E value, void Function(E e) confirmDelete)? canDelete;

  /// 增删后列表快照（可选）
  final ValueChanged<List<E>>? onChanged;

  final Radius radius;
  final Color tagColor;
  final Color tagAddColor;

  /// 最大标签数，达到后隐藏添加按钮
  final int max;

  final Widget Function(E e)? itemBuilder;
  final Widget Function()? itemAddBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blue),
      ),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          ...items.map((e) {
            return _buildTagItem(
              e: e,
              title: titleCb(e),
              onSelected: (_) {},
              onDelete: (_) => _handleDelete(e),
              primaryColor: tagColor,
            );
          }),
          if (items.length < max)
            _buildAddTagItem<String>(
              e: '+添加$keywords',
              title: '+添加$keywords',
              onSelected: (_) {
                onAdd();
                onChanged?.call(items);
              },
              primaryColor: tagAddColor,
            ),
        ],
      ),
    );
  }

  void _handleDelete(E item) {
    void confirm(E e) {
      onDelete(e);
      onChanged?.call(items);
    }

    if (canDelete != null) {
      if (canDelete!(item, confirm)) {
        confirm(item);
      }
      return;
    }
    confirm(item);
  }

  Widget _buildTagItem({
    required E e,
    required String title,
    ValueChanged<bool>? onSelected,
    ValueChanged<E>? onDelete,
    required Color primaryColor,
  }) {
    final child = Padding(
      padding: const EdgeInsets.only(top: 4, right: 4),
      child: ChoiceChip(
        pressElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(radius),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
        onSelected: onSelected,
        selected: true,
        selectedColor: primaryColor,
        label: itemBuilder?.call(e) ?? Text(title),
      ),
    );

    if (onDelete == null) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: 0,
          top: 0,
          child: InkWell(
            onTap: () => onDelete(e),
            child: Container(
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: CircleBorder(),
              ),
              child: Image(
                image: AssetImage(Assets.imagesIconDelete),
                width: 16,
                height: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddTagItem<T>({
    required T e,
    required String title,
    ValueChanged<bool>? onSelected,
    ValueChanged<T>? onDelete,
    required Color primaryColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, right: 4),
      child: ChoiceChip(
        pressElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(radius),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
        onSelected: onSelected,
        selected: true,
        selectedColor: primaryColor,
        label: itemAddBuilder?.call() ?? Text(title),
      ),
    );
  }
}
