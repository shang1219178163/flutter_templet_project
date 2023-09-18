

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';

class SwitchDemo extends StatefulWidget {

  SwitchDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _SwitchDemoState createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<SwitchDemo> {
  bool light = true;

  bool value = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody()
    );
  }

  buildBody() {
    return Column(
      children: [
        Switch(
          // activeThumbImage: Image,
          value: value,
          onChanged: (val){
            value = val;
            setState(() {});
          }
        ),
        Switch(
          thumbIcon: MaterialStateProperty.all(Icon(Icons.add)),
          activeThumbImage: "icon_arrow_down.png".toAssetImage(),
          inactiveThumbImage: "icon_arrow_up.png".toAssetImage(),
          value: value,
          onChanged: (val){
            value = val;
            setState(() {});
          }
        ),
      ],
    );
  }

}