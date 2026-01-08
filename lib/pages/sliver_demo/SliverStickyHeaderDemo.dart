import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:get/get.dart';

/// 分组
class SliverStickyHeaderDemo extends StatefulWidget {
  const SliverStickyHeaderDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<SliverStickyHeaderDemo> createState() => _SliverStickyHeaderDemoState();
}

class _SliverStickyHeaderDemoState extends State<SliverStickyHeaderDemo> {
  final scrollController = ScrollController();

  final stickyHeaderController = StickyHeaderController();

  @override
  void didUpdateWidget(covariant SliverStickyHeaderDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final items = List.generate(5, (i) => (index: i, controller: StickyHeaderController()));
    return Scrollbar(
      controller: scrollController,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          ...items.map((e) {
            return _StickyHeaderList(controller: e.controller, index: e.index);
          }),
        ],
      ),
    );
  }
}

class _StickyHeaderList extends StatelessWidget {
  const _StickyHeaderList({
    Key? key,
    this.index,
    this.controller,
  }) : super(key: key);

  final int? index;
  final StickyHeaderController? controller;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      controller: controller,
      header: _Header(index: index),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => ListTile(
            onTap: () {
              debugPrint('tile $i');
            },
            leading: CircleAvatar(
              child: Text('$index'),
            ),
            title: Text('title $i'),
          ),
          childCount: 6,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    this.index,
    this.title,
    this.color = Colors.lightBlue,
  }) : super(key: key);

  final String? title;
  final int? index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('hit $index');
      },
      child: Container(
        height: 45,
        color: color,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          title ?? 'Header $index',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
