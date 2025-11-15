//
//  SectionListView.dart
//  flutter_templet_project
//
//  Created by shang on 10/15/21 3:00 PM.
//  Copyright © 10/15/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';import 'package:flutter_templet_project/extension/extension_local.dart';

//

///抽象封装
class SectionListView<H, E> extends StatefulWidget {
  const SectionListView({
    Key? key,
    this.headerList = const [],
    required this.headerBuilder,
    this.itemList = const [],
    required this.itemBuilder,
  })  : assert(itemList.length == headerList.length),
        super(key: key);

  final List<H> headerList;

  final List<List<E>> itemList;

  final Widget Function(H e) headerBuilder;

  final Widget Function(int section, int row, E e) itemBuilder;

  @override
  _SectionListViewState createState() => _SectionListViewState<H, E>();
}

class _SectionListViewState<H, E> extends State<SectionListView<H, E>> {
  List<Widget> slivers = [];

  @override
  void initState() {
    super.initState();

    _updateSlivers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: CustomScrollView(
        slivers: slivers,
      ),
    );
  }

  Widget buildHeader({required int section, required Widget child}) {
    if (child is SliverToBoxAdapter) {
      return child;
    }
    return SliverToBoxAdapter(
      child: child,
    );
  }

  Widget buildSliverList({required int section, required List<E> list}) {
    final items = widget.itemList[section];
    return SliverList(
      delegate: SliverChildBuilderDelegate((_, int index) => widget.itemBuilder(section, index, items[index]),
          childCount: items.length),
    );
  }

  _updateSlivers() {
    for (var i = 0; i < widget.headerList.length; i++) {
      var headerItem = widget.headerList[i];
      var items = widget.itemList[i];
      slivers.add(buildHeader(
        section: i,
        child: widget.headerBuilder(headerItem),
      ));
      slivers.add(buildSliverList(section: i, list: items.whereType<E>().toList()));
    }
    // DLog.d([widget.sectionTitles.length, slivers.length]);

    setState(() {});
  }
}
