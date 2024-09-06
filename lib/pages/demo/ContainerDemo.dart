import 'dart:ui' as ui;

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_flex_spacing.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/util/R.dart';

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
              image: NetworkImage(R.image.urls[0]),
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
    final children = List.generate(
        3,
        (index) => Container(
              decoration: BoxDecoration(
                  // color: ColorExt.random,
                  // border: Border.all(color: Colors.blue),
                  ),
              child: NText("项目_$index"),
            )).toList();

    Widget separated = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: VerticalDivider(
        color: Colors.red,
        width: 1,
        indent: 0,
        endIndent: 0,
      ),
    );
    return Container(
      // color: Colors.green,
      child: Column(
        children: [
          NSectionBox(
            title: "ListView.separated",
            child: Container(
              height: 20,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) => children[i],
                separatorBuilder: (_, i) => separated,
                itemCount: children.length,
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated - SizedBox",
            child: SizedBox(
              height: 30,
              child: NFlexSeparated(
                direction: Axis.horizontal,
                separatedBuilder: (i) {
                  return separated;
                },
                children: children,
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated - IntrinsicHeight",
            child: IntrinsicHeight(
              child: NFlexSeparated(
                direction: Axis.horizontal,
                separatedBuilder: (i) {
                  return separated;
                },
                children: children,
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated.spacing",
            child: IntrinsicHeight(
              child: NFlexSeparated.spacing(
                direction: Axis.horizontal,
                spacing: 30,
                children: children,
              ),
            ),
          ),
        ],
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
