import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:tuple/tuple.dart';

class ScrollControllerDemoTwo extends StatefulWidget {
  const ScrollControllerDemoTwo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ScrollControllerDemoTwo> createState() => _ScrollControllerDemoTwoState();
}

class _ScrollControllerDemoTwoState extends State<ScrollControllerDemoTwo>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  var initialIndex = 0;

  var items = <Tuple2<Tab, Widget>>[];

  late final tabController = TabController(length: 3, vsync: this);

  @override
  void initState() {
    items = <Tuple2<Tab, Widget>>[
      Tuple2(
        Tab(text: 'NestedScrollView'),
        buildBodyNestedScrollView(),
      ),
      Tuple2(
        Tab(text: 'CustomScrollView'),
        buildPageCustomScrollView(),
      ),
      Tuple2(
        Tab(text: 'buildPage3'),
        buildPage3(),
      ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      initialIndex: initialIndex,
      length: items.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: items.map((e) => e.item1).toList(),
          ),
          title: Text('$widget'),
        ),
        body: TabBarView(
          children: items.map((e) => e.item2).toList(),
        ),
      ),
    );
  }

  Widget buildBodyNestedScrollView() {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverAppBar(
          title: const Text('NestedScrollView'),
          leading: SizedBox(),
          pinned: true,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Colors.green,
              alignment: Alignment.center,
              child: const Text(
                'SliverAppBar',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          bottom: TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
              Tab(text: 'Tab 3'),
            ],
          ),
        ),
      ],
      body: TabBarView(
        controller: tabController,
        children: [
          buildTabView(tab: 1),
          buildTabView(tab: 2),
          buildTabView(tab: 3),
        ],
      ),
    );
  }

  Widget buildTabView({required int tab}) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: 40,
      itemBuilder: (_, i) => ListTile(
        title: Text('Tab $tab - Item $i'),
      ),
    );
  }

  Widget buildPageCustomScrollView() {
    return Scrollbar(
      child: CustomScrollView(
        // physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              color: Colors.green,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => ListTile(title: Text('SliverList Item$i')),
              childCount: 40,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              color: Colors.yellow,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage3() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        image: DecorationImage(
          image: ExtendedNetworkImageProvider(
            AppRes.image.urls[6],
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SizedBox.expand(
        child: DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.25,
          maxChildSize: 1,
          snap: true,
          snapSizes: const [0.4, 1],
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black26,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 顶部拖拽条
                  const SizedBox(height: 12),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 关键：把 controller 交给 ListView
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: 50,
                      itemBuilder: (_, i) {
                        return ListTile(
                          title: Text('Item $i'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildWrap() {
    final list = List.generate(8, (i) => i);

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final spacing = 8.0;
      final rowCount = 4.0;
      final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        child: Wrap(
          spacing: spacing,
          runSpacing: spacing,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...list.map((e) {
              return GestureDetector(
                onTap: () => onTap(e),
                child: Container(
                  width: itemWidth,
                  height: itemWidth * 1.2,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  child: Text("card $e"),
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  void onTap(int i) {}

  @override
  bool get wantKeepAlive => true;
}
