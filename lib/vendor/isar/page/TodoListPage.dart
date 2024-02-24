

import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choic_bottom_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/vendor/isar/DBDialogMixin.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';
import 'package:flutter_templet_project/vendor/isar/page/TodoItem.dart';
import 'package:flutter_templet_project/vendor/isar/provider/change_notifier/db_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

/// DBProvider 示例
class TodoListPage extends StatefulWidget {

  TodoListPage({
    super.key,
    this.title
  });

  final String? title;

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> with DBDialogMxin {

  final _scrollController = ScrollController();

  final titleController = TextEditingController();

  bool isAllChoic = false;

  DBProvider get provider => Provider.of<DBProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    final automaticallyImplyLeading = Get.currentRoute.toLowerCase() == "/$widget".toLowerCase();

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text("$widget"),
        automaticallyImplyLeading: automaticallyImplyLeading,
        actions: [
          IconButton(
            onPressed: onAddItemRandom,
            icon: Icon(Icons.add)
          ),
        ],
      ),
      body: Consumer<DBProvider>(
        builder: (context, value, child) {

          final checkedItems = value.todos.where((e) => e.isFinished == true).toList();
          isAllChoic = value.todos.firstWhereOrNull((e) => e.isFinished == false) == null;

          final checkIcon = isAllChoic ? Icons.check_box : Icons.check_box_outline_blank;
          final checkDesc = "已选择 ${checkedItems.length}/${value.todos.length}";

          Widget content = NPlaceholder(
            onTap: (){
              provider.update();
            },
          );
          if (value.todos.isNotEmpty) {
            content = buildRefresh(
              onRefresh: (){
                provider.update();
              },
              child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: value.todos.length,
                  itemBuilder: (context, index) {

                    final model = value.todos.reversed.toList()[index];

                    onToggle(){
                      model.isFinished = !model.isFinished;
                      provider.put<DBTodo>(model);
                    }

                    return InkWell(
                      onTap: onToggle,
                      child: TodoItem(
                        model: model,
                        onToggle: onToggle,
                        onEdit: (){
                          titleController.text = model.title;

                          presentDialog(
                            controller: titleController,
                            onSure: (val){
                              model.title = val;
                              provider.put<DBTodo>(model);

                            }
                          );
                        },
                        onDelete: () {
                          provider.delete<DBTodo>(model.id);
                        },
                      ),
                    );
                  }
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: content,
              ),
              NChoicBottomBar(
                checkIcon: checkIcon,
                checkDesc: checkDesc,
                onCheck: () async {
                  ddlog("isAllChoic TextButton: $isAllChoic");
                  for (var i = 0; i < value.todos.length; i++) {
                    final e = value.todos[i];
                    e.isFinished = !isAllChoic;
                  }
                  provider.putAll<DBTodo>(value.todos);
                },
                onAdd: onAddItemRandom,
                onDelete:  () async {
                  final choicItems = value.todos.where((e) => e.isFinished).map((e) => e.id).toList();
                  await provider.deleteAll<DBTodo>(choicItems);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildRefresh({
    EasyRefreshController? controller,
    FutureOr Function()? onRefresh,
    FutureOr Function()? onLoad,
    required Widget? child,
  }) {
    return EasyRefresh(
      // refreshOnStart: true,
      canRefreshAfterNoMore: true,
      canLoadAfterNoMore: true,
      controller: controller,
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: child,
    );
  }

  onAddItemRandom() {
    titleController.text = "项目${IntExt.random(max: 999)}";
    addTodoItem(title: titleController.text);
  }

  addTodoItem({required String title}) {
    if (title.isEmpty) {
      return;
    }

    var todo = DBTodo(
      title: title,
      isFinished: false,
      createdDate: DateTime.now().toIso8601String(),
    );
    Provider.of<DBProvider>(context, listen: false).put<DBTodo>(todo);
  }
}