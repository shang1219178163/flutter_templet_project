import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_page_view.dart';
import 'package:flutter_templet_project/vendor/isar/DBManager.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';
import 'package:flutter_templet_project/vendor/isar/page/TodoListPage.dart';
import 'package:flutter_templet_project/vendor/isar/page/TodoListPageOne.dart';
import 'package:flutter_templet_project/vendor/isar/provider/change_notifier/db_generic_provider.dart';
import 'package:provider/provider.dart';

class TodoListTabPage extends StatefulWidget {
  TodoListTabPage({super.key, this.title});

  final String? title;

  @override
  State<TodoListTabPage> createState() => _TodoListTabPageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _TodoListTabPageState extends State<TodoListTabPage> {
  late final items = <(String, Widget)>[
    (
      'DBTodoListController',
      TodoListPage(arguments: {"hideAppBar": true}),
    ),
    ('DBTodoListProvider', TodoListPageOne()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: NPageView(
        needSafeArea: false,
        items: items,
        onPageChanged: onPageChanged,
      ),
    );
  }

  void onPageChanged(int index) {
    switch (index) {
      case 0:
        DBManager.findController<DBTodo>().notify();
      case 1:
        context.read<DBGenericProvider<DBTodo>>().notify();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<(String, Widget)>('items', items));
  }
}
