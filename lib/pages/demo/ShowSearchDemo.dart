//
//  ShowSearchDemo.dart
//  flutter_templet_project
//
//  Created by shang on 5/17/21 4:50 PM.
//  Copyright © 5/17/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

class ShowSearchDemo extends StatefulWidget {
  final String? title;

  const ShowSearchDemo({Key? key, this.title}) : super(key: key);

  @override
  _ShowSearchDemoState createState() => _ShowSearchDemoState();
}

class _ShowSearchDemoState extends State<ShowSearchDemo> {
  List<String> list = List.generate(100, (i) => 'item $i');

  late List<String> filters = [...list];

  var search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Search'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch<String>(
                context: context,
                query: search,
                delegate: CustomSearchDelegate(
                  list: filters,
                  select: '',
                  onSelected: (String query) {
                    filters = list.where((e) => query.isEmpty ? e != null : e.contains(query.trim())).toList();
                    setState(() {});
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: filters
            .map(
              (e) => ListTile(
                title: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  CustomSearchDelegate({
    required this.list,
    this.select = "",
    required this.onSelected,
  });

  final List<String> list;
  final String select;
  final ValueChanged<String> onSelected;

  @override
  appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
          onSelected(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        onSelected(query);
        close(context, query);
      },
    );
  }

  /// 用户从搜索页面提交搜索后显示的结果
  @override
  Widget buildResults(BuildContext context) {
    var filterList = list.where((String s) => s.contains(query.trim()));
    return ListView(
      children: filterList
          .map((e) => ListTile(
                leading: Icon(Icons.message),
                title: Text(
                  e,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                onTap: () {
                  query = e;
                  onSelected(e);
                  close(context, e);
                },
              ))
          .toList(),
    );
  }

  /// 当用户在搜索字段中键入查询时，在搜索页面正文中显示的建议
  @override
  Widget buildSuggestions(BuildContext context) {
    var filterList = list.where((String s) => s.contains(query.trim()));
    return ListView(
      children: filterList
          .map((e) => ListTile(
                leading: Icon(Icons.message),
                title: Text(
                  e,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                onTap: () {
                  query = e;
                  onSelected(e);
                  close(context, e);
                },
              ))
          .toList(),
    );
  }
}

class SearchBarViewDelegate extends SearchDelegate<String> {
  String searchHint = "请输入搜索内容...";
  var sourceList = [
    "dart",
    "dart 入门",
    "flutter",
    "flutter 编程",
    "flutter 编程开发",
  ];

  var suggestList = ["flutter", "flutter 编程开发"];

  @override
  String get searchFieldLabel => searchHint;

  @override
  List<Widget> buildActions(BuildContext context) {
    ///显示在最右边的控件列表
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";

          ///搜索建议的内容
          showSuggestions(context);
        },
      ),
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () => query = "",
      )
    ];
  }

  ///左侧带动画的控件，一般都是返回
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),

      //调用 close 关闭 search 界面
      onPressed: () => close(context, ""),
    );
  }

  ///展示搜索结果
  @override
  Widget buildResults(BuildContext context) {
    var result = <String>[];

    ///模拟搜索过程
    for (var str in sourceList) {
      ///query 就是输入框的 TextEditingController
      if (query.isNotEmpty && str.contains(query)) {
        result.add(str);
      }
    }

    ///展示搜索结果
    return ListView.builder(
      itemCount: result.length,
      itemBuilder: (BuildContext context, int index) => ListTile(
        title: Text(result[index]),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggest = query.isEmpty ? suggestList : sourceList.where((input) => input.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggest.length,
      itemBuilder: (BuildContext context, int index) => InkWell(
        onTap: () {
          //  query.replaceAll("", suggest[index].toString());
          searchHint = "";
          query = suggest[index].toString();
          showResults(context);
        },
        child: ListTile(
          title: RichText(
            text: TextSpan(
              text: suggest[index].substring(0, query.length),
              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: suggest[index].substring(query.length),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
