import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class PhysicalModelDemo extends StatefulWidget {
  const PhysicalModelDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _PhysicalModelDemoState createState() => _PhysicalModelDemoState();
}

class _PhysicalModelDemoState extends State<PhysicalModelDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                PhysicalModel(
                  color: Colors.black,
                  child: buildBlueBox(title: '1'),
                ),
                SizedBox(
                  height: 15,
                ),
                PhysicalModel(
                  color: Colors.black,
                  elevation: 8.0,
                  child: buildBlueBox(title: '2'),
                ),
                SizedBox(
                  height: 15,
                ),
                PhysicalModel(
                  color: Colors.black,
                  shadowColor: Colors.red,
                  elevation: 8.0,
                  child: buildBlueBox(title: '3'),
                ),
                SizedBox(
                  height: 15,
                ),
                PhysicalModel(
                  color: Colors.black,
                  shadowColor: Colors.pink,
                  elevation: 8.0,
                  borderRadius: BorderRadius.circular(45),
                  child: buildBlueBox(title: '4'),
                ),
                SizedBox(
                  height: 15,
                ),
                PhysicalModel(
                  color: Colors.black,
                  shadowColor: Colors.pink,
                  elevation: 8.0,
                  shape: BoxShape.circle,
                  child: buildBlueBox(title: '5'),
                ),
                SizedBox(
                  height: 15,
                ),
                PhysicalModel(
                  color: Colors.black,
                  shadowColor: Colors.pink,
                  elevation: 8.0,
                  shape: BoxShape.circle,
                  child: buildBlueBox(title: '6', opacity: 1.0),
                ),
                SizedBox(
                  height: 15,
                ),
                PhysicalModel(
                  color: Colors.black,
                  shadowColor: Colors.pink,
                  elevation: 8.0,
                  shape: BoxShape.circle,
                  child: buildBlueBox(title: '7', opacity: 0.0),
                ),
                SizedBox(
                  height: 15,
                ),
                PhysicalModel(
                  color: Colors.transparent,
                  shadowColor: Colors.red,
                  elevation: 8.0,
                  shape: BoxShape.circle,
                ),
              ],
            )
          ],
        ));
  }

  Widget buildBlueBox({required String title, opacity = 1.0}) {
    return Container(
      width: 100,
      height: 100,
      color: ColorExt.random.withValues(alpha: opacity),
      child: Text(title),
    );
  }
}
