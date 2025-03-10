import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:get/get.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

class FirstPage extends StatefulWidget {
  final String? title;
  const FirstPage({Key? key, this.title}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool _hiddenAppBar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: _hiddenAppBar
              ? null
              : AppBar(
                  title: Text('$widget'),
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
                InkWell(
                  onTap: _changeAppBarState,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xffEBECF1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(_hiddenAppBar == false ? Icons.bedtime : Icons.beach_access,
                        color: _hiddenAppBar == false ? Colors.yellow : Colors.black),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Increment',
            onPressed: () => DLog.d('floatingActionButton'),
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }

  void _changeAppBarState() {
    _hiddenAppBar = !_hiddenAppBar;
    setState(() {});
  }
}
