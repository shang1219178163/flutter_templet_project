import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class ContainerDemo extends StatefulWidget {
  final String? title;

  const ContainerDemo({Key? key, this.title}) : super(key: key);

  @override
  _ContainerDemoState createState() => _ContainerDemoState();
}

class _ContainerDemoState extends State<ContainerDemo> {
  bool isSliver = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            TextButton(
              onPressed: () {
                debugPrint('TextButton');
                isSliver = !isSliver;
                setState(() {});
              },
              child: Text(
                'done',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        // body: isSliver ? buildBodyCustom() : buildBodyColumn(),
        body: CustomScrollView(
          slivers: [
            buildSection(),
            buildSection1(),
            // buildSection2(),
            buildGradientBorder(),
            buildSection3(),
          ].map((e) => e.toSliverToBoxAdapter()).toList(),
        ));
  }

  buildBodyColumn() {
    var children = <Widget>[
      // ...testContainer(),
      buildSection(),
      buildSection1(),
      buildSection2(),
    ];

    return Column(
      children: children
          .map((e) => Builder(builder: (context) {
                return Expanded(
                  child: e,
                );
              }))
          .toList(),
    );
  }

  buildBodyCustom() {
    var children = <Widget>[
      // ...testContainer(),
      buildSection(),
      buildSection1(),
      buildSection2(),
      buildSection3(),
    ];

    return CustomScrollView(
      slivers: children
          .map((e) => SliverToBoxAdapter(
                child: e,
              ))
          .toList(),
    );
  }

  Widget buildSection() {
    var bgBlur = 10.0;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Opacity(
        opacity: 1,
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              colors: [Colors.green, Colors.yellow],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            image: DecorationImage(
              image: NetworkImage('R.image.urls[0]'),
              fit: BoxFit.cover,
            ),
          ),
          // foregroundDecoration: BoxDecoration(
          //   color: Colors.yellow,
          //   border: Border.all(color: Colors.green, width: 5),
          //   borderRadius: BorderRadius.all(Radius.circular(400)),
          //   image: DecorationImage(
          //     image: NetworkImage('https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: bgBlur, sigmaY: bgBlur),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.red,
              ),
              child: Text('VCG21409037867'),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSection1() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: "img_update.png".toAssetImage(),
        repeat: ImageRepeat.repeat,
        alignment: Alignment.topLeft,
      )),
      transform: Matrix4.rotationZ(.2),
      alignment: Alignment.centerRight, //卡片内文字居中
      child: Text(
        //卡片文字
        "5.20", style: TextStyle(color: Colors.red, fontSize: 40.0),
      ),
    );
  }

  Widget buildSection2() {
    const msg = "静夜思 * 李白 • 床前明月光, 疑是地上霜, 举头望明月, 低头思故乡.";
    return Container(
      decoration: BoxDecoration(
        color: Colors.yellow,
        border: Border.all(width: 10, color: Colors.blue),
      ),
      child: Text(
        msg,
        style: TextStyle(fontSize: 20, color: Colors.deepPurple),
      ),
    );
  }

  Widget buildSection3() {
    return Container(
      width: 150,
      height: 150,
      margin: const EdgeInsets.all(50),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(20.0),
        //   topRight: Radius.circular(20.0),
        //   bottomLeft: Radius.zero,
        //   bottomRight: Radius.zero,
        // ),
      ),
      child: Text(
        "hello",
      ),
    );
  }

  List<Widget> testContainer() {
    return [
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: 'img_update.png'.toAssetImage(),
          repeat: ImageRepeat.repeat,
          alignment: Alignment.topLeft,
        )),
        child: Container(
          constraints: BoxConstraints.expand(),
          child: OutlinedButton(
            onPressed: () {
              debugPrint("ImageRepeat.repeat");
            },
            child: Text(
              'ImageRepeat.repeat',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
        ),
      ),
      Container(
        color: Colors.green,
        child: Text('Container'),
      ),
      Container(
        constraints: BoxConstraints.expand(),
        color: Colors.yellow,
        child: Text('Container1'),
      ),
    ];
  }

  Widget buildGradientBorder() {
    var borderRadius = BorderRadius.circular(15);

    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          colors: [
            Colors.red,
            Colors.green,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Colors.white,
          ),
          child: Center(
            child: Text('Enter further widgets here'),
          ),
        ),
      ),
    );
  }
}
