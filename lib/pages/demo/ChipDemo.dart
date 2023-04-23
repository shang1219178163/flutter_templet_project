//
//  ChipDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/7/21 6:13 PM.
//  Copyright © 12/7/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ChipDemo extends StatefulWidget {
  final String? title;

  const ChipDemo({Key? key, this.title}) : super(key: key);

  @override
  _ChipDemoState createState() => _ChipDemoState();
}

class _ChipDemoState extends State<ChipDemo> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: buildWrap(),
    );
  }

  int? _value = 1;

  Wrap buildWrap() {
    var titles = List<int>.generate(4, (index) => index);
    return Wrap(
      spacing: 8.0, // 主轴(水平)方向间距
      runSpacing: -8.0, // 纵轴（垂直）方向间距
      alignment: WrapAlignment.start, //沿主轴方向居中
      children: [
        Chip(
          label: Text("Chip",),
        ),
        Chip(
          label: Text("Chip",),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            )
        ),
        Divider(),
        Chip(
          label: Text("带 deleteIcon的 Chip",),
          deleteIcon: Icon( Icons.close, ),
          onDeleted: () {setState(() {ddlog("onDeleted: 带 deleteIcon的 Chip");}); },
          deleteButtonTooltipMessage: "弹出提示",
        ),
        Divider(),
        Chip(
          label: Text("带 avatar 和 deleteIcon的 Chip",),
          avatar: Image.asset("images/avatar.png", fit: BoxFit.fill),
          deleteIcon: Icon( Icons.close, ),
          onDeleted: () {setState(() {ddlog("onDeleted:带 avatar 和 deleteIcon的 Chip");}); },
        ),
        Divider(),

        Chip(
          avatar: InkWell(
            onTap: () { ddlog("onTap:Chip"); },
            child: Icon(Icons.add_circle,),
          ),
          // avatar: IconButton(
          //   onPressed: () { setState(() { ddlog("add"); } ); },
          //   padding: EdgeInsets.all(0),
          //   icon: Icon(Icons.add_circle)) ,
          label: Text("Chip"),
          // deleteIcon: Icon(Icons.remove_circle),
          deleteIcon: Icon(Icons.remove_circle),
          onDeleted: () { setState(() { ddlog("onDeleted:Chip"); } ); },
        ),
        Divider(),
        RawChip(
          label: Text("RawChip",),
          avatar: Image.asset("images/avatar.png", fit: BoxFit.fill),
          padding: EdgeInsets.all(0),
          onPressed: (){
            ddlog("onPressed: RawChip");
          },
          deleteIcon: Icon( Icons.close, ),
          onDeleted: (){
            ddlog("onDeleted: RawChip");
          },
        ),
        Divider(),
        RawChip(
          label: Text("RawChip",),
          avatar: Icon( Icons.close, ),
          padding: EdgeInsets.all(0),
          onPressed: (){
            ddlog("onPressed: RawChip");
          },
        ),
        Divider(),


        Wrap(
          spacing: 8.0, // 主轴(水平)方向间距
          runSpacing: -8.0, // 纵轴（垂直）方向间距
          alignment: WrapAlignment.start, //沿主轴方向居中
          children: titles.map((e) => ActionChip(
            avatar: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(e.toString().characters.first.toUpperCase())
            ),
            label: Text("Action_$e"),
            onPressed: (){
              _onPressed(titles.indexOf(e));
            },
          )).toList(),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: titles.map((e) => ChoiceChip(
            label: Text('Choice_$e'),
            padding: EdgeInsets.only(left: 15, right: 15),
            selected: _value == e,
            onSelected: (bool selected) {
              ddlog(e);
              setState(() {
                _value = selected ? e : null;
              });
            },
          ),).toList(),
        ),
        Divider(),
        Column(
          children: titles.map((e) => ChoiceChip(
            label: Text('Choice_$e'),
            padding: EdgeInsets.only(left: 15, right: 15),
            selected: _value == e,
            onSelected: (bool selected) {
              ddlog(e);
              setState(() {
                _value = selected ? e : null;
              });
            },
          ),).toList(),
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
        Divider(),
        InputChip(
          avatar: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            child: const Text('IC'),
          ),
          label: const Text('InputChip'),
          onPressed: () {
            debugPrint('onPressed: InputChip');
          }
        ),
        FilterChip(
          label: Text('FilterChip'),
          onSelected: (val){
            debugPrint('onSelected: $val');
          }
        ),
      ],
    );
  }

  void _onPressed(int e) {
    ddlog(e);
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