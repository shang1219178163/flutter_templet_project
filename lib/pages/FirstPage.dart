import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';

class FirstPage extends StatefulWidget {

  final String? title;
  FirstPage({Key? key, this.title}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool _hiddenAppBar = false;

  void _changeAppBarState() {
    setState(() {
      _hiddenAppBar = !_hiddenAppBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Get.isDarkMode ? APPThemeSettings.instance.darkThemeData : APPThemeSettings.instance.themeData,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: _hiddenAppBar ? null : AppBar(
            // leading: Icon(Icons.arrow_back)
            //       // .gestures(onTap: ()=> ddlog("back")
            //         .gestures(onTap: (){
            //           NavigatorExt.popPage(context);
            //           // Navigator.popPage(context);
            //           // if (!Navigator.canPop(context)) {
            //           //   ddlog("已经是根页面了！");
            //           //   return;
            //           // }
            //           // Navigator.pop(context);
            //         }),

            title: Text("$this"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Icon(_hiddenAppBar == false ? Icons.bedtime : Icons.beach_access,
                    color: _hiddenAppBar == false ? Colors.yellow : Colors.black)
                    .padding(all: 10)
                    .decorated(color: Color(0xff7AC1E7), shape: BoxShape.circle)
                    .padding(all: 15)
                    .decorated(color: Color(0xffE8F2F7), shape: BoxShape.circle)
                    .padding(all: 20)
                    .card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                    .alignment(Alignment.center)
                    .backgroundColor(Color(0xffEBECF1))
                // .gestures(onTap: () => print('${this}_${DateTime.now()} RaisedButton pressed'))
                // .gestures(onTap: () => logger.info('${this}_${DateTime.now()} RaisedButton pressed'))
                // .gestures(onTap: () => print('${DateTime.now()} RaisedButton pressed'))
                //  .gestures(onTap: () => ddlog('RaisedButton pressed'))
                //  .gestures(onTap: () => ddlog('RaisedButton pressed'))
                    .gestures(onTap: _changeAppBarState)

              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Increment',
            child: Icon(Icons.add),
            onPressed: () => ddlog('floatingActionButton'),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }
}
