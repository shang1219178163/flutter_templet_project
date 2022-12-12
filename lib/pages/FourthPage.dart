import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:get/get.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

class FourthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Get.isDarkMode ? APPThemeSettings.instance.darkThemeData : APPThemeSettings.instance.themeData,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.arrow_back),
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
                Icon(Icons.beach_access, color: Colors.orange)
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => ddlog('floatingActionButton'),
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }
}