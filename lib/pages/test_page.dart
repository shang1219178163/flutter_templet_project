//
//  TestPage.dart
//  flutter_templet_project
//
//  Created by shang on 12/2/21 2:16 PM.
//  Copyright © 12/2/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/Language/Property.dart';
import 'package:flutter_templet_project/basicWidget/RadiusWidget.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/string_extension.dart';
import 'package:flutter_templet_project/extension/map_extension.dart';

import 'package:flutter_templet_project/extension/buildContext_extension.dart';
import 'package:flutter_templet_project/uti/Singleton.dart';
import 'package:tuple/tuple.dart';

import '../R.dart';


class TestPage extends StatefulWidget {
  TestPage({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with SingleTickerProviderStateMixin {
  List<String> items = List.generate(6, (index) => 'item_$index').toList();
  late TabController _tabController;

  var titles = ["splitMapJoin", "1", "2", "3", "4", "5", "6", "7"];
  int time = 60;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: items.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(R.imgUrls[5]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(widget.title ?? "$widget"),
          actions: ['done',].map((e) => TextButton(
            child: Text(e,
                style: TextStyle(color: Colors.white),
              ),
            onPressed: onDone,)
          ).toList(),
          // bottom: buildAppBarBottom(),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: List.generate(6, (index) => Tab(text: 'item_$index')).toList(),
            // indicatorSize: TabBarIndicatorSize.label,
            // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildWrap(),
              buildSection1(),
              StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                return buildSection2();
              }),
              RepaintBoundary(child: buildSection3(),),
              Container(
                margin: const EdgeInsets.all(8),
                child: RadiusWidget(
                  radius: 8,
                  child: Container(
                      width: 200,
                      height: 40,
                      child: Text('widget.title')
                  ),
                  color: Colors.green,
                ),
              ),
              TextField(
                cursorColor: Colors.purple,
                cursorRadius: Radius.circular(8.0),
                cursorWidth: 8.0,
              ),
              buildBtnColor(),
              buildSection4(),

              // Image.asset(
              //   'images/img_update.png',
              //   repeat: ImageRepeat.repeat,
              // ),
            ],
          ),
        )
    );
  }

  buildAppBarBottom() {
    final items = List.generate(6, (index) => Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text('item_$index'),
    )).toList();
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: Container(
        child: Row(
          children: items,
        ),
      ),
    );

    return PreferredSize(
      preferredSize: Size(screenSize.width, 60),
      child: Row(
        children: List.generate(16, (i) => Container(
          child: Text('item_$i'),
        )).toList(),
      ),
    );
  }

  onDone() {
    final a = true;
    final b = "nested ${a ? "strings" : "can"} be wrapped by a double quote";

    final shard = Singleton();
    final shard1 = Singleton.instance;
    final shard2 = Singleton.getInstance();

    print(shard.toString());
    print(shard1.toString());
    print(shard2.toString());
    print(shard == shard1);
    print(shard1 == shard2);
    print(shard == shard2);

  }

  Wrap buildWrap() {
    return Wrap(
      spacing: 8.0, // 主轴(水平)方向间距
      runSpacing: 8.0, // 纵轴（垂直）方向间距
      alignment: WrapAlignment.start, //沿主轴方向居中
      children: titles.map((e) => ActionChip(
        avatar: CircleAvatar(backgroundColor: Theme.of(context).primaryColor,
            child: Text("${e.characters.first.toUpperCase()}")
        ),
        label: Text(e),
        onPressed: (){
          _onPressed(titles.indexOf(e));
        },
      )).toList(),
    );
  }

  buildSection1() {
    return Column(
      children: [
        Row(
          children: [
            Text('倒计时'),
            Text('$time')
          ],
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.send),
          label: Text("ElevatedButton"),
          onPressed: () {
            setState(() {
              time++;
            });
          },
        ),
      ],
    );
  }

  buildSection2() {
    return Column(
        children: [
          Row(
            children: [
              Text('倒计时'),
              Text('$time')
            ],
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.send),
            label: Text("ElevatedButton"),
            onPressed: () {
              setState(() {
                time++;
              });
            },
          ),
        ],
      );
  }

  buildSection3() {
    return Column(
      children: [
        Row(
          children: [
            Text('倒计时'),
            Text('$time')
          ],
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.send),
          label: Text("ElevatedButton"),
          onPressed: () {
            setState(() {
              time++;
            });
          },
        ),
      ],
    );
  }

  buildSection4() {
    final tuples = [
      Tuple2('Color(0xFF4286f4)', Color(0xFF4286f4)),
      Tuple2('Color(0xFF4286f4).withOpacity(0.5)', Color(0xFF4286f4).withOpacity(0.5)),
      Tuple2('Colors.black.withOpacity(0.4)', Colors.black.withOpacity(0.4)),
    ];
    return Column(
      children: tuples.map((e) => Row(
          children: [
            Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(left: 16, right: 8),
              color: e.item2,
            ),
            Text('${e.item1}'),
          ]
      )).toList(),
    );
  }


  buildBtnColor() {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed))
            return Colors.green;
          return Colors.black87; // Defer to the widget's default.
        }),
      ),
      child: Text('Change My Color', style: TextStyle(fontSize: 30),
      ),
    );
  }

  void _onPressed(int e) {
    final a = 'Eats shoots leaves'.splitMapJoin((RegExp(r'shoots')),
         onMatch:    (m) => '${m[0]}',  // (or no onMatch at all)
         onNonMatch: (n) => '*'); // Result: "*shoots*"
    ddlog(a);

    final b = 'Eats shoots leaves'.splitMapJoin((RegExp(r's|o')),
        onMatch: (m) => "_",
    );
    ddlog(b);

    final c = 'Eats shoots leaves'.split(RegExp(r's|o'));
    ddlog(c);

    final d = "easy_refresh_plugin".camlCase("_");
    ddlog(d);

    final d1 = "easyRefreshPlugin".uncamlCase("_");
    ddlog(d1);

    final d2 = "easyRefreshPlugin".toCapitalize();
    ddlog(d2);

    ddlog(screenSize);

    showSnackBar(SnackBar(content: Text(d2)));

    Map<String, dynamic> map = {
      'msgType': '5',
      'msgTag': '官方号',
      'msgUnreadNum': 3,
    };

    ddlog('getUrlParams():${getUrlParams(map: map)}');
    ddlog('map.join():${map.join()}' );

    double? z;
    double? z1 = null;
    final list = [z, z1];
    print('z1:${list}');

    List<String>? items = null;
    final zz = items?[0];
    print('zz:${zz}');
  }

  getUrlParams({Map<String, dynamic> map = const {}}) {
    if (map.keys.length == 0) {
      return '';
    }
    String paramStr = '';
    map.forEach((key, value) {
      paramStr += '${key}=${value}&';
    });
    String result = paramStr.substring(0, paramStr.length - 1);
    return result;
  }

}

// typedef RadiusBuilder = Widget Function(BuildContext context, StateSetter setState);

