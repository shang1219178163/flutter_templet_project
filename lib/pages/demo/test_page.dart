//
//  TestPage.dart
//  flutter_templet_project
//
//  Created by shang on 12/2/21 2:16 PM.
//  Copyright © 12/2/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with SingleTickerProviderStateMixin {
  List<String> items = List.generate(6, (index) => 'item_$index').toList();
  late TabController _tabController;

  var titles = ["splitMapJoin", "1", "2", "3", "4", "5", "6", "7"];
  int time = 60;

  final textStyle = TextStyle(overflow: TextOverflow.ellipsis);

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: items.length, vsync: this)
      ..addListener(() {
        if (!_tabController.indexIsChanging) {
          debugPrint("_tabController:${_tabController.index}");
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(AppRes.image.urls[5]),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
          // bottom: buildAppBarBottom(),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            // labelColor: context.primaryColor,
            // unselectedLabelColor: Theme.of(context).colorScheme.primary,
            tabs: List.generate(6, (index) {
              return Tab(
                text: 'item_$index',
              );
            }).toList(),
            // indicatorSize: TabBarIndicatorSize.label,
            // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildWrap(),
              buildSection1(),
              StatefulBuilder(builder: (context, setState) {
                return buildSection2();
              }),
              RepaintBoundary(
                child: buildSection3(),
              ),
              buildSection4(),
              buildSection5(),
              SizedBox(height: 34),
            ],
          ),
        ));
  }

  buildAppBarBottom() {
    final items = List.generate(
        6,
        (index) => Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('item_$index'),
            )).toList();
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: Row(
        children: items,
      ),
    );
  }

  onDone() {
    const a = true;
    final b = "nested ${a ? "strings" : "can"} be wrapped by a double quote";

    final val = "1# 8ji#2_3I  ".toInt();
    DLog.d("val: $val");

    final duration = Duration(milliseconds: 146 * 1000);
    DLog.d("duration: $duration");

    DLog.d("toTimeNew: ${duration.toTimeNew()}");
    DLog.d("toTime: ${duration.toTime()}");

    DLog.d("list: ${[
      duration.inHours.remainder(24),
      duration.inMinutes.remainder(60),
      duration.inSeconds.remainder(60),
    ]}");
  }

  Wrap buildWrap() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.start,
      children: titles
          .map((e) => ActionChip(
                avatar: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor, child: Text(e.characters.first.toUpperCase())),
                label: Text(e),
                onPressed: () {
                  _onPressed(titles.indexOf(e));
                },
              ))
          .toList(),
    );
  }

  buildSection1() {
    return Column(
      children: [
        Row(
          children: [Text('倒计时'), Text('$time')],
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.send),
          label: Text("ElevatedButton"),
          onPressed: () {
            time++;
            setState(() {});
          },
        ),
      ],
    );
  }

  buildSection2() {
    return Column(
      children: [
        Row(
          children: [Text('倒计时'), Text('$time')],
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
          children: [Text('倒计时'), Text('$time')],
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
      children: tuples
          .map((e) => Row(children: [
                Container(
                  width: 30,
                  height: 30,
                  margin: EdgeInsets.only(left: 16, right: 8),
                  color: e.item2,
                ),
                Text(e.item1),
              ]))
          .toList(),
    );
  }

  buildSection5() {
    return Listener(
      onPointerDown: (e) {
        debugPrint("onPointerDown:$e");
      },
      child: Container(
        height: 400,
        child: ListView.builder(
            itemCount: 3,
            itemBuilder: (ctx, index) {
              return Container(
                height: 60,
                child: ColoredBox(color: ColorExt.random, child: Text('Row_$index')),
              );
            }),
      ),
    );
  }

  Future<void> _onPressed(int e) async {
    final file = await FileExt.fromAssets("assets/images/icon_skipping.gif");
    DLog.d("file: ${file.fileSizeDesc}");
  }

  test() {}

  Future<XFile> multipartFileToXFile(http.MultipartFile file) async {
    final bytes = await file.finalize().toBytes();
    final xFile = XFile.fromData(bytes, name: file.filename ?? "unknown_file");
    return xFile;
  }
}

extension RecordExt on Record {}
