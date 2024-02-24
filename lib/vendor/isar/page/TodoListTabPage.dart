

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_page_view.dart';
import 'package:flutter_templet_project/pages/demo/NPageViewDemo.dart';
import 'package:flutter_templet_project/vendor/isar/page/OrderListPage.dart';
import 'package:flutter_templet_project/vendor/isar/page/StudentLisPage.dart';
import 'package:flutter_templet_project/vendor/isar/page/StudentLisPageOne.dart';
import 'package:flutter_templet_project/vendor/isar/page/StudentLisPageTwo.dart';
import 'package:flutter_templet_project/vendor/isar/page/TodoListPage.dart';
import 'package:flutter_templet_project/vendor/isar/page/TodoListPageOne.dart';
import 'package:flutter_templet_project/vendor/isar/page/TodoListPageTwo.dart';
import 'package:tuple/tuple.dart';

class TodoListTabPage extends StatefulWidget {

  TodoListTabPage({
    super.key,
    this.title
  });

  final String? title;

  @override
  State<TodoListTabPage> createState() => _TodoListTabPageState();
}

class _TodoListTabPageState extends State<TodoListTabPage> {

  final _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return NPageView(
      needSafeArea: false,
      items: items,
      onPageChanged: (index) {

      },
    );
  }

  List<Tuple2<String, Widget>> items = [
    Tuple2('DBProvider', TodoListPage()),
    Tuple2('DBTodoListController', TodoListPageOne()),
    Tuple2('DBTodoListProvider', TodoListPageTwo()),
    Tuple2('DBGenericProvider', OrderListPage()),

  ];
}