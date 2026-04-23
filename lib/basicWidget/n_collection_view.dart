//
//  NCollectionViewNew.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/23 10:19.
//  Copyright © 2026/4/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/indicator/n_indicator.dart';

class NCollectionView extends StatefulWidget {
  const NCollectionView({
    super.key,
    required this.length,
    this.rowNum = 2,
    this.numPerRow = 4,
    required this.itemBuilder,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12),
    this.indicatorBottom = 8,
    this.indicatorColor,
    this.indicatorColorActive,
  });

  final int length;

  ///每页行数
  final int rowNum;

  ///每页列数
  final int numPerRow;

  final Widget Function(BuildContext context, int index) itemBuilder;

  /// 水平间距
  final double spacing;

  /// 竖直间距
  final double runSpacing;

  final EdgeInsets? contentPadding;

  /// 指示器距离底部距离
  final double indicatorBottom;
  final Color? indicatorColor;
  final Color? indicatorColorActive;

  @override
  _NCollectionViewStateNew createState() => _NCollectionViewStateNew();
}

class _NCollectionViewStateNew extends State<NCollectionView> with SingleTickerProviderStateMixin {
  final indexVN = ValueNotifier(0);

  late final pageController = PageController(initialPage: indexVN.value, keepPage: true);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///每页数
    int numPerPage = widget.rowNum * widget.numPerRow;
    final num = widget.length ~/ numPerPage;
    final pageCount = widget.length % numPerPage == 0 ? num : num + 1;
    final array = List.generate(pageCount, (i) => i).toList();
    // debugPrint("pageCount: $pageCount, array: $array");

    return Stack(
      children: [
        PageView.builder(
          controller: pageController,
          itemCount: pageCount,
          pageSnapping: true,
          physics: pageCount == 1 ? const NeverScrollableScrollPhysics() : null,
          onPageChanged: (index) {
            indexVN.value = index;
          },
          itemBuilder: (BuildContext context, int pageIndex) {
            return Container(
              padding: widget.contentPadding,
              // alignment: Alignment.center,
              // decoration: BoxDecoration(
              // color: Color(0xffF3F3F3),
              // border: Border.all(color: Colors.blue),
              // ),
              child: LayoutBuilder(builder: (context, constraints) {
                // final spacing = (constraints.maxWidth - itemWidth * numPerRow) /
                //     (numPerRow - 1).truncateToDouble();

                final spacing = widget.spacing;
                final runSpacing = widget.runSpacing;
                final itemWidth =
                    ((constraints.maxWidth - (spacing * (widget.numPerRow - 1))) / widget.numPerRow).truncateToDouble();

                return Wrap(
                  spacing: spacing,
                  runSpacing: runSpacing,
                  // alignment: WrapAlignment.start,
                  children: List.generate(numPerPage, (i) {
                    // final i = items.indexOf(e);
                    final itemIndex = numPerPage * pageIndex + i;
                    // debugPrint("items.length: ${items.length} itemIndex: $itemIndex");
                    if (itemIndex >= widget.length) {
                      return SizedBox();
                    }

                    return SizedBox(
                      width: itemWidth,
                      child: widget.itemBuilder(context, itemIndex),
                    );
                  }).toList(),
                );
              }),
            );
          },
        ),
        if (array.length > 1)
          Positioned(
            bottom: widget.indicatorBottom,
            left: 0,
            right: 0,
            child: NIndicator(
              length: array.length,
              indexListenable: indexVN,
              color: widget.indicatorColor,
              colorActive: widget.indicatorColorActive,
            ),
          ),
      ],
    );
  }
}
