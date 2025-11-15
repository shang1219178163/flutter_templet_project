import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_resize.dart';
import 'package:flutter_templet_project/basicWidget/n_resize_switch.dart';

class SwitchDemo extends StatefulWidget {
  SwitchDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SwitchDemoState createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<SwitchDemo> {
  bool light = true;

  bool value = false;

  final thumbIcon = WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => debugPrint(e),
                  ))
              .toList(),
        ),
        body: buildBody());
  }

  buildBody() {
    return Column(
      children: [
        Switch(
          thumbIcon: thumbIcon,
          value: value,
          onChanged: (bool val) {
            value = val;
            setState(() {});
          },
        ),
        Switch(
          thumbIcon: WidgetStateProperty.all(Icon(Icons.add)),
          activeThumbImage: "icon_check_circle_selected.png".toAssetImage(),
          inactiveThumbImage: "icon_clear.png".toAssetImage(),
          value: value,
          onChanged: (val) {
            value = val;
            setState(() {});
          },
        ),
        NResizeSwitch(
          width: 40,
          height: 25,
          value: value,
          onChanged: (val) {
            value = val;
            setState(() {});
          },
        ),
        NResize(
          width: 40,
          height: 25,
          child: CupertinoSwitch(
            value: value,
            onChanged: (bool val) {
              value = val;
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
