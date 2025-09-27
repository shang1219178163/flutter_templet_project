//
//  ChipDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/7/21 6:13 PM.
//  Copyright © 12/7/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choice_box_one.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_tag_box.dart';
import 'package:flutter_templet_project/basicWidget/n_tag_box_new.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/mixin/cupertino_alert_dialog_mixin.dart';
import 'package:tuple/tuple.dart';

class ChipDemo extends StatefulWidget {
  final String? title;

  const ChipDemo({Key? key, this.title}) : super(key: key);

  @override
  _ChipDemoState createState() => _ChipDemoState();
}

class _ChipDemoState extends State<ChipDemo> with CupertinoAlertDialogMixin {
  final tuples = List.generate(9, (i) => (i, "选择$i")).toList();

  final tuplesNew = List.generate(9, (i) => Tuple2(i, "选择$i")).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildWrap(),
    );
  }

  int? _value = 1;

  final items = <Tuple2<String, String>>[
    const Tuple2('西药/中成药/特医', "WESTERN_MEDICINE"),
    const Tuple2('医疗器械', "MEDICAL_APPLIANCE"),
    const Tuple2('检测检验', "MEDICAL_APPLIANCE"),
    const Tuple2('中药', "CHINESE_MEDICINE"),
  ];

  late final itemCurrent = ValueNotifier(items[0]);

  Widget buildWrap({double spacing = 8.0, double runSpacing = 8.0}) {
    var titles = List<int>.generate(3, (index) => index);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSectionBox(
            title: "Chip",
            crossAxisAlignment: CrossAxisAlignment.start,
            child: Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              alignment: WrapAlignment.start, //沿主轴方向居中
              children: [
                Badge(
                  label: Text("99+"),
                  backgroundColor: Colors.red,
                  child: Chip(
                    label: Text(
                      "Chip",
                    ),
                  ),
                ),
                Chip(
                    label: Text(
                      "Chip",
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    )),
                Chip(
                  labelPadding: EdgeInsets.symmetric(horizontal: 8),
                  label: Text(
                    "带 deleteIcon的 Chip${'一二三四五六七八九十'.substring(0, 9) * 2}",
                    maxLines: 2,
                    softWrap: true,
                    // overflow: TextOverflow.ellipsis,
                  ),
                  // deleteIcon: Icon( Icons.cancel, color: Colors.black45,),
                  // onDeleted: () {
                  //   DLog.d("onDeleted: 带 deleteIcon的 Chip");
                  //   setState(() {});
                  // },
                  // deleteButtonTooltipMessage: "弹出提示",
                ),
                Chip(
                  label: Text(
                    "带 avatar 和 deleteIcon的 Chip",
                  ),
                  avatar: Image.asset("avatar.png".toPath(), fit: BoxFit.fill),
                  deleteIcon: Icon(
                    Icons.cancel,
                  ),
                  onDeleted: () {
                    DLog.d("onDeleted:带 avatar 和 deleteIcon的 Chip");
                    setState(() {});
                  },
                ),
                Chip(
                  avatar: InkWell(
                    onTap: () {
                      DLog.d("onTap:Chip");
                    },
                    child: Icon(
                      Icons.add_circle,
                    ),
                  ),
                  // avatar: IconButton(
                  //   onPressed: () { setState(() { DLog.d("add"); } ); },
                  //   padding: EdgeInsets.all(0),
                  //   icon: Icon(Icons.add_circle)) ,
                  label: Text("Chip"),
                  // deleteIcon: Icon(Icons.remove_circle),
                  deleteIcon: Icon(Icons.remove_circle),
                  onDeleted: () {
                    DLog.d("onDeleted:Chip");
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          NSectionBox(
            title: "RawChip",
            crossAxisAlignment: CrossAxisAlignment.start,
            child: Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              alignment: WrapAlignment.start, //沿主轴方向居中
              children: [
                RawChip(
                  label: Text(
                    "RawChip",
                  ),
                  avatar: Image.asset("avatar.png".toPath(), fit: BoxFit.fill),
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    DLog.d("onPressed: RawChip");
                  },
                  deleteIcon: Icon(
                    Icons.close,
                  ),
                  onDeleted: () {
                    DLog.d("onDeleted: RawChip");
                  },
                ),
                RawChip(
                  label: Text(
                    "RawChip",
                  ),
                  avatar: Icon(
                    Icons.close,
                  ),
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    DLog.d("onPressed: RawChip");
                  },
                ),
              ],
            ),
          ),
          NSectionBox(
            title: "CircleAvatar",
            crossAxisAlignment: CrossAxisAlignment.start,
            child: Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              alignment: WrapAlignment.start, //沿主轴方向居中
              children: [
                Wrap(
                  spacing: spacing,
                  runSpacing: runSpacing,
                  alignment: WrapAlignment.start, //沿主轴方向居中
                  children: titles
                      .map((e) => ActionChip(
                            avatar: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(e.toString().characters.first.toUpperCase())),
                            label: Text("Action_$e"),
                            onPressed: () {
                              _onPressed(titles.indexOf(e));
                            },
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          NChoiceBoxOne<Tuple2<String, String>>(
            items: items,
            selectedItem: itemCurrent,
            itemNameCb: (e) => e.item1,
            // numPerRow: 3,
            primaryColor: Colors.red,
            style: TextStyle(color: Colors.black87),
            styleSelected: TextStyle(
              color: Colors.red,
            ),
            canChanged: (e, onSelect) => true,
            onChanged: (e) {
              debugPrint("NChoiceBoxOne e: $e");
            },
          ),
          buildTagManager(),
          buildTagManagerNew(),
          NSectionBox(
            title: "ChoiceChip",
            crossAxisAlignment: CrossAxisAlignment.start,
            child: Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              alignment: WrapAlignment.start, //沿主轴方向居中
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: titles
                      .map(
                        (e) => ChoiceChip(
                          label: Text('Choice_$e'),
                          // padding: EdgeInsets.only(left: 8, right: 8),
                          selected: _value == e,
                          onSelected: (bool selected) {
                            DLog.d(e);
                            _value = selected ? e : null;
                            setState(() {});
                          },
                        ),
                      )
                      .toList(),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceChip(
                      label: Text('Choice 1'),
                      selected: true,
                    ),
                    ChoiceChip(
                      label: Text('Choice 2'),
                      selected: false,
                    ),
                    ChoiceChip(
                      label: Text('Choice 3'),
                      selected: false,
                    ),
                    ChoiceChip(
                      label: Text('Choice 4'),
                      selected: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          NSectionBox(
            title: "InputChip",
            crossAxisAlignment: CrossAxisAlignment.start,
            child: Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              alignment: WrapAlignment.start, //沿主轴方向居中
              children: [
                InputChip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    child: const Text('IC'),
                  ),
                  label: const Text('InputChip'),
                  onPressed: () {
                    debugPrint('onPressed: InputChip');
                  },
                ),
              ],
            ),
          ),
          FilterChip(
            label: Text('FilterChip'),
            onSelected: (val) {
              debugPrint('onSelected: $val');
            },
          ),
        ],
      ),
    );
  }

  void _onPressed(int e) {
    DLog.d(e);
  }

  /// 标签管理器
  buildTagManager() {
    return NSectionBox(
      title: "NTagBox",
      crossAxisAlignment: CrossAxisAlignment.start,
      child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return NTagBox<(int, String)>(
            keywords: "初步诊断",
            items: tuples,
            titleCb: (e) => e.$2,
            onDelete: (e) {
              tuples.remove(e);
              setState(() {});
            },
            onAdd: () {
              final id = IntExt.random(max: 100);
              tuples.add((id, "选择$id"));
              setState(() {});
            },
            onChanged: (items) {
              final titles = items.map((e) => e.$2).toList();
              debugPrint(titles.join(","));
            });
      }),
    );
  }

  /// 标签管理器
  buildTagManagerNew() {
    return NSectionBox(
      title: "NTagBoxNew",
      crossAxisAlignment: CrossAxisAlignment.start,
      child: NTagBoxNew<(int, String)>(
          keywords: "初步诊断",
          items: tuples,
          titleCb: (e) => e.$2,
          canDelete: (e, onDelete) {
            final index = tuples.indexOf(e);
            if (index % 2 != 0) {
              presentAlert(
                  titleStr: "提示",
                  contentStr: "确定删除$e",
                  onConfirm: () {
                    onDelete(e);
                  });
              return false;
            }
            return true;
          },
          onAdd: () {
            final id = IntExt.random(max: 100);
            tuples.add((id, "选择$id"));
          },
          onChanged: (items) {
            final titles = items.map((e) => e.$2).toList();
            debugPrint(titles.join(","));
          }),
    );
  }
}

