
import 'package:flutter/material.dart';

class NSliverPage extends StatefulWidget {
  const NSliverPage({
    super.key,
    this.scrollController,
    this.collapsedHeight = kToolbarHeight,
    this.expandedHeight = 300.0,
    this.tabBarHeight = kToolbarHeight,
    required this.title,
    required this.header,
    required this.body,
    required this.tabBuilder,
  });

  final ScrollController? scrollController;
  final double collapsedHeight;
  final double expandedHeight;
  final double tabBarHeight;

  final Widget title;

  final Widget header;
  final Widget Function(BuildContext context, TabBar tab)? tabBuilder;
  final Widget body;

  @override
  State<NSliverPage> createState() => _NSliverPageState();
}

class _NSliverPageState extends State<NSliverPage> with SingleTickerProviderStateMixin {
  late final scrollController = widget.scrollController ?? ScrollController();

  List<String> items = List.generate(9, (index) => 'item_$index').toList();
  late final tabController = TabController(length: items.length, vsync: this);

  final opacity = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final collapsedHeight = widget.collapsedHeight ?? kToolbarHeight;
    final expandedHeight = widget.expandedHeight ?? 300.0;
    final tabBarHeight = widget.tabBarHeight ?? kToolbarHeight;

    final tabDefault = TabBar(
      controller: tabController,
      isScrollable: true,
      tabs: items.map((e) => Tab(text: e)).toList(),
    );

    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              title: widget.title,
              pinned: true,
              collapsedHeight: collapsedHeight,
              expandedHeight: expandedHeight,
              flexibleSpace: Padding(
                padding: EdgeInsets.only(top: 0, bottom: tabBarHeight),
                child: widget.header,
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(tabBarHeight),
                child: widget.tabBuilder?.call(context, tabDefault) ?? tabDefault,
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: tabController,
        children: [
          ...items.map((e) {
            return Builder(
              builder: (context) {
                return CustomScrollView(
                  key: PageStorageKey<String>(e),
                  slivers: [
                    // ✅ 每个 tab 内必须是 CustomScrollView 并带 Injector
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ListTile(title: Text('${e} Row #$index')),
                        childCount: 30,
                      ),
                    ),
                  ],
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
