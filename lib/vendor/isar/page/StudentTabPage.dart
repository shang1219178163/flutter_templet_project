import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_page_view.dart';
import 'package:flutter_templet_project/vendor/isar/DBManager.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_student.dart';
import 'package:flutter_templet_project/vendor/isar/page/StudentLisPage.dart';
import 'package:flutter_templet_project/vendor/isar/page/StudentLisPageOne.dart';
import 'package:flutter_templet_project/vendor/isar/provider/change_notifier/db_generic_provider.dart';
import 'package:provider/provider.dart';

class StudentTabPage extends StatefulWidget {
  StudentTabPage({super.key, this.title});

  final String? title;

  @override
  State<StudentTabPage> createState() => _StudentTabPageState();
}

class _StudentTabPageState extends State<StudentTabPage> {
  late final items = <(String, Widget)>[
    (
      'DBStudentController',
      StudentLisPage(arguments: {"hideAppBar": true}),
    ),
    ('DBStudentProvider', StudentLisPageOne()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: NPageView(
        items: items,
        onPageChanged: onPageChanged,
      ),
    );
  }

  void onPageChanged(int index) {
    switch (index) {
      case 0:
        DBManager.findController<DBStudent>().notify();
      case 1:
        context.read<DBGenericProvider<DBStudent>>().notify();
    }
  }
}
