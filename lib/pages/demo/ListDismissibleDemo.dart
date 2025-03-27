//
//  ListDismissibleDemo.dart
//  flutter_templet_project
//
//  Created by shang on 5/19/21 6:32 PM.
//  Copyright © 5/19/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListDismissibleDemo extends StatefulWidget {
  final String? title;

  const ListDismissibleDemo({Key? key, this.title}) : super(key: key);

  @override
  _ListDismissibleDemoState createState() => _ListDismissibleDemoState();
}

class _ListDismissibleDemoState extends State<ListDismissibleDemo> {
  final editingController = TextEditingController();
  var selectedDate = DateTime.now();

  var list = <String>[];

  // SlidableController slidableController = SlidableController();

  @override
  void initState() {
    super.initState();

    list.insertAll(0, List.generate(20, (index) => "$index"));
  }

  @override
  void dispose() {
    super.dispose();

    // FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildListView(context, list),
      floatingActionButton: FloatingActionButton(
        onPressed: addWeight,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildListView(BuildContext context, List<String> list) {
    return ListView.separated(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = Text(list[index]);
        // return ListTile(leading: Text(index.toString()), trailing: item,);
        return buildListTile(index: index, addDismissible: true);
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: .5,
          indent: 15,
          endIndent: 15,
          color: Color(0xFFDDDDDD),
        );
      },
    );
  }

  Widget buildListTile({required int index, bool addDismissible = false}) {
    var item = list[index];

    final child = ListTile(
      leading: Text(item.toString()),
      trailing: Text("滑动删除"),
    );
    if (!addDismissible) {
      return child;
    }
    return Dismissible(
      key: UniqueKey(),
      movementDuration: Duration(milliseconds: 100),
      onDismissed: (direction) {
        debugPrint("--removeAt---$item");
        list.removeAt(index);

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('删除了${item.toString()}'),
        ));
        setState(() {});
      },
      background: Container(
        color: Color(0xffff0000),
        // child: Text("删除"),
      ),
      child: child,
    );
  }

  void addWeight() {
    final datetimeStr = DateFormat.yMMMd().format(selectedDate);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      )),
      builder: (context) {
        return Container(
          height: 360,
          margin: EdgeInsets.only(bottom: bottom),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Register Weight',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: editingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight (KG)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Select a date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return OutlinedButton(
                            onPressed: () async {
                              datePickerSelect(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Text(datetimeStr),
                                ),
                                Icon(Icons.calendar_today_outlined),
                              ],
                            ),
                          );
                        },
                      )),
                ],
              ),
              Spacer(),
              ButtonBar(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      // minimumSize: Size(96, 48),
                    ),
                    child: Text('Cancel',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        )),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      actionRegister();
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  ///时间选择
  datePickerSelect(BuildContext context) async {
    final now = DateTime.now();

    final result = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now.subtract(
          Duration(
            days: 90,
          ),
        ),
        lastDate: now);

    if (result != null) {
      setState(() {
        selectedDate = result;
      });
    }
  }

  actionRegister() {
    final datetimeStr = DateFormat.yMMMd().format(selectedDate);
    setState(() {
      // list.insert(0, datetimeStr);
      list.insert(0, editingController.text);
    });
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
