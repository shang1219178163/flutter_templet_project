
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/header.dart';


class EnumDemo extends StatefulWidget {

  EnumDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _EnumDemoState createState() => _EnumDemoState();
}

class _EnumDemoState extends State<EnumDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

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
      body: buildBody(),
    );
  }

  buildBody() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header.h4(title: "ActivityTypeNew",),
            Header.h5(title: "1.ActivityTypeNew.values"),
            Container(
              child: Text(ActivityTypeNew.values.toString()),
            ),
            Divider(),
            Header.h5(title: "2. ActivityTypeNew.values.map((e) => e.name)"),
            Container(
              child: Text("${ActivityTypeNew.values.map((e) => e.name)}"),
            ),
            Divider(),
          ],
        ),
        Column(
          children: [
            Header.h4(title: "ActivityType",),
            Container(
              child: Text("${ActivityType.values.map((e) => e.name)}"),
            ),
            Container(
              child: Text("${ActivityType.values}"),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            children: ActivityType.values.map((e){

              return ListTile(
                title: Text(e.name),
                subtitle: Text("value:${e.value}, ${e.desc}, index:${e.index}"),
              );
            }).toList(),
          )
        )
      ],
    );
  }
}


enum ActivityTypeNew {
  running,
  climbing,
  hiking,
  cycling,
  Skiing,
  unknown;
}

extension ActivityTypeNewExt on ActivityTypeNew {

  static const map = {
    ActivityTypeNew.running: "跑步",
    ActivityTypeNew.climbing: "攀登",
    ActivityTypeNew.hiking: "徒步旅行",
    ActivityTypeNew.cycling: "骑行",
    ActivityTypeNew.Skiing: "滑雪",
    ActivityTypeNew.unknown: "未知",
  };

  String? get desc {
    return map[this];
  }

  static ActivityTypeNew? getTypeWithIndex(int index) {
    return ActivityTypeNew.values.firstWhere((e) => e.index == index,
        orElse: () => ActivityTypeNew.unknown,
    );
  }

  static ActivityTypeNew getTypeWithName(String name) {
    return ActivityTypeNew.values.firstWhere((e) => e.name == name,
        orElse: () => ActivityTypeNew.unknown,
    );
  }
}

enum ActivityType {

  running(1, '跑步'),

  climbing(2, '攀登'),

  hiking(5, '徒步旅行'),

  cycling(7, '骑行'),

  Skiing(10, '滑雪'),

  unknown(-1, '未知');

  const ActivityType(this.value, this.desc,);
  /// 当前枚举值对应的 int 值(非 index)
  final int value;
  /// 当前枚举对应的 描述文字
  final String desc;


  static ActivityType getTypeByTitle(String title) => ActivityType.values.firstWhere((e) => e.name == title, orElse: () => ActivityType.unknown);

  static ActivityType getType(int value) => ActivityType.values.firstWhere((e) => e.value == value, orElse: () => ActivityType.unknown);

  static int getValue(int value) => getType(value).value;

  @override
  String toString() {
    return '$desc is $value';
  }
}
