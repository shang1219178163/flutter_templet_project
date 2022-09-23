//
//  RecordListDemo.dart
//  flutter_templet_project
//
//  Created by shang on 5/19/21 6:32 PM.
//  Copyright © 5/19/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class RecordListDemo extends StatefulWidget {

  final String? title;

  RecordListDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _RecordListDemoState createState() => _RecordListDemoState();
}

class _RecordListDemoState extends State<RecordListDemo> {
  final editingController = TextEditingController();
  var selectedDate = DateTime.now();

  var list = <String>[];

  SlidableController slidableController = SlidableController();

  @override
  void initState() {
    super.initState();

    list.insertAll(0, List.generate(20, (index) => "$index"));
  }

  @override
  void dispose() {
    super.dispose();

    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

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
        // return buildDismissible(context, index);
        return ListTile(leading: Text(index.toString()), trailing: item,);

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
  
  Widget buildDismissible(BuildContext context, int index) {
    String item = list[index];

    return Dismissible(
      onDismissed: (direction) {
        //参数暂时没有用到，则用下划线表示
        print("--removeAt---" + item.toString());
        list.removeAt(index);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('删除了${index}'),
            ));
      },
      // 监听
      movementDuration: Duration(milliseconds: 100),
      key: Key("$item"),
      child: ListTile(leading: Text(item.toString()), trailing: Text(item),),
      background: Container(
        color: Color(0xffff0000),
        // child: Text("删除"),
      ),
    );
  }

  void addWeight() {
    final datetimeStr = DateFormat.yMMMd().format(selectedDate);

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
          width: MediaQuery.of(context).size.width,
          margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Register Weight',
                style:TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ).padding(bottom: 24),
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
                  ).expanded(),
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
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Text('${datetimeStr}'),
                                ),
                                Icon(Icons.calendar_today_outlined),
                              ],
                            ),
                          );
                        },
                      )),
                ],
              ).padding(top: 8, bottom: 8),
              Expanded(child: Container()),
              ButtonBar(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        )),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      // minimumSize: Size(96, 48),
                    ),
                  ),
                  ElevatedButton(
                      child: Text('Register'),
                  onPressed: () {
                        actionRegister(context);
                      },
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
        firstDate: now.subtract( Duration(days: 90,),),
        lastDate: now);

    if (result != null) {
        setState(() {
          selectedDate = result;
      });
    }

  }

  actionRegister(BuildContext context) {
    final datetimeStr = DateFormat.yMMMd().format(selectedDate);
    setState(() {
      // list.insert(0, datetimeStr);
      list.insert(0, editingController.text);
    });
    Navigator.pop(context);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
    );
  }
}