class ActorFilterEntry {
  const ActorFilterEntry(this.name, this.initials);
  final String name;
  final String initials;
}

class ChipFilterDemo extends StatefulWidget {
  const ChipFilterDemo({Key? key}) : super(key: key);

  @override
  State createState() => ChipFilterDemoState();
}

class ChipFilterDemoState extends State<ChipFilterDemo> {
  final List<ActorFilterEntry> _entrys = [
    const ActorFilterEntry('Aaron Burr', 'AB'),
    const ActorFilterEntry('Alexander Hamilton', 'AH'),
    const ActorFilterEntry('Eliza Hamilton', 'EH'),
    const ActorFilterEntry('James Madison', 'JM'),
  ];

  final _filters = <ActorFilterEntry>[];

  Iterable<Widget> get actorWidgets sync* {
    for (final actor in _entrys) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          avatar: CircleAvatar(child: Text(actor.initials)),
          label: Text(actor.name),
          selected: _filters.map((e) => e.name).contains(actor.name),
          onSelected: (bool value) {
            if (value) {
              _filters.add(actor);
            } else {
              _filters.removeWhere((e) => e.name == actor.name);
            }
            debugPrint("_filters: ${_filters.map((e) => e.name)}");
            setState(() {});
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FilterChip'),
      ),
      body: ColoredBox(
        color: Colors.lightGreen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Wrap(
              children: actorWidgets.toList(),
            ),
            Text('Look for: ${_filters.join(', ')}'),
          ],
        ),
      ),
    );
  }
}
