import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/basicWidget/after_layout_builder.dart';
import 'package:flutter_templet_project/basicWidget/radial_button.dart';
import 'package:flutter_templet_project/basicWidget/section_header.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/decoration_ext.dart';
import 'package:flutter_templet_project/pages/demo/MyPainter.dart';
import 'package:flutter_templet_project/basicWidget/nn_popup_route.dart';
import 'package:flutter_templet_project/basicWidget/gesture_detector_container.dart';
import 'package:flutter_templet_project/basicWidget/upload_button.dart';
import 'package:flutter_templet_project/extension/button_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

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
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          IconButton(
            icon: Icon(Icons.change_circle_outlined),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _isList = !_isList;
              });
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

  buildListView() {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SectionHeader.h5(title: "color"),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: Color(0xfff44336),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
            ),
            SectionHeader.h5(title: "RadialButton"),
            RadialButton(
              text: Text('一二'),
              center: Alignment.topRight,
              onTap: () => print("RadialButton"),
            ),
            RadialButton(
              text: Text('一二'),
              center: Alignment.centerRight,
              onTap: () => print("RadialButton"),
            ),
            RadialButton(
              text: Text('一二'),
              center: Alignment.bottomRight,
              onTap: () => print("RadialButton"),
            ),
            RadialButton(
              text: Text('一二'),
              onTap: () => print("RadialButton"),
            ),
            RadialButton(
              text: Text('一二三'),
              center: Alignment.topRight,
              onTap: () => print("RadialButton"),
            ),
            RadialButton(
              text: Text('一二三四'),
              center: Alignment.centerRight,
              onTap: () => print("RadialButton"),
            ),
            RadialButton(
              text: Text('一二三四五六'),
              center: Alignment.bottomRight,
              onTap: () => print("RadialButton"),
            ),
            AfterLayoutBuilder(
              builder: (BuildContext context, Widget? child, Size? size) {
                print("AfterLayoutBuilder size:$size");
                if (size == null) {
                  return child ?? SizedBox();
                }
                return Container(
                  color: Colors.greenAccent,
                  child: child,
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                child: Text("离离原上草, 一岁一枯荣")
              ),
            ),
            SectionHeader.h5(title: "GradientButton"),
            _buildClipRRectGradientButton(),

            Divider(),
            SectionHeader.h5(title:"MaterialButton"),
            MaterialButton(
              color: Colors.blue.shade400,
              textColor: Colors.white,
              onPressed: () => print("MaterialButton"),
              child: Text("MaterialButton"),
            ),

            Divider(),
            SectionHeader.h5(title: "BackButton"),
            BackButton(
              onPressed: () => print("BackButton"),
              color: Colors.red,
            ),
            Divider(),

            SectionHeader.h5(title: "NoSplash"),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
               ),
              onPressed: () { print("NoSplash.splashFactory"); },
               child: Text('No Splash'),
            ),
            SectionHeader.h5(title: "ElevatedButton"),
            ElevatedButton.icon(
              icon: Icon(Icons.send),
              label: Text("ElevatedButton"),
              key: _globalKey,
              onPressed: () {
                // _showCustomPopView();
                ddlog([_globalKey.currentContext?.origin(), _globalKey.currentContext?.size]);
                // test();
              },
            ),

            Divider(),
            SectionHeader.h5(title: "Directionality ElevatedButton"),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ElevatedButton.icon(
                onPressed: () { print("ElevatedButton"); },
                icon: Icon(Icons.arrow_back,),
                label: Text("ElevatedButton"),
              )
            ),

            Divider(),
            SectionHeader.h5(title: "OutlinedButton"),
            OutlinedButton.icon(
              icon: Icon(Icons.add),
              label: Text("OutlinedButton"),
              key: _globalKey1,
              onPressed: () {
                ddlog([_globalKey1.position(),
                  _globalKey1.size]);
                // test();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    width: 1.0,
                    color: Theme.of(context).colorScheme.secondary,
                    style: BorderStyle.solid),
              ),
            ),

            Divider(),
            SectionHeader.h5(title: "TextSelectionToolbarTextButton"),
            TextSelectionToolbarTextButton(
                padding: EdgeInsets.all(8),
              onPressed: (){
                  print("TextSelectionToolbarTextButton");
              },
                child: Text("TextSelectionToolbarTextButton"),
            ),

            Divider(),
            SectionHeader.h5(title: "TextButton"),
            Row(
              children: [
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
              ],
            ),

            Divider(),
            SectionHeader.h5(title: "TextButtonExt"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButtonExt.build(
                  text: Text("left"),
                  image: Icon(Icons.info),
                  imageAlignment: ImageAlignment.left,
                  side: BorderSide(width: 1.0, color: Colors.black12),
                  callback: (value, tag) {
                    ddlog([value.data, tag]);
                  }),
                TextButtonExt.build(
                  text: Text("right"),
                  image: Icon(Icons.info),
                  imageAlignment: ImageAlignment.right,
                  side: BorderSide(width: 1.0, color: Colors.blue),
                  callback: (value, tag) {
                    ddlog(value.data);
                  }),
                TextButtonExt.build(
                  text: Text("top"),
                  image: Icon(Icons.info),
                  imageAlignment: ImageAlignment.top,
                  side: BorderSide(width: 1.0, color: Colors.red),
                  callback: (value, tag) {
                    ddlog(value.data);
                  }),
                TextButtonExt.build(
                  text: Text("bottom"),
                  image: Icon(Icons.info),
                  imageAlignment: ImageAlignment.bottom,
                  side: BorderSide(width: 1.0, color: Colors.green),
                  callback: (value, tag) {
                    ddlog(value.data);
                  }),
              ]
            ),

            Divider(),
            SectionHeader.h5(title: "MaterialButton"),
            MaterialButton(
              padding: EdgeInsets.all(18),
              minWidth: 0,
              // color: Colors.green,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              onPressed: () { print("Press"); },
              child: TextButtonExt.buildTextAndImage(
                text: Text("bottom"),
                image: Icon(Icons.info),
                imageAlignment: ImageAlignment.top,
              ),
            ),

            Divider(),
            SectionHeader.h5(title: "IconButton"),
            IconButton(
              tooltip: '这是一个图标按钮',
              icon: Icon(Icons.person),
              iconSize: 30,
              color: Theme.of(context).accentColor,
              onPressed: () {
                ddlog("这是一个图标按钮");
              },
            ),

            Divider(),
            SectionHeader.h5(title: "ToggleButtons"),
            buildToggleButtons(),

            Divider(),
            SectionHeader.h5(title: "FloatingActionButton"),
            FloatingActionButton(
              mini: true,
              backgroundColor: const Color(0xff03dac6),
              foregroundColor: Colors.black,
              onPressed: () {
                ddlog("FloatingActionButton");
              },
              child: Icon(Icons.open_with),
            ),
            SizedBox(height: 10,),

            FloatingActionButton.extended(
              backgroundColor: const Color(0xff03dac6),
              foregroundColor: Colors.black,
              onPressed: () {
                ddlog("FloatingActionButton.extended");
              },
              icon: Icon(Icons.add),
              label: Text('EXTENDED'),
            ),

            Divider(),
            SectionHeader.h5(title: "DropdownButton"),
            _buildDropdownButton(),

            SectionHeader.h5(title: "_buildDropdownButton1"),
            _buildDropdownButton1(),

            SectionHeader.h5(title: "_buildPopupMenuButtonExt"),
            _buildPopupMenuButtonExt(),

            Divider(),
            SectionHeader.h5(title: "UploadButton"),
            UploadButton(
              image: Image.asset("images/img_update.png", fit: BoxFit.fill, width: 100, height: 100,),
              deteleImage: Image.asset("images/icon_delete.png", fit: BoxFit.fill, width: 25, height: 25,),
              onPressed: () {
                ddlog("onPressed");
              },
              onDetele: (){
                ddlog("onDetele");
              },
            ),

            Divider(),
            SectionHeader.h5(title: "SpreadArea"),
            OutlinedButton(
                onPressed: () {
                  ddlog("OutlinedButton");
                },
                child:Text("OutlinedButton")
            ),
            _buildSpreadArea(),

            Divider(),
            SectionHeader.h5(title: "GestureDetectorContainer"),
            GestureDetectorContainer(
              // edge: EdgeInsets.all(10),
              color: Colors.orange,
              onTap: (){
                ddlog("onTap");
              },
              child: OutlinedButton(
                onPressed: (){
                  ddlog("onPressed");
                },
                child: Text("OutlinedButton"),
              ),
            ),

            Divider(),
            SectionHeader.h5(title: "_buildCustomPaint"),
            _buildCustomPaint(),

            Divider(),
            SectionHeader.h5(title: "buildCustome"),
            _buildCustome(),
          ],
        ),
      ],
    );
  }

  buildGridView() {
    return GridView.count(
      padding: EdgeInsets.all(15.0),
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 4 / 3,
      children: _tuples.map((e) => GridTile(
        footer: Container(
          color: Colors.green,
          height: 25,
          child: Center(child: Text(e.item1))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            e.item2,
          ]
        ),
      )).toList(),
    );
  }

  List<Tuple2<String, Widget>> get _tuples {
    return <Tuple2<String, Widget>>[
      Tuple2(
      "ClipRRectGradientButton",
      _buildClipRRectGradientButton(),
      ),
      Tuple2(
        "ElevatedButton",
        ElevatedButton.icon(
          icon: Icon(Icons.send),
          label: Text("ElevatedButton"),
          key: _globalKey,
          onPressed: () {
            // _showCustomPopView();
            ddlog([_globalKey.position(), _globalKey.size]);
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
            ddlog([_globalKey1.position(), _globalKey1.size]);
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

      // WidgetExt.buildBtn("菜单", Icon(Icons.send), ImageAlignment.right),
      Tuple2(
        "TextButtonExt",
        TextButtonExt.build(
            text: Text("个人信息"),
            image: Icon(Icons.person),
            imageAlignment: ImageAlignment.right,
            callback: (value, tag) {
              ddlog(value.data);
            }),
      ),

      Tuple2(
          "TextButtonExt",
          TextButtonExt.build(
              text: Text("菜单left"),
              image: Icon(Icons.info),
              imageAlignment: ImageAlignment.left,
              callback: (value, tag) {
                ddlog(value.data);
              })),

      Tuple2(
        "TextButtonExt",
        TextButtonExt.build(
            text: Text("菜单right"),
            image: Icon(Icons.info),
            imageAlignment: ImageAlignment.right,
            callback: (value, tag) {
              ddlog(value.data);
            }),
      ),

      Tuple2(
          "TextButtonExt",
          TextButtonExt.build(
              text: Text("菜单top"),
              image: Icon(Icons.info),
              imageAlignment: ImageAlignment.top,
              callback: (value, tag) {
                ddlog(value.data);
              })),

      Tuple2(
        "TextButtonExt",
        TextButtonExt.build(
            text: Text("菜单bottom"),
            image: Icon(Icons.info),
            imageAlignment: ImageAlignment.bottom,
            callback: (value, tag) {
              ddlog(value.data);
            }),
      ),

      Tuple2(
        "IconButton",
        IconButton(
          tooltip: '这是一个图标按钮',
          icon: Icon(Icons.person),
          iconSize: 30,
          color: Theme.of(context).accentColor,
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

  buildToggleButtons() {
    return ToggleButtons(
      isSelected: _selecteds,
      onPressed: (index) {
        _selecteds[index] = !_selecteds[index];
        setState(() {});
        print("ToggleButtons _selecteds: $_selecteds");
      },
      children: <Widget>[
        Icon(Icons.format_align_right),
        Icon(Icons.format_align_center),
        Icon(Icons.format_align_left),
      ],
    );
  }

  var _dropValue = '语文';

  _buildDropdownButton() {
    var list = ['语文', '数学', '英语'];
    return DropdownButton(
      value: _dropValue,
      items: list.map((e) => DropdownMenuItem(
          value: e,
          child: Text(e),
        ),
      ).toList(),
      onChanged: (value) {
        ddlog(value);
        if (value == null) return;
        setState(() {
          _dropValue = value as String;
        });
      },
    );
  }

  var dropdownvalue = 'Item 1';

  _buildDropdownButton1() {
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

  _buildPopupMenuButtonExt() {
    return Column(
        children: [
          PopupMenuButtonExt.fromEntryFromJson(
              child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.greenAccent, border: Border.all()),
                  child: Text('PopupMenuButtonExt.fromEntryFromJson')
              ),
              json: {
                "aa": "0",
                "bb": "1",
                "cc": "2"
              },
              checkedString: "aa",
              callback: (value) {
                setState(() => ddlog(value));
              }
          ),

          PopupMenuButtonExt.fromCheckList(
              child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.greenAccent, border: Border.all()),
                  child: Text('PopupMenuButtonExt.fromCheckList')
              ),
              list: ["a", "b", "c"],
              checkedIdx: 1,
              callback: (value) {
                setState(() => ddlog(value));
              }
          ),
        ]
    );
  }

  _buildSpreadArea({EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 25)}) {
    return GestureDetector(
      ///这里设置behavior
      behavior: HitTestBehavior.translucent,
      onTap: (){
        ddlog("onTap");
      },
      child: Container(
        // height: 50,
        // width: 100,
        // color: Colors.transparent,
        color: Colors.yellow,
        padding: padding,
        child: OutlinedButton(
            onPressed: () {
              ddlog("OutlinedButton");
            },
            child:Text("OutlinedButton")),
      ),
    );
  }

  _buildCustomPaint() {
    return GestureDetector(
      onTap: (){
        ddlog("ontap");
      },
      child: Container(
        height: 100,
        width: 100,
        color: Colors.green,
        child: CustomPaint(
          painter: MyPainter(
            padding: EdgeInsets.only(top: 5, left: 10, bottom: 15, right: 20),
            color: Colors.yellow,
          ),
        ),
      ),
    );
  }

  _showCustomPopView() {
    Navigator.push(context,
      NNPopupRoute(
        child: Container(
          color: Colors.red,
          width: 91,
          height: 36,
          child: TextButton.icon(
            onPressed: () {
              ddlog("刷新");
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.refresh),
            label: Text("刷新"),
          ),
        ),
        onClick: () {
          print("exit");
        },
      ),
    );
  }

  _buildClipRRectGradientButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              primary: Colors.white,
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {},
            child: const Text('Gradient'),
          ),
        ],
      ),
    );
  }
