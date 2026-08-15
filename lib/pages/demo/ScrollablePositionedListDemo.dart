import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollablePositionedListDemo extends StatefulWidget {
  const ScrollablePositionedListDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ScrollablePositionedListDemo> createState() => _ScrollablePositionedListDemoState();
}

class _ScrollablePositionedListDemoState extends State<ScrollablePositionedListDemo>
    with SingleTickerProviderStateMixin {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();

  final alignments = <({String title, Alignment alignment})>[
    (title: "top", alignment: Alignment.topCenter),
    (title: "center", alignment: Alignment.center),
    (title: "bottom", alignment: Alignment.bottomCenter),
  ];
  late final alignmentVN = ValueNotifier(alignments.first);

  late final tabController = TabController(length: alignments.length, vsync: this);

  final items = List.generate(100, (i) => "item_$i");

  @override
  void dispose() {
    tabController.removeListener(tabListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabController.addListener(tabListener);
  }

  void tabListener() {
    if (tabController.indexIsChanging) {
      return;
    }
    alignmentVN.value = alignments[tabController.index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text("对齐方式: "),
            Container(
              height: 36,
              child: TabBar(
                controller: tabController,
                isScrollable: true,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black45,
                indicator: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                tabs: alignments.map((e) {
                  return Tab(
                    child: Text(e.title),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        buildHeader(isWrap: false),
        SizedBox(height: 8),
        Expanded(
          child: ScrollablePositionedList.separated(
            itemCount: items.length,
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
            itemBuilder: (context, index) {
              final e = items[index];
              return Container(
                height: 60,
                child: ListTile(
                  title: Text(e),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        ),
      ],
    );
  }

  Widget buildHeader({bool isWrap = true}) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final spacing = 8.0;
        final rowCount = 4.0;
        final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

        if (!isWrap) {
          return Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.transparent,
              // border: Border.all(color: Colors.blue),
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return buildItem(index: index, itemWidth: 100);
              },
              separatorBuilder: (context, index) {
                return VerticalDivider(width: spacing, color: Colors.transparent);
              },
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
          ),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            // crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...items.map((e) {
                final index = items.indexOf(e);
                return buildItem(index: index, itemWidth: itemWidth);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget buildItem({required int index, required double itemWidth}) {
    final e = items[index];
    return GestureDetector(
      onTap: () {
        itemScrollController.onScroll(index: index, alignment: alignmentVN.value.alignment);
      },
      child: Container(
        width: itemWidth,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Align(
          child: Text(
            e,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

extension ItemScrollControllerExt on ItemScrollController {
  /// 滚动
  Future<void> onScroll({
    required int index,
    Alignment alignment = Alignment.topCenter,
  }) async {
    var result = 0.0;
    if (alignment.y == -1) {
      result = 0;
    } else if (alignment.y == 0) {
      result = 0.5;
    } else if (alignment.y >= 1) {
      result = 1.0;
    } else {
      result = alignment.y;
    }
    await scrollTo(
      index: index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: result, // 0.0 顶部，0.5 中间, 1.0 底部
    );
  }
}
