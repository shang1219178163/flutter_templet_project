
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GetxDemo extends StatefulWidget {

  GetxDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _GetxDemoState createState() => _GetxDemoState();
}

class _GetxDemoState extends State<GetxDemo> {

  var count = 0.obs;


  final storage = GetStorage();


  @override
  Widget build(BuildContext context) {
    debugPrint("build");

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => Text("count: $count")),
            Obx(() => Text("storage count: ${storage.read("count")}")),
          ],
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

}