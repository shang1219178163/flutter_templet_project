import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tuple/tuple.dart';

class GetxDemo extends StatefulWidget {
  GetxDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _GetxDemoState createState() => _GetxDemoState();
}

class _GetxDemoState extends State<GetxDemo> {
  var count = 0.obs;

  final storage = GetStorage();

  late final items = <Tuple2<String, VoidCallback>>[
    Tuple2("showDefaultDialog", showDefaultDialog),
    Tuple2("showDialog", showDialog),
    Tuple2("showBottomSheet", showBottomSheet),
    Tuple2("showSnackbar", showSnackbar),
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint("build");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: onPressed,
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items
                    .map((e) => OutlinedButton(
                        onPressed: e.item2,
                        child: NText(
                          e.item1,
                        )))
                    .toList(),
              ),
              Obx(() => Text("count: $count")),
              // Obx(() => Text("storage count: ${storage.read("count")}")),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          count++;
          storage.write("count", count);
        },
        icon: Icon(Icons.add),
        label: const Text("label"),
      ),
    );
  }

  onPressed() {
    // showDefaultDialog();
    // showDialog();
    // showBottomSheet();
    showSnackbar();
  }

  showDefaultDialog() {
    Get.defaultDialog(
      title: "Welcome to Flutter Dev'S",
      middleText:
          "FlutterDevs is a protruding flutter app development company with "
          "an extensive in-house team of 30+ seasoned professionals who know "
          "exactly what you need to strengthen your business across various dimensions",
      backgroundColor: Colors.teal,
      titleStyle: TextStyle(color: Colors.white),
      middleTextStyle: TextStyle(color: Colors.white),
      radius: 20,
    );
  }

  showDialog() {
    Get.dialog(Align(
      child: buildContent(),
    ));
  }

  showBottomSheet() {
    Get.bottomSheet(
      buildContent(),
    );
  }

  showSnackbar() {
    Get.snackbar("Snackbar 标题", "欢迎使用Snackbar",
        snackPosition: SnackPosition.TOP, onTap: (snack) {
      debugPrint("snackbar: $snack");
    });
  }

  Widget buildContent() {
    return Container(
      padding: EdgeInsets.all(30),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NText(
            "Welcome to Flutter Dev'S",
            fontSize: 15,
          ),
          SizedBox(
            height: 20,
          ),
          NText(
            "FlutterDevs is a protruding flutter app development company with "
            "an extensive in-house team of 30+ seasoned professionals who know "
            "exactly what you need to strengthen your business across various dimensions",
            fontSize: 15,
            maxLines: 10,
          ),
        ],
      ),
    );
  }
}
