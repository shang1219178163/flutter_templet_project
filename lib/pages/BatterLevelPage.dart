import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

class BatterLevelPage extends StatefulWidget {
  BatterLevelPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _BatterLevelPageState createState() => _BatterLevelPageState();
}

class _BatterLevelPageState extends State<BatterLevelPage> {

  static const platform = const MethodChannel('samples.flutter.io/battery');
  String _batteryLevel = "Unknown battery level.";

  _getBatterLevel() async{
    String batteryLevel;

    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch(e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
    setState((){
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Icon(Icons.arrow_back)
                    .gestures(onTap: (){
                  if (!Navigator.canPop(context)) {
                    ddlog("已经是根页面了！");
                    return;
                  }
                  Navigator.pop(context);
                }),
          // Here we take the value from the BatterLevelPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title ?? "$widget"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _batteryLevel,
            ),
            OutlinedButton.icon(
              icon: Icon(Icons.search),
              label: Text("Get Battery Level"),
              onPressed: _getBatterLevel,
            ),
          ],
        ),
      ),
    );
  }
}
