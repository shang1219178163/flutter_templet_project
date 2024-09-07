import 'package:flutter/material.dart';
import 'package:flutter_templet_project/Pages/demo/TextFieldDemo.dart';
import 'package:flutter_templet_project/basicWidget/n_tab_bar_page.dart';
import 'package:flutter_templet_project/pages/demo/TextFieldDemoOne.dart';
import 'package:flutter_templet_project/pages/demo/TextFieldDemoTwo.dart';
import 'package:flutter_templet_project/pages/demo/TextFieldLoginDemo.dart';
import 'package:flutter_templet_project/pages/demo/TextFieldWidgetDemo.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tuple/tuple.dart';

class TextFieldTabDemo extends StatefulWidget {
  TextFieldTabDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<TextFieldTabDemo> createState() => _TextFieldTabDemoState();
}

class _TextFieldTabDemoState extends State<TextFieldTabDemo> {
  bool get hideApp =>
      "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  final List<Tuple2<String, Widget>> items = [
    Tuple2("TextFieldDemo", TextFieldDemo()),
    Tuple2("TextFieldDemoOne", TextFieldDemoOne()),
    Tuple2("TextFieldDemoTwo", TextFieldDemoTwo()),
    Tuple2("TextFieldLoginDemo", TextFieldLoginDemo()),
    Tuple2("TextFieldWidgetDemo", TextFieldWidgetDemo()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => debugPrint(e),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return NTabBarPage(
      items: items,
    );
  }
}
