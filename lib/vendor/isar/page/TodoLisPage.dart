

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';
import 'package:flutter_templet_project/vendor/isar/page/TodoItem.dart';
import 'package:flutter_templet_project/vendor/isar/provider/db_todo_provider.dart';
import 'package:provider/provider.dart';


/// 基于 Provider 的 isar 数据库存储
class TodoListPage extends StatelessWidget {
  TodoListPage({super.key});

  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DBTodoProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text("Todo List"),
        actions: [
          IconButton(
            onPressed: (){
              titleController.text = "项目${IntExt.random(max: 999)}";
              addModel(context: context, title: titleController.text);
            },
            icon: Icon(Icons.add)
          ),
          IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.data_object)
          ),
        ],
      ),
      body: Consumer<DBTodoProvider>(
        builder: (context, value, child) {
          if (value.todos.isEmpty) {
            return const Center(
              child: Text("no todo"),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: value.todos.length,
                  itemBuilder: (context, index) {

                    final model = value.todos.reversed.toList()[index];

                    return TodoItem(
                      model: model,
                      onToggleFinished: () {
                        provider.toggleFinished(model);
                      },
                      onDelete: () {
                        provider.deleteTodo(model);
                      },
                    );
                  }
                ),
              ),
              Container(
                height: 69,
                color: Colors.white,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addItem(context, onAdd: () {
            addModel(context: context, title: titleController.text);
            titleController.clear();
            Navigator.pop(context);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  addItem(BuildContext context, {required VoidCallback onAdd}) {
    showDialog(
        context: context,
        builder: (context) {

          titleController.text = "项目${IntExt.random(max: 999)}";

          return AlertDialog(
            title: const Text("Tambah Todo"),
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
                ElevatedButton(
                    onPressed: onAdd,
                    style: const ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(Colors.blue)),
                    child: const Text(
                      "add",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          );
        }
        );
  }


  addModel({required BuildContext context, required String title}) {
    if (title.isEmpty) {
      return;
    }

    var todo = DBTodo()
      ..title = title
      ..isFinished = false
      ..createdDate = DateTime.now();
    Provider.of<DBTodoProvider>(context, listen: false).addTodo(todo);
  }
}