import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choic_bottom_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/vendor/isar/DBDialogMixin.dart';
import 'package:flutter_templet_project/vendor/isar/DBManager.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';
import 'package:flutter_templet_project/vendor/isar/page/TodoItem.dart';
import 'package:flutter_templet_project/vendor/isar/provider/gex_controller/db_generic_controller.dart';
import 'package:get/get.dart';

/// DBGenericController<DBTodo> 示例
class TodoListPage extends StatefulWidget {
  TodoListPage({
    super.key,
    this.title,
    this.arguments,
  });

  final String? title;

  final Map<String, dynamic>? arguments;

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> with DBDialogMixin {
  late final Map<String, dynamic> arguments = widget.arguments ?? Get.arguments ?? {};

  late final hideAppBar = arguments["hideAppBar"] as bool?;

  final _scrollController = ScrollController();

  final titleController = TextEditingController();

  bool isAllChoic = false;

  DBGenericController<DBTodo> get provider => DBManager.findController<DBTodo>();

  @override
  Widget build(BuildContext context) {
    final automaticallyImplyLeading = Get.currentRoute.toLowerCase() == "/$widget".toLowerCase();

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: hideAppBar == true
          ? null
          : AppBar(
              title: Text("$widget"),
              automaticallyImplyLeading: automaticallyImplyLeading,
              actions: [
                IconButton(onPressed: onAddItemRandom, icon: Icon(Icons.add)),
              ],
            ),
      body: GetBuilder<DBGenericController<DBTodo>>(
        tag: DBManager.controllerTag,
        builder: (value) {
          final checkedItems = value.entities.where((e) => e.isFinished == true).toList();
          isAllChoic = value.entities.firstWhereOrNull((e) => e.isFinished == false) == null;

          final checkIcon = isAllChoic ? Icons.check_box : Icons.check_box_outline_blank;
          final checkDesc = "已选择 ${checkedItems.length}/${value.entities.length}";

          Widget content = NPlaceholder(
            onTap: () {
              provider.update();
            },
          );
          if (value.entities.isNotEmpty) {
            content = buildRefresh(
              onRefresh: () {
                provider.update();
              },
              child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: value.entities.length,
                  itemBuilder: (context, index) {
                    final model = value.entities.reversed.toList()[index];

                    onToggle() {
                      model.isFinished = !model.isFinished;
                      provider.put(model);
                    }

                    return InkWell(
                      onTap: onToggle,
                      child: TodoItem(
                        model: model,
                        onToggle: onToggle,
                        onEdit: () {
                          titleController.text = model.title;

                          presentDialog(
                              controller: titleController,
                              onSure: (val) {
                                model.title = val;
                                provider.put(model);
                              });
                        },
                        onDelete: () {
                          provider.delete(model.id);
                        },
                      ),
                    );
                  }),
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
                  DLog.d("isAllChoic TextButton: $isAllChoic");
                  for (var i = 0; i < value.entities.length; i++) {
                    final e = value.entities[i];
                    e.isFinished = !isAllChoic;
                  }
                  provider.putAll(value.entities);
                },
                onAdd: onAddItemRandom,
                onDelete: () async {
                  final choicItems = value.entities.where((e) => e.isFinished).map((e) => e.id).toList();
                  await provider.deleteAll(choicItems);
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
    provider.put(todo);
  }
}
