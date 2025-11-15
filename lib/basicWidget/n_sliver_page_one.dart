
import 'package:flutter/material.dart';

class NSliverPageOne extends StatefulWidget {
  const NSliverPageOne({
    super.key,
    this.scrollController,
    this.collapsedHeight = kToolbarHeight,
    this.expandedHeight = 300.0,
    this.tabBarHeight = kToolbarHeight,
    this.backgroundColor,
    this.actions,
    required this.title,
    required this.header,
    required this.body,
    required this.tabBuilder,
  });

  final ScrollController? scrollController;
  final double collapsedHeight;
  final double expandedHeight;
  final double tabBarHeight;

  final Color? backgroundColor;
  final List<Widget>? actions;

  final Widget title;

  final Widget header;
  final Widget Function(BuildContext context, TabBar tab)? tabBuilder;
  final Widget body;

  @override
  State<NSliverPageOne> createState() => _NSliverPageOneState();
}

class _NSliverPageOneState extends State<NSliverPageOne> with SingleTickerProviderStateMixin {
  late final scrollController = widget.scrollController ?? ScrollController();

  List<String> items = List.generate(9, (index) => 'item_$index').toList();
  late final tabController = TabController(length: items.length, vsync: this);

  final opacity = ValueNotifier(0);

  @override
  void didUpdateWidget(covariant NSliverPageOne oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collapsedHeight != widget.collapsedHeight ||
        oldWidget.expandedHeight != widget.expandedHeight ||
        oldWidget.tabBarHeight != widget.tabBarHeight ||
        oldWidget.title != widget.title ||
        oldWidget.header != widget.header ||
        oldWidget.tabBuilder != widget.tabBuilder ||
        oldWidget.body != widget.body) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final collapsedHeight = widget.collapsedHeight ?? kToolbarHeight;
    final expandedHeight = widget.expandedHeight ?? 300.0;
    final tabBarHeight = widget.tabBarHeight ?? kToolbarHeight;

    final tabDefault = TabBar(
      controller: tabController,
      isScrollable: true,
      tabs: items.map((e) => Tab(text: e, height: tabBarHeight)).toList(),
    );

    final appBar = SliverAppBar(
      // title: widget.title,
      pinned: true,
      backgroundColor: widget.backgroundColor,
      collapsedHeight: collapsedHeight,
      expandedHeight: expandedHeight,
      actions: widget.actions,
      flexibleSpace: widget.header,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(tabBarHeight),
        child: widget.tabBuilder?.call(context, tabDefault) ?? tabDefault,
      ),
    );

    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          // SliverOverlapAbsorber(
          //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          //   sliver: appBar,
          // ),
          appBar,
        ];
      },
      body: widget.body,
      // body: TabBarView(
      //   controller: tabController,
      //   children: [
      //     ...items.map((e) {
      //       return Builder(
      //         builder: (context) {
      //           return CustomScrollView(
      //             key: PageStorageKey<String>(e),
      //             slivers: [
      //               // ✅ 每个 tab 内必须是 CustomScrollView 并带 Injector
      //               // SliverOverlapInjector(
      //               //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      //               // ),
      //               SliverList(
      //                 delegate: SliverChildBuilderDelegate(
      //                       (context, index) => ListTile(title: Text('${e} Row #$index')),
      //                   childCount: 30,
      //                 ),
      //               ),
      //             ],
      //           );
      //         },
      //       );
      //     }),
      //   ],
      // ),
    );
  }
}
