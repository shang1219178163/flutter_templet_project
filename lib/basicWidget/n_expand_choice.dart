//
//  NExpandChoice.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/20 14:03.
//  Copyright © 2026/4/20 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NExpandChoice<T> extends StatefulWidget {
  const NExpandChoice({
    super.key,
    required this.title,
    this.leading,
    this.rowCount = 4,
    this.itemHeight,
    this.itemsBackgroudColor,
    this.itemsMargin,
    required this.items,
    required this.itemBuilder,
    this.itemHeader,
    this.itemFooter,
    required this.onChanged,
  });

  final String title;

  final Color? itemsBackgroudColor;
  final EdgeInsets? itemsMargin;
  final List<T> items;

  final Widget Function(T e)? leading;

  final Widget Function(T e) itemBuilder;
  final Widget? itemHeader;
  final Widget? itemFooter;

  final int rowCount;
  final double? itemHeight;

  final ValueChanged<int> onChanged;

  @override
  State<NExpandChoice<T>> createState() => _NExpandChoiceState<T>();
}

class _NExpandChoiceState<T> extends State<NExpandChoice<T>> {
  late var selectedIndex = 0;

  T get current => widget.items[selectedIndex];

  @override
  void didUpdateWidget(covariant NExpandChoice<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        // expansionTileTheme: ExpansionTileThemeData(
        //   iconColor: selectedColor.value,
        //   collapsedIconColor: selectedColor.value,
        // ),
      ),
      child: ExpansionTile(
        leading: widget.leading?.call(current),
        title: Text(widget.title),
        initiallyExpanded: false,
        children: <Widget>[
          if (widget.itemHeader != null) widget.itemHeader!,
          Container(
            padding: widget.itemsMargin ?? EdgeInsets.zero,
            color: widget.itemsBackgroudColor,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final spacing = 8.0;
                final rowCount = widget.rowCount;
                final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

                final list = widget.items;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  // crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ...list.map(
                      (e) {
                        final index = list.indexOf(e);
                        return GestureDetector(
                          onTap: () {
                            selectedIndex = index;
                            widget.onChanged(selectedIndex);
                            setState(() {});
                          },
                          child: SizedBox(
                            width: itemWidth.truncateToDouble(),
                            height: widget.itemHeight ?? itemWidth,
                            child: widget.itemBuilder(e),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          if (widget.itemFooter != null) widget.itemFooter!,
        ],
      ),
    );
  }
}
