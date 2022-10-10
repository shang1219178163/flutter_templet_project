//
//  SectionListView.dart
//  flutter_templet_project
//
//  Created by shang on 10/15/21 3:00 PM.
//  Copyright © 10/15/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';
// import 'package:flutter_templet_project/extension/ddlog.dart';


///抽象封装
class SectionListView<H, E> extends StatefulWidget {

  /// 表头背景色
  final Color? headerColor;
  /// 内边距
  final EdgeInsetsGeometry? headerPadding;

  final List<H> headerList;

  final List<List<E>> itemList;

  final Widget Function(H e) headerBuilder;

  final Widget Function(int section, int row, E e) itemBuilder;

  SectionListView({
    Key? key,
    this.headerColor,
    this.headerPadding = const EdgeInsets.only(top: 10, bottom: 8, left: 15, right: 15),
    this.headerList = const [],
    required this.headerBuilder,
    this.itemList = const [],
    required this.itemBuilder,
  }) :  assert(itemList.length == headerList.length),
        super(key: key);

  @override
  _SectionListViewState createState() => _SectionListViewState<H,E>();
}

class _SectionListViewState<H, E> extends State<SectionListView<H,E>> {

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
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return _buildBody();
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: slivers,
    );
  }

  Widget _buildHeader({required int section, required Widget child}) {
    return
      SliverToBoxAdapter(
        child: Container(
          color: Color(0xFFDDDDDD),
          padding: widget.headerPadding,
          child: child,
        ),
      );
  }

  Widget _buildSliverList({required int section, required List<E> list}) {
    final items = widget.itemList[section];
    return SliverList(
        delegate: SliverChildBuilderDelegate((_, int index)
        => widget.itemBuilder(section, index, items[index]),
            childCount: items.length),
      );
  }

  _updateSlivers() {
    for(int i = 0; i < widget.headerList.length; i++) {
      var headerItem = widget.headerList[i];
      var items = widget.itemList[i];
      slivers.add(_buildHeader(section: i, child: widget.headerBuilder(headerItem),
      ));
      slivers.add(_buildSliverList(section: i, list: items.whereType<E>().toList()));
    }
    // ddlog([widget.sectionTitles.length, slivers.length]);

    setState(() { });
  }
}

