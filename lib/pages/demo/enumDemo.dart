import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/enum/ActivityType.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/enum_ext.dart';
import 'package:flutter_templet_project/extension/text_style_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class EnumDemo extends StatefulWidget {
  EnumDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _EnumDemoState createState() => _EnumDemoState();
}

class _EnumDemoState extends State<EnumDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: onDone,
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

  onDone() {
    String? name = "${ActivityTypeNew.hiking.name}";
    name = null;
    final v = ActivityTypeNew.values.byNullableName(name);
    final v1 = ActivityTypeNew.skiing.name?.enumOf(ActivityTypeNew.values);
    final v2 = ActivityTypeNew.values.by((e) => e.name == "cycling");
    final v3 = ActivityTypeNew.values.by((e) => e.index == 2);

    DLog.d([v, v1, v2].asMap());
  }

  buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          NSectionBox(
            title: "1.ActivityTypeNew.values",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (
                  key: "byName",
                  value: ActivityTypeNew.values.byName(
                    ActivityTypeNew.hiking.name,
                  )
                ),
              ]
                  .map((e) => NPair(
                        icon: Text(e.key),
                        child: Text("${e.value}"),
                      ))
                  .toList(),
            ),
          ),
          NSectionBox(
            title: "1.ActivityTypeNew.values",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ActivityTypeNew.values.map((e) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text(e.toString()),
                      NPair(
                        icon: Text(
                          "index: ${e.index}, value: ${e.name}, desc: ${e.desc}",
                        ),
                        child: Text(""),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          NSectionBox(
            title: "2. ActivityType.values",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ActivityType.values.map((e) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text(e.toString()),
                      NPair(
                        icon: Text(
                          "index: ${e.index}, value: ${e.name}, desc: ${e.desc}",
                        ),
                        child: Text(""),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
