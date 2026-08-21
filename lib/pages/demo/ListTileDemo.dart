//
//	ListTileDemo.dart.swift
//	MacTemplet
//
//	Created by Bin Shang on 2021/06/11 14:58
//	Copyright © 2021 Bin Shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/dlog.dart';

class ListTileDemo extends StatefulWidget {

  const ListTileDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _ListTileDemoState createState() => _ListTileDemoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _ListTileDemoState extends State<ListTileDemo> {
  bool _isSelected = false;

  // final items = <String>[
  //   "男", "女",
  // ];
  //
  // String groupValue = "";

  String sexValue = "";

  @override
  void initState() {
    // groupValue = items[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: () => debugPrint(e),
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Material(
      child: SingleChildScrollView(
          child: Column(
        children: [
          ListTile(
            title: Text("ListTile"),
            subtitle: Text("subtitle"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              DLog.d("ListTile");
            },
          ),
          CheckboxListTile(
              title: Text("CheckboxListTile"),
              subtitle: Text("subtitle"),
              value: _isSelected,
              onChanged: (value) {
                DLog.d(["CheckboxListTile", value]);
                if (value == null) {
                  return;
                }
                _isSelected = value;
                setState(() {});
              }),
          SwitchListTile(
              title: Text("SwitchListTile"),
              subtitle: Text("subtitle"),
              value: _isSelected,
              onChanged: (value) {
                DLog.d(["SwitchListTile", value]);
                setState(() {
                  _isSelected = value;
                });
              }),
          buildRadioGroup(
              header: Container(
                color: Colors.lightBlue,
                alignment: Alignment.centerLeft,
                child: Text(
                  "RadioGroup 性别选择",
                ),
              ),
              footer:
                  Container(color: Colors.lightGreen, alignment: Alignment.centerLeft, child: Text("RadioGroup 备注信息")),
              cb: (value) {
                sexValue = value;
                debugPrint(["buildRadioGroup", sexValue].toString());
              }),
        ],
      )),
    );
  }

  /// 一组选项
  Widget buildRadioGroup(
      {List items = const <String>[
        "男",
        "女",
      ],
      String groupValue = "男",
      ValueChanged<String>? cb,
      Widget? header,
      Widget? footer}) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          if (header != null) header,
          ...items
              .map((e) => RadioListTile<String>(
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(e),
                  subtitle: Text("subtitle"),
                  value: e,
                  groupValue: groupValue,
                  selected: e == groupValue,
                  toggleable: true,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    groupValue = value;
                    cb?.call(groupValue);
                    setState(() {});
                  }))
              .toList(),
          if (footer != null) footer,
        ],
      );
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('sexValue', sexValue));
  }
}
