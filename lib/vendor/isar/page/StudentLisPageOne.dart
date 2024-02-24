

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
import 'package:flutter_templet_project/vendor/isar/model/db_student.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';
import 'package:flutter_templet_project/vendor/isar/page/StudentCell.dart';
import 'package:flutter_templet_project/vendor/isar/page/TodoItem.dart';
import 'package:flutter_templet_project/vendor/isar/provider/change_notifier/db_provider.dart';
import 'package:flutter_templet_project/vendor/isar/provider/gex_controller/db_student_controller.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


class StudentLisPageOne extends StatefulWidget {

  StudentLisPageOne({
    super.key,
    this.title
  });

  final String? title;

  @override
  State<StudentLisPageOne> createState() => _StudentLisPageOneState();
}

class _StudentLisPageOneState extends State<StudentLisPageOne> {

  final _scrollController = ScrollController();

  final titleController = TextEditingController();

  bool isAllChoic = false;
  // bool get isAllChoic = false;
  // DBStudentProvider get provider => Provider.of<DBStudentProvider>(context, listen: false);

  final provider = Get.put(DBStudentController());


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
      body: GetBuilder<DBStudentController>(
        builder: (value) {
          if (value.entitys.isEmpty) {
            return const Center(
              child: Text("noting"),
            );
          }

          final checkedItems = value.entitys.where((e) => e.isSelected == true).toList();
          isAllChoic = value.entitys.firstWhereOrNull((e) => e.isSelected == false) == null;

          final checkIcon = isAllChoic ? Icons.check_box : Icons.check_box_outline_blank;
          final checkDesc = "已选择 ${checkedItems.length}/${value.entitys.length}";

          return Column(
            children: [
              Expanded(
                child: buildRefresh(
                  onRefresh: (){
                    provider.update();
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: value.entitys.length,
                    itemBuilder: (context, index) {

                      final model = value.entitys.reversed.toList()[index];

                      onToggle(){
                        model.isSelected = !model.isSelected;
                        provider.put(model);
                      }

                      return InkWell(
                        onTap: onToggle,
                        child: StudentCell(
                          model: model,
                          onToggle: onToggle,
                          onEdit: (){
                            presentDiaog(
                                text: model.name,
                                onSure: (val){
                                  model.name = val;
                                  provider.put(model);
                                }
                            );
                          },
                          onDelete: () {
                            provider.delete(model.id);
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
                  for (var i = 0; i < value.entitys.length; i++) {
                    final e = value.entitys[i];
                    e.isSelected = !isAllChoic;
                  }
                  provider.putAll(value.entitys);
                },
                onAdd: onAddItemRandom,
                onDelete:  () async {
                  final choicItems = value.entitys.where((e) => e.isSelected).map((e) => e.id).toList();
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
    titleController.text = "学生${IntExt.random(max: 999)}";
    addTodoItem(title: titleController.text);
  }

  addTodoItem({required String title}) {
    if (title.isEmpty) {
      return;
    }

    var todo = DBStudent(
      name: title,
      isSelected: false,
      createdDate: DateTime.now().toIso8601String(),
    );
    provider.put(todo);
  }
}