import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/basicWidget/NNPopupRoute.dart';
import 'package:flutter_templet_project/basicWidget/upload_button.dart';
import 'package:flutter_templet_project/extensions/button_extension.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';
import 'package:flutter_templet_project/extensions/navigator_extension.dart';

import 'package:flutter_templet_project/extensions/globalKey_extension.dart';
import 'package:flutter_templet_project/extensions/navigator_extension.dart';

import 'package:flutter_templet_project/network/fileManager.dart';
import 'package:flutter_templet_project/basicWidget/hud/progresshud.dart';

import 'package:styled_widget/styled_widget.dart';
import 'package:tuple/tuple.dart';

class SecondPage extends StatefulWidget {
  final String? title;

  SecondPage({Key? key, this.title}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  bool _isList = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: BackButton(
        //           color: Colors.white,
        //           onPressed: (){ NavigatorExt.popPage(context); }
        //           ),
        // // .gestures(onTap: ()=> ddlog("back")
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
        title: Text(widget.title ?? "$widget"),
      ),
      body: Center(
        child: _isList ? buildListView() : buildGridView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          APPThemeSettings.instance.changeTheme();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  GlobalKey _globalKey = GlobalKey();
  GlobalKey _globalKey1 = GlobalKey();

  buildListView() {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.send),
              label: Text("ElevatedButton"),
              key: _globalKey,
              onPressed: () {
                // _showCustomPopView();
                ddlog([_globalKey.offset(), _globalKey.size()]);
                // test();
              },
            ),
            Divider(),
            OutlinedButton.icon(
              icon: Icon(Icons.add),
              label: Text("OutlinedButton"),
              key: _globalKey1,
              onPressed: () {
                ddlog([_globalKey1.offset(), _globalKey1.size()]);
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "TextButton",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
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
                      ).padding(right: 5),
                      // SizedBox(width: 30),
                      Icon(Icons.call),
                    ],
                  ).decorated(
                      borderRadius: BorderRadius.all(Radius.circular(0))),
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
            SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "TextButtonExt",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              TextButtonExt.build(
                  text: Text("菜单left"),
                  image: Icon(Icons.info),
                  imageAlignment: ImageAlignment.left,
                  callback: (value) {
                    ddlog(value.data);
                  }),
              TextButtonExt.build(
                  text: Text("菜单right"),
                  image: Icon(Icons.info),
                  imageAlignment: ImageAlignment.right,
                  callback: (value) {
                    ddlog(value.data);
                  }),
              TextButtonExt.build(
                  text: Text("菜单top"),
                  image: Icon(Icons.info),
                  imageAlignment: ImageAlignment.top,
                  callback: (value) {
                    ddlog(value.data);
                  }),
              TextButtonExt.build(
                  text: Text("菜单bottom"),
                  image: Icon(Icons.info),
                  imageAlignment: ImageAlignment.bottom,
                  callback: (value) {
                    ddlog(value.data);
                  }),
            ]),
            Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "IconButton",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ToggleButtons",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            buildToggleButtons(context),
            Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "FloatingActionButton",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            FloatingActionButton(
              mini: true,
              backgroundColor: const Color(0xff03dac6),
              foregroundColor: Colors.black,
              onPressed: () {
                ddlog("FloatingActionButton");
              },
              child: Icon(Icons.open_with),
            ),
            SizedBox(
              height: 10,
            ),
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "DropdownButton",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            _buildDropdownButton(),

            Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "UploadButton",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            UploadButton(
              image: Image.asset("images/img_update.png", fit: BoxFit.fill, width: 130, height: 130,),
              placeholderImage: Image.asset("images/icon_delete.png", fit: BoxFit.fill, width: 25, height: 25,),
              onPressed: () {
                ddlog("onPressed");
              },
              onDetele: (){
                ddlog("onDetele");
              },
            ),

            Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "SpreadArea",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            _buildSpreadArea(),
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
      children: _tuples
          .map((e) => GridTile(
                footer: Container(
                    color: Colors.green,
                    height: 25,
                    child: Center(child: Text(e.item1))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      e.item2,
                    ]),
              ))
          .toList(),
    );
  }

  List<Tuple2<String, Widget>> get _tuples {
    return <Tuple2<String, Widget>>[
      Tuple2(
        "ElevatedButton",
        ElevatedButton.icon(
          icon: Icon(Icons.send),
          label: Text("ElevatedButton"),
          key: _globalKey,
          onPressed: () {
            // _showCustomPopView();
            ddlog([_globalKey.offset(), _globalKey.size()]);
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
            ddlog([_globalKey1.offset(), _globalKey1.size()]);
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
              ).padding(right: 5),
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
            callback: (value) {
              ddlog(value.data);
            }),
      ),

      Tuple2(
          "TextButtonExt",
          TextButtonExt.build(
              text: Text("菜单left"),
              image: Icon(Icons.info),
              imageAlignment: ImageAlignment.left,
              callback: (value) {
                ddlog(value.data);
              })),

      Tuple2(
        "TextButtonExt",
        TextButtonExt.build(
            text: Text("菜单right"),
            image: Icon(Icons.info),
            imageAlignment: ImageAlignment.right,
            callback: (value) {
              ddlog(value.data);
            }),
      ),

      Tuple2(
          "TextButtonExt",
          TextButtonExt.build(
              text: Text("菜单top"),
              image: Icon(Icons.info),
              imageAlignment: ImageAlignment.top,
              callback: (value) {
                ddlog(value.data);
              })),

      Tuple2(
        "TextButtonExt",
        TextButtonExt.build(
            text: Text("菜单bottom"),
            image: Icon(Icons.info),
            imageAlignment: ImageAlignment.bottom,
            callback: (value) {
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
        buildToggleButtons(context),
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

  List<bool> _selecteds = [false, false, true];

  buildToggleButtons(BuildContext context) {
    return ToggleButtons(
      isSelected: _selecteds,
      children: <Widget>[
        Icon(Icons.format_align_right),
        Icon(Icons.format_align_center),
        Icon(Icons.format_align_left),
      ],
      onPressed: (index) {
        setState(() {
          _selecteds[index] = !_selecteds[index];
        });
      },
    );
  }

  var _dropValue = '语文';

  _buildDropdownButton() {
    var list = ['语文', '数学', '英语'];
    return DropdownButton(
      value: _dropValue,
      items: list
          .map(
            (e) => DropdownMenuItem(
              child: Text(e),
              value: e,
            ),
          )
          .toList(),
      onChanged: (value) {
        ddlog(value);
        if (value == null) return;
        setState(() {
          _dropValue = value as String;
        });
      },
    );
  }


  _buildSpreadArea() {
    return GestureDetector(
      ///这里设置behavior
      behavior: HitTestBehavior.translucent,
      onTap: (){
        ddlog("GestureDetector");
      },
      child: Container(
        // height: 50,
        // width: 100,
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: OutlinedButton(
            onPressed: () {
              ddlog("OutlinedButton");
            },
            child:Text("OutlinedButton")),
      ),
    );
  }

  _showCustomPopView() {
    Navigator.push(
      context,
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

}
