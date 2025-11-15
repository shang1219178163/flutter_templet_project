
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_refresh_indicator.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/type_util.dart';

class CustomRefreshIndicatorDemo extends StatefulWidget {
  const CustomRefreshIndicatorDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<CustomRefreshIndicatorDemo> createState() => _CustomRefreshIndicatorDemoState();
}

class _CustomRefreshIndicatorDemoState extends State<CustomRefreshIndicatorDemo> with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();

  late final tabItems = <TabItemRecord>[
    (title: "List", child: buildListView(), value: Colors.blue),
    (title: "Single", child: buildSingleChildScrollView(), value: Colors.red),
    (title: "Custom", child: buildCustomScrollView(), value: Colors.yellow),
  ];

  late final tabController = TabController(length: tabItems.length, vsync: this);

  @override
  void didUpdateWidget(covariant CustomRefreshIndicatorDemo oldWidget) {
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
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(color: Colors.blue),
          ),
          child: TabBar(
            controller: tabController,
            tabs: tabItems.map((e) => Tab(text: e.title)).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: tabItems.map((e) {
              return buildRefreshIndicator(e: e, child: e.child);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildRefreshIndicator({required TabItemRecord e, required Widget child}) {
    return NRefreshIndicator(
      offsetY: 0,
      onRefresh: onRefresh,
      child: child,
    );
    // return CustomRefreshIndicator(
    //   onRefresh: onRefresh, // Your refresh logic
    //   builder: (context, child, controller) {
    //     final state = controller.state;
    //     final progress = controller.value; // 0~1
    //     const displacement = 50.0; //触发刷新阈值
    //     final childOffset = progress * displacement;
    //
    //     final isLoading = controller.state == IndicatorState.loading;
    //
    //     return Stack(
    //       alignment: AlignmentDirectional.center,
    //       children: [
    //         Transform.translate(
    //           offset: Offset(0, childOffset),
    //           child: child,
    //         ),
    //         if (isLoading)
    //           Positioned(
    //             top: 0,
    //             child: Container(
    //               height: displacement,
    //               padding: const EdgeInsets.all(8.0),
    //               child: Row(
    //                 children: [
    //                   CircularProgressIndicator(
    //                     color: e.value,
    //                     value: controller.state.isLoading ? null : min(controller.value, 1.0),
    //                   ),
    //                   SizedBox(width: 8),
    //                   Text(
    //                     "刷新中...",
    //                     style: TextStyle(color: Colors.black87),
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //       ],
    //     );
    //   },
    //   child: child,
    // );
  }

  Widget buildListView() {
    return Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        itemCount: 30,
        itemBuilder: (_, index) {
          return Container(
            height: 65,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.blue, width: 0.5),
            ),
            child: Text(
              'Item $index',
            ),
          );
        },
      ),
    );
  }

  Widget buildSingleChildScrollView() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Container(
              height: 1000,
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomScrollView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: 1000,
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            // child: buildListView(),
          ),
        )
      ],
    );
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(seconds: 3));
    DLog.d('刷新完成');
  }
}
