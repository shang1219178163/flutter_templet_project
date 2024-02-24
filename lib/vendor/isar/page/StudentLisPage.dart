

import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choic_bottom_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/vendor/isar/DBDialogMixin.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_student.dart';
import 'package:flutter_templet_project/vendor/isar/page/StudentCell.dart';
import 'package:flutter_templet_project/vendor/isar/provider/change_notifier/db_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


class StudentLisPage extends StatefulWidget {

  StudentLisPage({
    super.key,
    this.title
  });

  final String? title;

  @override
  State<StudentLisPage> createState() => _StudentLisPageState();
}

class _StudentLisPageState extends State<StudentLisPage> with DBDialogMxin {

  final _scrollController = ScrollController();

  final titleController = TextEditingController();

  bool isAllChoic = false;
  // bool get isAllChoic = false;
  DBProvider get provider => Provider.of<DBProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    final automaticallyImplyLeading = Get.currentRoute.toLowerCase() == "/$widget".toLowerCase();

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.05),
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

          final checkedItems = value.students.where((e) => e.isSelected == true).toList();
          isAllChoic = value.students.firstWhereOrNull((e) => e.isSelected == false) == null;

          final checkIcon = isAllChoic ? Icons.check_box : Icons.check_box_outline_blank;
          final checkDesc = "已选择 ${checkedItems.length}/${value.students.length}";

          Widget content = NPlaceholder(
            onTap: (){
              provider.update();
            },
          );
          if (value.students.isNotEmpty) {
            content = buildRefresh(
              onRefresh: (){
                provider.update<DBStudent>();
              },
              child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: value.students.length,
                  itemBuilder: (context, index) {

                    final model = value.students.reversed.toList()[index];

                    onToggle(){
                      model.isSelected = !model.isSelected;
                      provider.put<DBStudent>(model);
                    }

                    return InkWell(
                      onTap: onToggle,
                      child: StudentCell(
                        model: model,
                        onToggle: onToggle,
                        onEdit: (){
                          titleController.text = model.name;

                          presentDialog(
                            controller: titleController,
                            onSure: (val){
                              model.name = val;
                              provider.put<DBStudent>(model);
                            }
                          );
                        },
                        onDelete: () {
                          provider.delete<DBStudent>(model.id);
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
                  for (var i = 0; i < value.students.length; i++) {
                    final e = value.students[i];
                    e.isSelected = !isAllChoic;
                  }
                  provider.putAll<DBStudent>(value.students);
                },
                onAdd: () async {
                  titleController.text = "学生${IntExt.random(max: 999)}";
                  addTodoItem(title: titleController.text);
                },
                onDelete:  () async {
                  final choicItems = value.students.where((e) => e.isSelected).map((e) => e.id).toList();
                  await provider.deleteAll<DBStudent>(choicItems);
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
    provider.put<DBStudent>(todo);
  }
}