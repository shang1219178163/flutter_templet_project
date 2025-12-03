import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_tag_sort_widget.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/pages/demo/tag_sort/NewsCatalogModel.dart';
import 'package:flutter_templet_project/pages/demo/tag_sort/news_home_provider.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:provider/provider.dart';

/// 标签拖拽排序
class TagSortPage extends StatefulWidget {
  const TagSortPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<TagSortPage> createState() => _TagSortPageState();
}

class _TagSortPageState extends State<TagSortPage> with TickerProviderStateMixin {
  final scrollController = ScrollController();

  int acceptedData = 0;

  List<String> tags = List.generate(20, (i) => "标签$i");
  late List<String> others = List.generate(10, (i) => "其他${i + tags.length}");

  late var tabController = TabController(length: tags.length, vsync: this);

  bool canEdit = true;

  late final themeProvider = context.read<ThemeProvider>();

  final newsProvider = NewsHomeProvider();

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    final jsonStr = await rootBundle.loadString("assets/data/catalogs.txt");
    final list = jsonDecode(jsonStr) as List? ?? [];
    final result = list.map((e) => NewsCatalogModel.fromJson(e)).toList();
    await newsProvider.updateCatalogs(result, isSave: true);
    await newsProvider.requestArticleCatalogs();
    DLog.d(newsProvider.catalogs.length);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: newsProvider,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: themeProvider.color242434OrWhite,
          appBar: AppBar(
            title: Text("标签拖拽排序"),
            actions: [
              GestureDetector(
                onTap: () {
                  initData();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.update),
                ),
              )
            ],
          ),
          body: buildBody(),
        );
      },
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              newsProvider.catalogs.length.toString(),
              style: TextStyle(color: Colors.green),
            ),
            buildDragSortWrap(),
            buildWrap(),
          ],
        ),
      ),
    );
  }

  Widget buildDragSortWrap() {
    return NTagSortWidget<NewsCatalogModel>(
      tags: [...newsProvider.mineCatalogs],
      others: [...newsProvider.otherCatalogs],
      onFinish: (tags, others) {
        for (var i = 0; i < tags.length; i++) {
          tags[i].mine = 1;
        }
        for (var i = 0; i < others.length; i++) {
          others[i].mine = 0;
        }
        DLog.d(tags.map((e) => e.toJson()));
        DLog.d(others.map((e) => e.toJson()));
        final sortList = [...tags, ...others];
        newsProvider.updateCatalogs(sortList, isSave: true);
        Navigator.of(context).pop();
      },
    );
  }

  Widget buildWrap() {
    final list = [
      ("保存", onSave),
      ("读取", onRead),
    ];

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final spacing = 8.0;
      final rowCount = 4.0;
      final itemWidth = ((constraints.maxWidth - spacing * (rowCount - 1)) / rowCount).truncateToDouble();

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        // crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...list.map((e) {
            return GestureDetector(
              onTap: e.$2,
              child: Container(
                width: itemWidth,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Text(e.$1),
              ),
            );
          }),
        ],
      );
    });
  }

  Future<void> onSave() async {
    final result = await NewsHomeProvider.instance.saveCatalogs();
  }

  Future<void> onRead() async {
    final list = await NewsHomeProvider.instance.readCatalogs();
    final result = jsonEncode(list);
    DLog.d(result);
  }
}
