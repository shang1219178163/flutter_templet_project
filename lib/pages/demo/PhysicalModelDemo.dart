

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_extension.dart';

class PhysicalModelDemo extends StatefulWidget {

  PhysicalModelDemo({ Key? key, this.title}) : super(key: key);

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
                  child: BlueBox(title: '1'),
                  color: Colors.black,
                ),
                SizedBox(height: 15,),

                PhysicalModel(
                  child: BlueBox(title: '2'),
                  color: Colors.black,
                  elevation: 8.0,
                ),
                SizedBox(height: 15,),

                PhysicalModel(
                  child: BlueBox(title: '3'),
                  color: Colors.black,
                  shadowColor: Colors.red,
                  elevation: 8.0,
                ),
                SizedBox(height: 15,),

                PhysicalModel(
                  child: BlueBox(title: '4'),
                  color: Colors.black,
                  shadowColor: Colors.pink,
                  elevation: 8.0,
                  borderRadius: BorderRadius.circular(45),
                ),
                SizedBox(height: 15,),

                PhysicalModel(
                  child: BlueBox(title: '5'),
                  color: Colors.black,
                  shadowColor: Colors.pink,
                  elevation: 8.0,
                  shape: BoxShape.circle,
                ),
                SizedBox(height: 15,),

                PhysicalModel(
                  child: BlueBox(title: '6', opacity: 1.0),
                  color: Colors.black,
                  shadowColor: Colors.pink,
                  elevation: 8.0,
                  shape: BoxShape.circle,
                ),
                SizedBox(height: 15,),

                PhysicalModel(
                  child: BlueBox(title: '7', opacity: 0.0),
                  color: Colors.black,
                  shadowColor: Colors.pink,
                  elevation: 8.0,
                  shape: BoxShape.circle,
                ),
                SizedBox(height: 15,),

                PhysicalModel(
                  color: Colors.transparent,
                  shadowColor: Colors.red,
                  elevation: 8.0,
                  shape: BoxShape.circle,
                ),
              ],
            )

          ],
        )
    );
  }


  BlueBox({required String title, opacity = 1.0}) {
    return Container(
      width: 100,
      height: 100,
      color: ColorExt.random.withOpacity(opacity),
      child: Text(title),
    );
  }
}