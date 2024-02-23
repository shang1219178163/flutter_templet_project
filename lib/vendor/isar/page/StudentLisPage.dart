

import 'package:flutter/material.dart';
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
import 'package:flutter_templet_project/vendor/isar/provider/db_student_provider.dart';
import 'package:flutter_templet_project/vendor/isar/provider/db_provider.dart';
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

class _StudentLisPageState extends State<StudentLisPage> {

  final _scrollController = ScrollController();

  final titleController = TextEditingController();

  bool isAllChoic = false;
  // bool get isAllChoic = false;
  DBProvider get provider => Provider.of<DBProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text("$widget"),
        actions: [
          IconButton(
            onPressed: onAddItemRandom,
            icon: Icon(Icons.add)
          ),
          IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.data_object)
          ),
        ],
      ),
      body: Consumer<DBProvider>(
        builder: (context, value, child) {
          if (value.students.isEmpty) {
            return const Center(
              child: Text("noting"),
            );
          }

          final checkedItems = value.students.where((e) => e.isSelected == true).toList();
          isAllChoic = value.students.firstWhereOrNull((e) => e.isSelected == false) == null;

          final icon = isAllChoic ? Icons.check_box : Icons.check_box_outline_blank;
          final desc = "已选择 ${checkedItems.length}/${value.students.length}";

          return Column(
            children: [
              Expanded(
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
                          presentDiaog(
                              text: model.name,
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
              ),
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextButton(
                              onPressed: () async {
                                ddlog("isAllChoic TextButton: $isAllChoic");
                                for (var i = 0; i < value.students.length; i++) {
                                  final todo = value.students[i];
                                  todo.isSelected = !isAllChoic;
                                }
                                provider.putAll<DBStudent>(value.students);
                              },
                              child: Row(
                                children: [
                                  Icon(icon,),
                                  SizedBox(width: 4,),
                                  Text("全选 (${desc})"),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final choicItems = value.students.where((e) => e.isSelected).map((e) => e.id).toList();
                                await provider.deleteAll<DBStudent>(choicItems);
                              },
                              child: Container(
                                height: double.maxFinite,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: context.primaryColor,
                                ),
                                child: NText("删除", color: Colors.white,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddItemRandom,
        child: const Icon(Icons.add),
      ),
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
    provider.put<DBStudent>(todo);
  }
}