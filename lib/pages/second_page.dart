import 'dart:math';

import 'package:dash_painter/dash_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_templet_project/basicWidget/GradientBoundPainter.dart';
import 'package:flutter_templet_project/basicWidget/after_layout_builder.dart';
import 'package:flutter_templet_project/basicWidget/n_button.dart';
import 'package:flutter_templet_project/basicWidget/n_dash_decoration.dart';
import 'package:flutter_templet_project/basicWidget/n_painter_arc.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_text_button.dart';
import 'package:flutter_templet_project/basicWidget/radial_button.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/triangle_decoration.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/decoration_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/pages/demo/CirclePainter.dart';
import 'package:flutter_templet_project/basicWidget/n_popup_route.dart';
import 'package:flutter_templet_project/basicWidget/upload_button.dart';
import 'package:flutter_templet_project/extension/button_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/pages/demo/curve_painter.dart';
import 'package:flutter_templet_project/util/tool_util.dart';

import 'package:tuple/tuple.dart';

class SecondPage extends StatefulWidget {
  final String? title;

  const SecondPage({Key? key, this.title}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  bool _isList = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          IconButton(
            icon: Icon(Icons.change_circle_outlined),
            color: Colors.white,
            onPressed: () {
              debugPrint("AppUti.navigatorKey: ${ToolUtil.navigatorKey.currentWidget}");

              _isList = !_isList;
              setState(() {});
            },
          ),
        ],
      ),
      body: Center(
        child: _isList ? buildListView() : buildGridView(),
      ),
    );
  }

  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey _globalKey1 = GlobalKey();

  Widget buildBtnColor() {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.green;
          }
          return Colors.black87; // Defer to the widget's default.
        }),
      ),
      child: Text(
        '长按变色',
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  buildListView() {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            NSectionBox(
              title: "NButton",
              child: buildNButton(),
            ),
            NSectionBox(
              title: "MaterialState",
              child: buildBtnColor(),
            ),
            NSectionBox(
              title: "RadialButton",
              child: Column(
                children: [
                  ...[
                    Alignment.topRight,
                    Alignment.centerRight,
                    Alignment.bottomRight,
                    Alignment.center,
                  ]
                      .map((e) => RadialButton(
                            text: Text('一二'),
                            center: e,
                            onTap: () => debugPrint("RadialButton"),
                          ))
                      .toList(),
                  ...[
                    Alignment.topRight,
                    Alignment.centerRight,
                    Alignment.bottomRight,
                  ]
                      .map((e) => RadialButton(
                            text: Text('一二三四五六'),
                            center: e,
                            onTap: () => debugPrint("RadialButton"),
                          ))
                      .toList(),
                ],
              ),
            ),
            NSectionBox(
              title: "AfterLayoutBuilder",
              child: AfterLayoutBuilder(
                builder: (BuildContext context, Widget? child, Size? size) {
                  debugPrint("AfterLayoutBuilder size:$size");
                  if (size == null) {
                    return child ?? SizedBox();
                  }
                  return Container(
                    color: Colors.greenAccent,
                    child: child,
                  );
                },
                child: Container(padding: EdgeInsets.all(10), child: SelectableText("离离原上草, 一岁一枯荣")),
              ),
            ),
            NSectionBox(
              title: "LinearGradient",
              child: _buildGradientButton(
                onTap: () => debugPrint("LinearGradient"),
              ),
            ),
            NSectionBox(
              title: "MaterialButton",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    elevation: 0,
                    color: context.primaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    onPressed: () => debugPrint("MaterialButton: ${DateTime.now()}"),
                    child: Text(
                      "MaterialButton",
                    ),
                  ),
                  MaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    minWidth: 0,
                    textColor: context.primaryColor,
                    // color: Colors.green,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: context.primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onPressed: () {
                      debugPrint("MaterialButton");
                    },
                    child: NPair(
                      icon: Icon(Icons.info),
                      child: Text("MaterialButton"),
                    ),
                  ),
                ],
              ),
            ),
            NSectionBox(
              title: "BackButton",
              child: BackButton(
                color: Colors.red,
                style: ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.all(1)),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: MaterialStatePropertyAll(Size(24, 24)),
                  // fixedSize: MaterialStatePropertyAll(Size(24, 24)),
                ),
                onPressed: () => debugPrint("BackButton"),
              ).toColoredBox(),
            ),
            NSectionBox(
              title: "IconButton",
              child: IconButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size(50, 18),
                  // backgroundColor: Colors.green.withOpacity(0.1),
                  // foregroundColor: Colors.green,
                ),
                tooltip: '这是一个图标按钮',
                icon: Icon(Icons.arrow_back_ios_new),
                iconSize: 30,
                color: Theme.of(context).colorScheme.primary,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {
                  ddlog("这是一个图标按钮");
                },
              ).toColoredBox(),
            ),
            NSectionBox(
              title: "FilledButton",
              child: Row(
                children: [
                  FilledButton(
                    onPressed: () => ddlog('TextButton'),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("TextButton"),
                        SizedBox(width: 5),
                        Icon(Icons.send),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            NSectionBox(
              title: "TextButton",
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => ddlog('TextButton'),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("TextButton"),
                        SizedBox(width: 5),
                        Icon(Icons.send),
                      ],
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      // padding: EdgeInsets.zero,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size(50, 18),
                      backgroundColor: Colors.green.withOpacity(0.1),
                      foregroundColor: Colors.green,
                    ),
                    onPressed: () => ddlog('TextButton'),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("TextButton"),
                        SizedBox(width: 5),
                        Icon(Icons.send),
                      ].reversed.toList(),
                    ),
                  ),
                ],
              ),
            ),
            NSectionBox(
              title: "OutlinedButton",
              child: OutlinedButton.icon(
                key: _globalKey1,
                icon: Icon(Icons.add),
                label: Text("OutlinedButton"),
                onPressed: () {
                  ddlog(_globalKey1.currentContext?.frame);
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  side:
                      BorderSide(width: 1.0, color: Theme.of(context).colorScheme.secondary, style: BorderStyle.solid),
                ),
              ),
            ),
            NSectionBox(
              title: "ElevatedButton",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: TextDirection.values.reversed.map((e) {
                  return Directionality(
                      textDirection: e,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          debugPrint("ElevatedButton");
                        },
                        icon: Icon(
                          Icons.send,
                        ),
                        label: Text("ElevatedButton"),
                      ));
                }).toList(),
              ),
            ),
            NSectionBox(
              title: "ElevatedButton",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      elevation: 4,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      debugPrint("Elevated");
                    },
                    child: Text('Elevated Button'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      elevation: 4,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      debugPrint("Elevated");
                    },
                    child: const Center(child: Icon(Icons.add)),
                  ),
                ],
              ),
            ),
            NSectionBox(
              title: "ElevatedButton OutlinedBorder",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.red),
                  ),
                  StadiumBorder(
                    side: BorderSide(width: 1, style: BorderStyle.solid),
                  ),
                  CircleBorder(
                      // side: BorderSide(color: Colors.yellow, width: 2, style: BorderStyle.solid),
                      // eccentricity: 0.0,
                      ),
                ].map((e) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size(50, 18),
                      shape: e,
                    ),
                    onPressed: () {
                      debugPrint("ElevatedButton ButtonStyle");
                    },
                    child: Text(
                      "确定",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            NSectionBox(
              title: "FloatingActionButton",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton.extended(
                    extendedIconLabelSpacing: 0,
                    elevation: 0,
                    // isExtended: false,
                    extendedPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    backgroundColor: const Color(0xff03dac6),
                    // foregroundColor: Colors.black,
                    onPressed: () {
                      ddlog("FloatingActionButton.extended");
                    },
                    icon: SizedBox(),
                    label: Text('EXTEND'.toLowerCase()),
                  ),
                  FloatingActionButton(
                    mini: true,
                    elevation: 0,
                    backgroundColor: const Color(0xff03dac6),
                    // foregroundColor: Colors.black,
                    onPressed: () {
                      ddlog("FloatingActionButton");
                    },
                    child: Icon(Icons.open_with),
                  ),
                  FloatingActionButton.extended(
                    elevation: 0,
                    // isExtended: false,
                    extendedPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    backgroundColor: const Color(0xff03dac6),
                    // foregroundColor: Colors.black,
                    onPressed: () {
                      ddlog("FloatingActionButton.extended");
                    },
                    icon: Icon(Icons.add),
                    label: Text('EXTEND'.toLowerCase()),
                  ),
                ],
              ),
            ),
            NSectionBox(
              title: "TextSelectionToolbarTextButton",
              child: TextSelectionToolbarTextButton(
                padding: EdgeInsets.all(8),
                onPressed: () {
                  debugPrint("TextSelectionToolbarTextButton");
                },
                child: Text("TextSelectionToolbarTextButton"),
              ),
            ),
            NSectionBox(
              title: "NPair + OutlinedButton",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: iconDirectionItems()
                    .map((e) => OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(8.0),
                            // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            side: BorderSide(color: ColorExt.random),
                          ),
                          onPressed: () {
                            debugPrint("TextButton");
                          },
                          child: e,
                        ))
                    .toList(),
              ),
            ),
            NSectionBox(
              title: "NPair + ElevatedButton",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: iconDirectionItems()
                    .map((e) => Flexible(
                          child: ElevatedButton(
                            // style: ElevatedButton.styleFrom(
                            //   padding: EdgeInsets.zero,
                            //   // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            //   side: BorderSide(color: ColorExt.random),
                            // ),
                            onPressed: () {
                              debugPrint("ElevatedButton");
                            },
                            child: e,
                          ).copy(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(8.0),
                              // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              // side: BorderSide(color: ColorExt.random),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            NSectionBox(
              title: "ToggleButtons",
              child: buildToggleButtons(),
            ),
            NSectionBox(title: "DropdownButton", child: _buildDropdownButton()),
            NSectionBox(title: "_buildDropdownButton1", child: _buildDropdownButton1()),
            NSectionBox(title: "_buildPopupMenuButtonExt", child: _buildPopupMenuButtonExt()),
            NSectionBox(
              title: "UploadButton",
              child: UploadButton(
                image: Image.asset(
                  "img_update.png".toPath(),
                  fit: BoxFit.fill,
                  width: 100,
                  height: 100,
                ),
                deteleImage: Image.asset(
                  "icon_delete.png".toPath(),
                  fit: BoxFit.fill,
                  width: 25,
                  height: 25,
                ),
                onPressed: () {
                  ddlog("onPressed");
                },
                onDetele: () {
                  ddlog("onDetele");
                },
              ),
            ),
            NSectionBox(
              title: "SpreadArea",
              child: Column(
                children: [
                  OutlinedButton(
                      onPressed: () {
                        ddlog("OutlinedButton");
                      },
                      child: Text("OutlinedButton")),
                  GestureDetector(
                    ///这里设置behavior
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      ddlog("onTap");
                    },
                    child: Container(
                      color: Colors.yellow,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: OutlinedButton(
                          onPressed: () {
                            ddlog("OutlinedButton");
                          },
                          child: Text("OutlinedButton")),
                    ),
                  )
                ],
              ),
            ),
            NSectionBox(title: "_buildCustomPaint", child: _buildCustomPaint()),
            NSectionBox(
              title: "MyPainterArc",
              child: Container(
                height: 100,
                width: 120,
                // color: Colors.green,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: CustomPaint(
                    painter: NPainterArc(
                      color: Colors.yellow,
                      percent: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            NSectionBox(
              title: "_buildInkWell",
              child: _buildInkWell(),
            ),
            NSectionBox(
              title: "_buildButtonBar",
              child: ButtonBar(
                children: [
                  'Ok',
                  'Cancel',
                ]
                    .map((e) => ElevatedButton(
                          onPressed: () {
                            debugPrint(e);
                          },
                          child: Text(e),
                        ))
                    .toList(),
              ),
            ),
            Container(
              height: 100,
              width: 100,
              child: CustomPaint(
                painter: CurvePainter(
                  color: Colors.yellow,
                ),
              ),
            ),
            Container(
              width: 160,
              height: 60,
              decoration: NDashDecoration(
                step: 4,
                // pointWidth: 2,
                // pointCount: 1,
                radius: Radius.circular(15),
                strokeWidth: 1,
                strokeColor: Colors.red,
              ),
              alignment: Alignment.center,
              child: Text("自定义虚线\nNDashDecoration"),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: 160,
              height: 60,
              decoration: DashDecoration(
                step: 5,
                span: 5,
                // pointCount: 0,
                pointWidth: 1,
                radius: Radius.circular(15),
                gradient: SweepGradient(
                  colors: [Colors.blue, Colors.red, Colors.yellow, Colors.green],
                ),
              ),
              alignment: Alignment.center,
              child: Text("dash_painter"),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: TriangleDecoration(color: Colors.red, size: 8.0),
              child: NText("TriangleDecoration"),
            ),
            SizedBox(height: 20),
            _buildGradientBound(),
            SizedBox(height: 20),
            buildElevatedButtonGradient(
              width: 300,
              title: 'ElevatedButton',
              onPressed: () {},
            ),
            buildMaterialButtonGradient(
              onPressed: () {
                ddlog("buildMaterialButtonGradient");
              },
            ),
            buildMaterialButtonGradient(
              onPressed: null,
            ),
            MaterialButton(
              onPressed: () {},
              elevation: 0,
              disabledElevation: 0,
              textColor: Colors.white,
              disabledTextColor: Colors.white,
              color: Colors.blue.withOpacity(0.5),
              disabledColor: Colors.grey.withOpacity(0.5),
              child: Text("Button"),
            ),
            MaterialButton(
              onPressed: null,
              elevation: 0,
              disabledElevation: 0,
              textColor: Colors.white,
              disabledTextColor: Colors.white,
              color: Colors.blue.withOpacity(0.5),
              disabledColor: Colors.grey.withOpacity(0.5),
              child: Text("Button"),
            )
          ],
        ),
      ],
    );
  }

  Widget buildNButton() {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final spacing = 8.0;
      final rowCount = 3.0;
      final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

      return Wrap(spacing: spacing, runSpacing: spacing, crossAxisAlignment: WrapCrossAlignment.center, children: [
        ...[
          NButton(
            title: "NButton",
            onPressed: () {
              DLog.d("NButton");
            },
          ),
          NButton(
            title: "NButton: 禁用",
            enable: false,
            onPressed: () {},
          ),
          NButton(
            title: "NButton: red",
            primary: Colors.red,
            onPressed: () {},
          ),
          NButton.tonal(
            title: "NButton.tonal",
            // primary: Colors.red,
            // border: Border.all(color: Colors.transparent),
            onPressed: () {},
          ),
          NButton.tonal(
            title: "NButton.tonal",
            primary: Colors.red,
            // border: Border.all(color: Colors.transparent),
            onPressed: () {},
          ),
          NButton.tonal(
            primary: Colors.white,
            title: "NButton.tonal",
            style: TextStyle(color: Colors.black87),
            border: Border.all(color: Color(0xffe4e4e4)),
            onPressed: () {},
          ),
          NButton.tonal(
            primary: Colors.black87,
            title: "NButton.tonal1",
            border: Border.all(color: Colors.transparent),
            backgroudColor: Color(0xffF3F3F3),
            // gradient: LinearGradient(
            //   colors: [Colors.green, Colors.red],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            onPressed: () {},
          ),
          NButton.tonal(
            primary: Colors.black87,
            title: "tonal",
            border: Border.all(color: Colors.transparent),
            backgroudColor: Colors.transparent,
            onPressed: () {},
          ),
          NButton.text(
            // primary: Colors.red,
            title: "NButton.text",
            onPressed: () {},
          ),
        ]
            .map((e) => Container(
                  width: itemWidth.truncateToDouble(),
                  // padding: const EdgeInsets.all(8.0),
                  child: e,
                ))
            .toList(),
        NButton.text(
          // primary: Colors.red,
          width: 26,
          child: Icon(Icons.arrow_back_ios_new, color: Colors.blue),
          onPressed: () {},
        ),
      ]);
    });
  }

  /// icon 上下左右
  List<NPair> iconDirectionItems() {
    return [
      NPair(
        icon: Icon(Icons.info),
        child: Text("left"),
      ),
      NPair(
        icon: Icon(Icons.info),
        isReverse: true,
        child: Text("right"),
      ),
      NPair(
        icon: Icon(Icons.info),
        direction: Axis.vertical,
        child: Text("top"),
      ),
      NPair(
        icon: Icon(Icons.info),
        direction: Axis.vertical,
        isReverse: true,
        child: Text("bottom"),
      ),
    ];
  }

  buildGridView() {
    return GridView.count(
      padding: EdgeInsets.all(15.0),
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 4 / 3,
      children: _tuples
          .map((e) => GridTile(
                footer: Container(color: Colors.green, height: 25, child: Center(child: Text(e.item1))),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  e.item2,
                ]),
              ))
          .toList(),
    );
  }

  List<Tuple2<String, Widget>> get _tuples {
    return <Tuple2<String, Widget>>[
      Tuple2(
        "ClipRRectGradientButton",
        _buildGradientButton(),
      ),
      Tuple2(
        "ElevatedButton",
        ElevatedButton.icon(
          icon: Icon(Icons.send),
          label: Text("ElevatedButton"),
          key: _globalKey,
          onPressed: () {
            // _showCustomPopView();
            ddlog(_globalKey1.currentContext?.frame);
            // test();
          },
        ),
      ),
      Tuple2(
        "OutlinedButton",
        OutlinedButton.icon(
          icon: Icon(Icons.add),
          label: Text("OutlinedButton"),
          key: _globalKey1,
          onPressed: () {
            ddlog(_globalKey1.currentContext?.frame);
            // test();
          },
        ),
      ),
      Tuple2(
        "TextButton",
        TextButton(
          onPressed: () => ddlog('$this'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'TextButton',
              ),
              // SizedBox(width: 30),
              Icon(Icons.call),
            ],
          ),
        ),
      ),
      Tuple2(
        "TextButton",
        TextButton(
          onPressed: () => ddlog('TextButton'),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("TextButton"),
              SizedBox(width: 5),
              Icon(Icons.send),
            ],
          ),
        ),
      ),
      Tuple2(
        "IconButton",
        IconButton(
          tooltip: '这是一个图标按钮',
          icon: Icon(Icons.person),
          iconSize: 30,
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            ddlog("这是一个图标按钮");
          },
        ),
      ),
      Tuple2(
        "ToggleButtons",
        buildToggleButtons(),
      ),
      Tuple2(
        "FloatingActionButton",
        FloatingActionButton(
          mini: true,
          backgroundColor: const Color(0xff03dac6),
          foregroundColor: Colors.black,
          onPressed: () {
            ddlog("FloatingActionButton");
          },
          child: Icon(Icons.open_with),
        ),
      ),
      Tuple2(
        "FloatingActionButton",
        FloatingActionButton.extended(
          backgroundColor: const Color(0xff03dac6),
          foregroundColor: Colors.black,
          onPressed: () {
            ddlog("FloatingActionButton.extended");
          },
          icon: Icon(Icons.add),
          label: Text('EXTENDED'),
        ),
      ),
      Tuple2(
        "DropdownButton",
        _buildDropdownButton(),
      ),
    ];
  }

  final List<bool> _selecteds = [false, false, true];

  Widget buildToggleButtons() {
    return ToggleButtons(
      isSelected: _selecteds,
      onPressed: (index) {
        _selecteds[index] = !_selecteds[index];
        setState(() {});
        debugPrint("ToggleButtons _selecteds: $_selecteds");
      },
      children: <Widget>[
        Icon(Icons.format_align_right),
        Icon(Icons.format_align_center),
        Icon(Icons.format_align_left),
      ],
    );
  }

  var _dropValue = '语文';

  Widget _buildDropdownButton() {
    var list = ['语文', '数学', '英语'];
    return DropdownButton(
      value: _dropValue,
      items: list
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      onChanged: (value) {
        ddlog(value);
        if (value == null) {
          return;
        }
        setState(() {
          _dropValue = value;
        });
      },
    );
  }

  var dropdownvalue = 'Item 1';

  Widget _buildDropdownButton1() {
    var items = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
    ];

    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(color: Colors.greenAccent, border: Border.all()),
      child: DropdownButton(
        // Initial
        value: dropdownvalue,
        // Down Arrow
        icon: const Icon(Icons.keyboard_arrow_down),
        // Array list of
        items: items.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        // After selecting the desired option,it will
        // change button value to selected
        onChanged: (String? value) {
          setState(() {
            dropdownvalue = value!;
          });
        },
      ),
    );
  }

  final list = {"aa": "0", "bb": "1", "cc": "2"}.entries.toList();
  late var selectedValue = list.first;

  Widget _buildPopupMenuButtonExt() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          children: [
            PopupMenuButton(
              itemBuilder: (BuildContext context) => list.map((e) {
                return PopupMenuItem(value: e, child: Text(e.key));
              }).toList(),
              offset: Offset(0, 30),
              onSelected: (value) {
                ddlog(value);
                selectedValue = value;
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(),
                ),
                child: Text('PopupMenuButton - PopupMenuItem'),
              ),
            ),
            SizedBox(height: 8),
            PopupMenuButton(
              itemBuilder: (BuildContext context) => list.map((e) {
                return CheckedPopupMenuItem(
                  checked: e == selectedValue,
                  value: e,
                  child: Text(e.key),
                );
              }).toList(),
              offset: Offset(0, 30),
              onSelected: (value) {
                ddlog(value);
                selectedValue = value;
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(),
                ),
                child: Text('PopupMenuButton - CheckedPopupMenuItem'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomPaint() {
    return GestureDetector(
      onTap: () {
        ddlog("ontap");
      },
      child: Container(
        height: 100,
        width: 100,
        color: Colors.green,
        child: CustomPaint(
          painter: CirclePainter(
            color: Colors.yellow,
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    Gradient? gradient,
    Widget? child,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: gradient ??
              LinearGradient(
                colors: <Color>[
                  context.primaryColor,
                  context.primaryColor.withOpacity(0.5),
                ],
              ),
        ),
        child: child ??
            Text(
              "LinearGradient",
              style: TextStyle(color: Colors.white),
            ),
      ),
    );
  }

  Widget _buildGradientBound({
    Gradient? gradient,
    Widget? child,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 48,
        child: CustomPaint(
          painter: GradientBorderPainter(
              // width: constraints.maxWidth,
              // height: constraints.maxHeight,
              colors: [
                const Color(0xFFFA709A),
                const Color(0xFFFA709A).withOpacity(0.3),
              ]),
          child: Center(child: Text("GradientBoundPainter")),
        ),
      ),
    );
  }

  int _volume = 0;
  Widget _buildInkWell() {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          InkWell(
            splashColor: Colors.green,
            highlightColor: Colors.blue,
            onTap: () {
              _volume += 2;
              setState(() {});
            },
            child: NPair(
              direction: Axis.vertical,
              icon: Icon(Icons.ring_volume, size: 30),
              child: Text(_volume.toString(), style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      );
    });
  }

  buildElevatedButtonGradient({
    double? width,
    double? height = 45,
    required String title,
    required VoidCallback? onPressed,
    double radius = 22.5,
    Gradient? gradient,
  }) {
    bool enable = (onPressed != null);

    final borderRadius = BorderRadius.circular(radius);

    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          disabledForegroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: !enable
                ? null
                : (gradient ??
                    LinearGradient(
                      colors: [
                        Colors.red,
                        Colors.blue,
                        Colors.green,
                      ],
                    )),
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
        ));
  }

  buildMaterialButtonGradient({
    ShapeBorder shape = const StadiumBorder(),
    Gradient? gradient,
    VoidCallback? onPressed,
  }) {
    return Container(
      // width: 300,
      // height: 45,
      decoration: ShapeDecoration(
        shape: shape,
        gradient: gradient ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.orange, Colors.green],
            ),
      ),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: shape,
        onPressed: onPressed,
        disabledColor: Colors.grey,
        textColor: Colors.white,
        disabledTextColor: Colors.red,
        child: const Text(
          'MaterialButton',
          // style: TextStyle(
          //   fontSize: 14,
          // ),
        ),
      ),
    );
  }
}
