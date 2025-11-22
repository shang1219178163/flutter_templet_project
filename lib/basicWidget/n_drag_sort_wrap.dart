import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class NDragSortWrap<T extends Object> extends StatefulWidget {
  const NDragSortWrap({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onChanged,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, bool isDragging) itemBuilder;
  final void Function(List<T> newList)? onChanged;
  final double spacing;
  final double runSpacing;

  @override
  State<NDragSortWrap<T>> createState() => _NDragSortWrapState<T>();
}

class _NDragSortWrapState<T extends Object> extends State<NDragSortWrap<T>> {
  late List<T> _list;

  @override
  void initState() {
    super.initState();
    _list = List<T>.from(widget.items);
  }

  @override
  void didUpdateWidget(covariant NDragSortWrap<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.items != widget.items) {
    //   _list = List<T>.from(widget.items);
    //   setState(() {});
    // }
    _list = List<T>.from(widget.items);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      children: [
        for (int i = 0; i < _list.length; i++) _buildDraggableItem(context, i),
      ],
    );
  }

  Widget _buildDraggableItem(BuildContext context, int index) {
    final item = _list[index];

    return LongPressDraggable<T>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: widget.itemBuilder(context, item, true),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: widget.itemBuilder(context, item, false),
      ),
      onDragCompleted: () {},
      onDraggableCanceled: (_, __) {},
      child: DragTarget<T>(
        onAcceptWithDetails: (details) {
          final draggedItem = details.data;
          final oldIndex = _list.indexOf(draggedItem);
          final newIndex = index;

          final item = _list.removeAt(oldIndex);
          _list.insert(newIndex, item);
          setState(() {});

          widget.onChanged?.call(_list);
        },
        builder: (context, _, __) {
          return widget.itemBuilder(context, item, false);
        },
      ),
    );
  }
}