// testPageRouteBuilder(){
// Navigator.of(context).push(
//     PageRouteBuilder(
//         barrierDismissible:true,
//         opaque:false,
//         barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//         barrierColor: Colors.black54,
//         transitionDuration: const Duration(milliseconds: 150),
//         pageBuilder: (p1, p2, p3) {
//           return Container(
//             padding: EdgeInsets.all(80),
//             color: Colors.black.withOpacity(0.3),
//             child: Container(
//               color: Colors.green,
//               child: TextButton(child: Text("button"),
//               onPressed: (){
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//           );
//         }
//     )
// ),
// }

  _buildCustome() {
    return Column(
      children: [
        SizedBox(
          height: 45,
          width: 200,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                elevation: 10, 
                shape: const StadiumBorder(),
            ),
            child: const Center(child: Text('Elevated Button')),
          ),
        ),
        SizedBox(
          height: 45,
          width: 60,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                elevation: 10, shape: const CircleBorder()),
            child: const Center(child: Icon(Icons.add)),
          ),
        ),

        Divider(),
        SectionHeader.h5(title: "UIElevatedButton"),
        UIElevatedButton(
          height: 45,
          width: 200,
          onPressed: () {
            print("Elevated");
          },
          child: Text('Elevated Button'),
        ),
        UIElevatedButton(
          height: 45,
          width: 60,
          style: ElevatedButton.styleFrom(
              elevation: 4,
              shape: const CircleBorder(),
          ),
          onPressed: () {
            print("Elevated");
          },
          child: const Center(child: Icon(Icons.add)),
        ),

        Divider(),
        SectionHeader.h5(title: "_buildInkWell"),
        _buildInkWell(),

        Divider(),
        SectionHeader.h5(title: "_buildButtonBar"),
        _buildButtonBar(),
      ],
    );
  }


  int _volume = 0;
  _buildInkWell() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          InkWell(
            splashColor: Colors.green,
            highlightColor: Colors.blue,
            onTap: () {
              setState(() {_volume += 2;});
            },
            child: Icon(Icons.ring_volume, size: 30),
          ),
          Text(_volume.toString(), style: TextStyle(fontSize: 20)),
        ],
      );
    });
  }

  _buildButtonBar() {
    return ButtonBar(
      children: ['Ok', 'Cancel', ].map((e) => ElevatedButton(
        onPressed: () {
          // To do
        },
        child: Text(e),
      )).toList(),
    );
  }


}


/// 自定义按钮
class UIElevatedButton extends StatelessWidget {

  const UIElevatedButton({
  	Key? key,
    this.width,
    this.height,
    this.child,
    required this.onPressed,
    this.style,
  }) : super(key: key);

  /// If non-null, requires the child to have exactly this width.
  final double? width;

  /// If non-null, requires the child to have exactly this height.
  final double? height;

  final Widget? child;

  final VoidCallback onPressed;

  final ButtonStyle? style;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style ?? ElevatedButton.styleFrom(
          elevation: 4,
          shape: const StadiumBorder(),
        ),
        child: child ?? const Center(child: Text('UIElevatedButton')),
      ),
    );
  }
}