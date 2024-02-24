

import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choic_bottom_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
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

class _TodoListPageState extends State<TodoListPage> {

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
          if (value.todos.isEmpty) {
            return const Center(
              child: Text("no todo"),
            );
          }

          final checkedItems = value.todos.where((e) => e.isFinished == true).toList();
          isAllChoic = value.todos.firstWhereOrNull((e) => e.isFinished == false) == null;

          final checkIcon = isAllChoic ? Icons.check_box : Icons.check_box_outline_blank;
          final checkDesc = "已选择 ${checkedItems.length}/${value.todos.length}";

          return Column(
            children: [
              Expanded(
                child: buildRefresh(
                  onRefresh: (){
                    provider.update<DBTodo>();
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
                            presentDiaog(
                                text: model.title,
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
                ),
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

  presentDiaog({required String? text, required ValueChanged<String> onSure}) {
    titleController.text = text ?? "项目${IntExt.random(max: 999)}";

    AlertDialog(
      title: const Text("提示"),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              hintText: "请输入",
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          NFooterButtonBar(
            primary: Colors.red,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            enable: true,
            // hideCancel: true,
            // isReverse: true,
            onCancel:  () {
              Navigator.of(context).pop();
            },
            onConfirm: () {
              onSure(titleController.text);
              Navigator.of(context).pop();
            },
            // gap: 0,
            // btnBorderRadius: BorderRadius.zero,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    ).toShowDialog(context: context);
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