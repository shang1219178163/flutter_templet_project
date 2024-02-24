

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_page_view.dart';
import 'package:flutter_templet_project/pages/demo/NPageViewDemo.dart';
import 'package:flutter_templet_project/vendor/isar/page/StudentLisPage.dart';
import 'package:flutter_templet_project/vendor/isar/page/StudentLisPageOne.dart';
import 'package:flutter_templet_project/vendor/isar/page/StudentLisPageTwo.dart';
import 'package:tuple/tuple.dart';

class StudentTabPage extends StatefulWidget {

  StudentTabPage({
    super.key,
    this.title
  });

  final String? title;

  @override
  State<StudentTabPage> createState() => _StudentTabPageState();
}

class _StudentTabPageState extends State<StudentTabPage> {

  final _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return NPageView(
      items: items,
    );
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Text("$widget"),
          ],
        ),
      ),
    );
  }

  List<Tuple2<String, Widget>> items = [
    Tuple2('DBProvider', StudentLisPage()),
    Tuple2('DBStudentController', StudentLisPageOne()),
    Tuple2('DBStudentProvider', StudentLisPageTwo()),

  ];
}