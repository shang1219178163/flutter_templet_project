import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/basicWidget/NNPopupRoute.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';
import 'package:flutter_templet_project/extensions/navigator_extension.dart';
import 'package:flutter_templet_project/extensions/popupMenuButton_extension.dart';
import 'package:flutter_templet_project/extensions/globalKey_extension.dart';
import 'package:flutter_templet_project/extensions/navigator_extension.dart';

import 'package:flutter_templet_project/network/fileManager.dart';
import 'package:flutter_templet_project/basicWidget/hud/progresshud.dart';

import 'package:styled_widget/styled_widget.dart';


class SecondPage extends StatefulWidget {

  final String? title;
  SecondPage({ Key? key, this.title}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            // leading: BackButton(
            //           color: Colors.white,
            //           onPressed: (){ NavigatorExt.popPage(context); }
            //           ),
            // // .gestures(onTap: ()=> ddlog("back")
            title: Text(widget.title ?? "$widget"),
            actions: [
              PopupMenuButtonExt.fromEntryFromJson(
                  json: {"aa": "0",
                    "bb": "1",
                    "cc": "2"},
                  checkedString: "aa",
                  offset: Offset(0, 60),
                  callback: (value) {
                    setState(() => ddlog(value));
                  }),

              PopupMenuButtonExt.fromCheckList(
                  list: ["a", "b", "c"],
                  checkedIdx: 1,
                  offset: Offset(0, 60),
                  callback: (value) {
                    setState(() => ddlog(value));
                  }),
            ],
          ),
          body: Center(
            child: buildListView(context),
            // child: ColorFiltered(colorFilter: ColorFilter.mode(Colors.grey, BlendMode.saturation),
            //   child: buildListView(context),
            // ),

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
  // late RenderBox renderBox;

  buildListView(BuildContext context) {

    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
              style: Theme.of(context).textTheme.bodyText1,
            ).padding(left: 15, right: 15),

            ElevatedButton.icon(
              icon: Icon(Icons.send),
              label: Text("ElevatedButton"),
              // onPressed: () => ddlog('pressed'),
              key: _globalKey,
              onPressed: (){
                // _showCustomPopView();
                ddlog([_globalKey.offset(), _globalKey.size()]);
                // test();
              },
            ),
            OutlinedButton.icon(
              icon: Icon(Icons.add),
              label: Text("OutlinedButton"),
              key: _globalKey1,
              onPressed: (){
                ddlog([_globalKey1.offset(), _globalKey1.size()]);
                // test();
              },
            ),

            TextButton(
              onPressed: () => ddlog('$this'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('TextButton',
                  ).padding(right: 5),
                  // SizedBox(width: 30),
                  Icon(Icons.call),
                ],
              ).decorated(borderRadius: BorderRadius.all(Radius.circular(0))),
            ).decorated(borderRadius: BorderRadius.all(Radius.circular(5))),

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
            ).decorated(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                    width: 1.0, color: Theme.of(context).buttonColor)),

            // WidgetExt.buildBtn("菜单", Icon(Icons.send), ImageAlignment.right),
            TextButtonExt.build(
                text: Text("个人信息"),
                image: Icon(Icons.person),
                imageAlignment: ImageAlignment.right,
                callback: (value) {
                  ddlog(value.data);
                }),

            TextButtonExt.build(
                text: Text("菜单left"),
                image: Icon(Icons.info),
                imageAlignment: ImageAlignment.left,
                callback: (value) {
                  ddlog(value.data);
                }).decorated(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border:
                  Border.all(width: 1.0, color: Theme.of(context).primaryColor),
            ),

            SizedBox(
              height: 10,
            ),
            TextButtonExt.build(
                    text: Text("菜单right"),
                    image: Icon(Icons.info),
                    imageAlignment: ImageAlignment.right,
                    callback: (value) {
                      ddlog(value.data);
                    })
                .decorated(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                        width: 1.0, color: Theme.of(context).primaryColor)),
            SizedBox(
              height: 10,
            ),

            TextButtonExt.build(
                text: Text("菜单top"),
                image: Icon(Icons.info),
                imageAlignment: ImageAlignment.top,
                callback: (value) {
                  ddlog(value.data);
                }).decorated(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border:
                  Border.all(width: 1.0, color: Theme.of(context).buttonColor),
            ),
            SizedBox(
              height: 10,
            ),

            TextButtonExt.build(
                text: Text("菜单bottom"),
                image: Icon(Icons.info),
                imageAlignment: ImageAlignment.bottom,
                callback: (value) {
                  ddlog(value.data);
                }).decorated(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border:
                  Border.all(width: 1.0, color: Theme.of(context).buttonColor),
            ),
            SizedBox(
              height: 10,
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
            buildToggleButtons(context),
          ],
        ),
      ],
    );
  }

  List<bool> _selecteds = [false, false, true];

  buildToggleButtons(BuildContext context) {
    return ToggleButtons(
      isSelected: _selecteds,
      children: <Widget>[
        Icon(Icons.local_cafe),
        Icon(Icons.fastfood),
        Icon(Icons.cake),
      ],
      onPressed: (index) {
        _selecteds[index] = !_selecteds[index];
        ddlog(_selecteds);
        setState(() {
          _selecteds[index] = !_selecteds[index];
        });
      },
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

  test() {
    var _emap = Map<String, List<String>>();
    // _emap["a"] ??= <String>[],
    _emap["a"] ??= ["1", "2", "3"];

    var list = _emap["a"];
    list!.remove("1");
    // ddlog(list);
    // ddlog(_emap);

    ddlog([list, _emap]);
  }

}
