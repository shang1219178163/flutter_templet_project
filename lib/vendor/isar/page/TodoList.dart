

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_todo.dart';
import 'package:flutter_templet_project/vendor/isar/page/TodoItem.dart';
import 'package:flutter_templet_project/vendor/isar/provider/db_todo_provider.dart';
import 'package:provider/provider.dart';


class TodoList extends StatelessWidget {
  TodoList({super.key});

  final titleController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DBTodoProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: Container(
        color: Colors.black12,
        child: Consumer<DBTodoProvider>(
          builder: (context, value, child) {
            if (value.todos.isEmpty) {
              return const Center(
                child: Text("no todo"),
              );
            }

            return ListView.builder(
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
                });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addItem(context, onAdd: () {
            if (titleController.text.isEmpty) {
              return;
            }

            DBTodo todo = DBTodo()
              ..title = titleController.text
              ..isFinished = false
              ..createdDate = DateTime.now();
            provider.addTodo(todo);

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
          return AlertDialog(
            title: const Text("Tambah Todo"),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            content: SizedBox(
              width: 250,
              height: 150,
              child: Column(
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
            ),
          );
        }
        );
  }


}