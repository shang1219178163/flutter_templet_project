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

  ShowSearchDemo({ Key? key, this.title}) : super(key: key);


  @override
  _ShowSearchDemoState createState() => _ShowSearchDemoState();
}

class _ShowSearchDemoState extends State<ShowSearchDemo> {

  List<String> _list = List.generate(100, (i) => 'item $i');



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Search'),
        actions: <Widget>[
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch<String>(
                    context: context,
                    delegate: CustomSearchDelegate(list: _list, select: '', callback: (String query) {
                      ddlog(query);
                      setState(() {
                        if (query.isEmpty) {
                          _list = List.generate(100, (i) => 'item $i');
                        } else {
                          var filterList = _list.where((String s) => s.contains(query.trim()));
                          _list = filterList.toList();
                        }
                      });
                    }),
                  );
                },
              );
            },
          )
        ],
      ),
      body: ListView(
        children:
        _list.map((e) => ListTile(
            title: Text(e),
          ),).toList(),
      ),
    );
  }

}


class CustomSearchDelegate extends SearchDelegate<String> {
  List<String> list;
  String select = "";
  void Function(String select) callback;

  CustomSearchDelegate({required this.list, required this.select, required this.callback});

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
          callback(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        callback(query);
        close(context, query);
      },
    );
  }

  /// 用户从搜索页面提交搜索后显示的结果
  @override
  Widget buildResults(BuildContext context) {
    var filterList = list.where((String s) => s.contains(query.trim()));
    return ListView(
      children: filterList.map((e) => ListTile(
        leading: Icon(Icons.message),
        title: Text(
          e,
          style: Theme.of(context).textTheme.headline6,
        ),
        onTap: () {
          query = e;
          callback(e);
          close(context, e);
        },
      )).toList(),
    );
  }

  /// 当用户在搜索字段中键入查询时，在搜索页面正文中显示的建议
  @override
  Widget buildSuggestions(BuildContext context) {
    var filterList = list.where((String s) => s.contains(query.trim()));
    return ListView(
      children: filterList.map((e) => ListTile(
        leading: Icon(Icons.message),
        title: Text(
          e,
          style: Theme.of(context).textTheme.headline6,
        ),
        onTap: () {
          query = e;
          callback(e);
          close(context, e);
        },
      )).toList(),
    );
  }
}


class SearchBarViewDelegate extends SearchDelegate<String>{

  String searchHint = "请输入搜索内容...";
  var sourceList = [
    "dart",
    "dart 入门",
    "flutter",
    "flutter 编程",
    "flutter 编程开发",
  ];

  var  suggestList = [
    "flutter",
    "flutter 编程开发"
  ];


  @override
  String get searchFieldLabel => searchHint;

  @override
  List<Widget> buildActions(BuildContext context) {

    ///显示在最右边的控件列表
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = "";
          ///搜索建议的内容
          showSuggestions(context);
        },
      ),
      IconButton(
        icon: Icon(Icons.search),
        onPressed: ()=>query = "",
      )
    ];
  }


  ///左侧带动画的控件，一般都是返回
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation
      ),
      ///调用 close 关闭 search 界面
      onPressed: ()=>close(context,""),
    );
  }

  ///展示搜索结果
  @override
  Widget buildResults(BuildContext context) {

    List<String> result = [];

    ///模拟搜索过程
    for (var str in sourceList){
      ///query 就是输入框的 TextEditingController
      if (query.isNotEmpty && str.contains(query)){
        result.add(str);
      }
    }

    ///展示搜索结果
    return ListView.builder(
      itemCount: result.length,
      itemBuilder: (BuildContext context, int index)=>ListTile(
        title: Text(result[index]),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    List<String> suggest = query.isEmpty ? suggestList : sourceList.where((input)=>input.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggest.length,
      itemBuilder: (BuildContext context, int index)=>
          InkWell(
            child:         ListTile(
              title: RichText(
                text: TextSpan(
                  text: suggest[index].substring(0, query.length),
                  style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: suggest[index].substring(query.length),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            onTap: (){
              //  query.replaceAll("", suggest[index].toString());
              searchHint = "";
              query =  suggest[index].toString();
              showResults(context);
            },
          ),
    );
  }
}

