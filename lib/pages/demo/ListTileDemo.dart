//
//	ListTileDemo.dart.swift
//	MacTemplet
//
//	Created by Bin Shang on 2021/06/11 14:58
//	Copyright © 2021 Bin Shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

class ListTileDemo extends StatefulWidget {
  final String? title;

  const ListTileDemo({Key? key, this.title}) : super(key: key);

  @override
  _ListTileDemoState createState() => _ListTileDemoState();
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
    // TODO: implement initState
    // groupValue = items[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
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
              ddlog("ListTile");
            },
          ),
          CheckboxListTile(
              title: Text("CheckboxListTile"),
              subtitle: Text("subtitle"),
              value: _isSelected,
              onChanged: (value) {
                ddlog(["CheckboxListTile", value]);
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
                ddlog(["SwitchListTile", value]);
                setState(() {
                  _isSelected = value;
                });
              }),
          _buildRadioGroup(
              header: Container(
                color: Colors.lightBlue,
                alignment: Alignment.centerLeft,
                child: Text(
                  "RadioGroup 性别选择",
                ),
              ),
              footer: Container(
                  color: Colors.lightGreen,
                  alignment: Alignment.centerLeft,
                  child: Text("RadioGroup 备注信息")),
              cb: (value) {
                sexValue = value;
                debugPrint(["_buildRadioGroup", sexValue].toString());
              }),
        ],
      )),
    );
  }

  /// 一组选项
  _buildRadioGroup(
      {List items = const <String>[
        "男",
        "女",
      ],
      String groupValue = "男",
      ValueChanged<String>? cb,
      Widget? header,
      Widget? footer}) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
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
}
