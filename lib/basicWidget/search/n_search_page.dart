//
//  NSearchPage.dart
//  projects
//
//  Created by shang on 2026/4/13 17:24.
//  Copyright © 2026/4/13 shang. All rights reserved.
//

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_back_button.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/search/n_search_bar_view.dart';
import 'package:flutter_templet_project/basicWidget/search/n_search_history.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

// example:
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (BuildContext context) {
//       return NSearchPage<MatchInfo>(
//         hint: '搜索赛事、球队111',
//         cacheKey: SpfKeys.footballMatchSearchHistory,
//         search: (keyword) {
//           List<MatchInfo> data = childKey.currentState!.getAllMatchList();
//           final filters = data.where((e) {
//             final result = ((e.homeTeam?.name ?? '').contains(keyword)) ||
//                 ((e.awayTeam?.name ?? '').contains(keyword)) ||
//                 ((e.competition?.name ?? '').contains(keyword));
//             return result;
//           }).toList();
//           return filters;
//         },
//         builder: (context, searchList) {
//           return GoingMatchList(
//             itemList: searchList,
//             tag: 'search',
//             showTime: false,
//           );
//         },
//       );
//     },
//   ),
// );

/// 通用搜索页面组件
class NSearchPage<M> extends StatefulWidget {
  const NSearchPage({
    super.key,
    this.hint = '搜索',
    required this.cacheKey,
    required this.search,
    required this.builder,
  });

  /// 提示语
  final String hint;

  /// 缓存key
  final String cacheKey;

  /// 搜索请求
  final FutureOr<List<M>> Function(String keyword) search;

  /// 构建
  final Widget Function(BuildContext context, List<M> results) builder;

  @override
  State<NSearchPage<M>> createState() => _NSearchPageState<M>();
}

class _NSearchPageState<M> extends State<NSearchPage<M>> {
  List<String> history = [];
  List<M> searchList = [];
  late final controller = TextEditingController();

  @override
  void initState() {
    List<String>? temp = CacheService().getStringList(widget.cacheKey) ?? [];
    history.addAll(temp);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBarBgColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColor,
        titleSpacing: 0,
        leadingWidth: 42,
        leading: const NBackButton(
          color: Colors.black,
        ),
        title: Container(
          padding: const EdgeInsets.only(right: 16),
          child: NSearchBarView(
            controller: controller,
            hint: widget.hint,
            onTapSearch: onTapSearch,
            onChanged: (v) => onTapSearch.debounce.call(v),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: searchList.isNotEmpty ? null : appBarBgColor,
        ),
        child: Column(
          children: [
            Expanded(
              child: searchList.isNotEmpty
                  ? widget.builder(context, searchList)
                  : ValueListenableBuilder(
                      valueListenable: controller,
                      builder: (context, value, child) {
                        return value.text.isNotEmpty ? const NPlaceholder() : child!;
                      },
                      child: NSearchHistory(
                        items: history,
                        onSelected: (String v) {
                          final index = history.indexOf(v);
                          onSelectedItem(index);
                        },
                        onClear: onClearSearchKeyword,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void onClearSearchKeyword() {
    history.clear();
    CacheService().setStringList(widget.cacheKey, history);
    setState(() {});
  }

  void onSelectedItem(int index) {
    controller.text = history[index];
    onTapSearch(controller.text);
  }

  void onTapSearch(String value) {
    if (value.isEmpty) {
      searchList.clear();
      setState(() {});
      return;
    }

    final oldIndex = history.indexOf(value);
    if (oldIndex != -1) {
      history.removeAt(oldIndex);
    }
    history.insert(0, value);
    if (history.length > 20) {
      history.removeLast();
    }

    CacheService().setStringList(widget.cacheKey, history);
    search(value);
  }

  Future<void> search(String value) async {
    searchList = await widget.search(value);
    setState(() {});
    debugPrint(["searchList", searchList.length].join("\n"));
  }
}
