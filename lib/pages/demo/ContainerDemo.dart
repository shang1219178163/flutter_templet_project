import 'dart:ui' as ui;

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/basicWidget/n_flex_separated.dart';
import 'package:flutter_templet_project/basicWidget/n_inner_shadow.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/pages/demo/FlexDemo.dart';
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
        4,
        (index) => Container(
              decoration: BoxDecoration(
                color: Colors.green,
                // border: Border.all(color: Colors.blue),
              ),
              child: NText("选项_$index"),
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
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) => children[i],
                separatorBuilder: (_, i) => separated,
                itemCount: children.length,
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated - separatedBuilder",
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              child: NFlexSeparated(
                direction: Axis.horizontal,
                spacing: 60,
                separatedBuilder: (i) {
                  final spacing = (i + 1) * 16.0;
                  return Container(
                    width: spacing,
                    color: Colors.yellow,
                    alignment: Alignment.center,
                    child: NText(
                      spacing.toInt().toString(),
                      style: TextStyle(fontSize: 13),
                    ),
                  );
                  // return separated;
                },
                children: children,
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated - spacing: 16",
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              alignment: Alignment.center,
              child: NFlexSeparated(
                direction: Axis.horizontal,
                spacing: 16,
                // separatedBuilder: (i) {
                //   return Container(color: Colors.cyan, width: 12);
                //   // return separated;
                // },
                children: children,
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated - vertical - separatedBuilder",
            child: IntrinsicWidth(
              child: NFlexSeparated(
                direction: Axis.vertical,
                spacing: 60,
                separatedBuilder: (i) {
                  final spacing = (i + 1) * 16.0;
                  return Container(
                    height: spacing,
                    color: Colors.yellow,
                    alignment: Alignment.center,
                    child: NText(
                      spacing.toInt().toString(),
                      style: TextStyle(fontSize: 13),
                    ),
                  );
                  // return separated;
                },
                children: children,
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated - vertical - spacing: 16",
            child: IntrinsicWidth(
              child: NFlexSeparated(
                direction: Axis.vertical,
                separatedBuilder: (i) {
                  final spacing = 16.0;
                  return Container(
                    height: spacing,
                    color: Colors.yellow,
                    alignment: Alignment.center,
                    child: NText(
                      spacing.toInt().toString(),
                      style: TextStyle(fontSize: 13),
                    ),
                  );
                  // return separated;
                },
                children: children,
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated - horizontal",
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              child: IntrinsicHeight(
                child: buildFlexSeparated(direction: Axis.horizontal),
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated - vertical",
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              child: IntrinsicWidth(
                child: buildFlexSeparated(direction: Axis.vertical),
              ),
            ),
          ),
          NSectionBox(
            title: "NInnerShadow",
            child: buildInnerShadow(),
          ),
        ],
      ),
    );
  }

  /// 带分隔的 Flex
  Widget buildFlexSeparated({
    required Axis direction,
    Alignment? textAlignment = Alignment.center,
    double spacing = 0,
    Widget Function(int index)? separatedBuilder,
  }) {
    return NFlexSeparated(
      direction: direction,
      // crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      separatedBuilder: separatedBuilder ??
          (i) {
            final spacing = 16.0 * (i + 1);
            return Container(
              width: direction == Axis.horizontal ? spacing : null,
              height: direction == Axis.horizontal ? null : spacing,
              color: Colors.yellow,
              alignment: Alignment.center,
              child: NText(
                spacing.toInt().toString(),
                style: TextStyle(fontSize: 13),
              ),
            );
          },
      children: [
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.red,
            alignment: textAlignment,
            child: Text(
              "flex: 1",
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Container(
            color: Colors.green,
            alignment: textAlignment,
            child: Text(
              "flex: 2",
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(
            color: Colors.blue,
            alignment: textAlignment,
            child: Text(
              "flex: 3",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.purple,
            alignment: textAlignment,
            child: Text(
              "flex: 1",
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
      ],
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

  Widget buildInnerShadow() {
    return Container(
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: const LinearGradient(
          colors: [Color(0x99F9F9F9), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: const Border(top: BorderSide(color: Colors.white)),
      ),
      child: GestureDetector(
        onTap: () {
          DLog.d("onTap");
        },
        child: NInnerShadow(
          borderRadius: BorderRadius.circular(8),
          shadows: [
            // BoxShadow(
            //   color: Color.fromRGBO(255, 254, 233, 0.50),
            //   offset: Offset(0, 5),
            //   blurRadius: 16,
            // ),
          ],
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [Color(0xFFFED47A), Color(0xFFFCBF67), Color(0xFFF29E4E), Color(0xFFE99676)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: NText('进入诊室', color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
