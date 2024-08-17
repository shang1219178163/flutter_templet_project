//
//  LogisticsTimeLine.dart
//  timelines-main
//
//  Created by shang on 12/14/21 3:46 PM.
//  Copyright © 12/14/21 shang. All rights reserved.
//

// import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:timelines/timelines.dart';

class LogisticsTimeLine extends StatefulWidget {
  final String? title;

  const LogisticsTimeLine({Key? key, this.title}) : super(key: key);

  @override
  _LogisticsTimeLineState createState() => _LogisticsTimeLineState();
}

class _LogisticsTimeLineState extends State<LogisticsTimeLine> {
  int groupValue = 0;

  late final TimelineThemeData _theme = TimelineThemeData(
    nodePosition: 0.20,
  );

  late final TimelineThemeData _theme1 = TimelineThemeData(
    nodePosition: 0,
    connectorTheme: ConnectorThemeData(color: Colors.red),
    indicatorTheme: IndicatorThemeData(color: Colors.red, size: 10),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        bottom: buildPreferredSize(),
      ),
      body: _getBody(),
    );
  }

  PreferredSizeWidget buildPreferredSize() {
    final children = List.generate(
      3,
      (i) {
        return Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('样式$i', style: TextStyle(fontSize: 15)));
      },
    ).toList();

    final map = <int, Widget>{};
    for (var i = 0; i < children.length; i++) {
      map[i] = children[i];
    }

    return PreferredSize(
      preferredSize: const Size(double.infinity, 48),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // SizedBox(width: 24),
            Expanded(
              child: CupertinoSegmentedControl(
                children: map,
                groupValue: groupValue,
                onValueChanged: (int value) {
                  ddlog(value.toString());
                  setState(() {
                    groupValue = value;
                  });
                },
                borderColor: Colors.white,
                unselectedColor: Theme.of(context).primaryColor,
                selectedColor: Colors.white,
              ),
            ),
            // SizedBox(width: 24)
          ],
        ),
      ),
    );
  }

  _getBody() {
    final map = {
      0: _buildBody(),
      1: _buildBody1(),
      2: _buildBody2(),
    };
    return map[groupValue] ?? Container();
  }

  _buildBody() {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('商品名称: 某某至尊版',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ),
        Padding(
          padding: const EdgeInsets.all(.0),
          child: FixedTimeline.tileBuilder(
            theme: _theme,
            mainAxisSize: MainAxisSize.min,
            builder: TimelineTileBuilder.connected(
              contentsAlign: ContentsAlign.basic,
              indicatorBuilder: (context, index) {
                return index % 2 == 0
                    ? ContainerIndicator(
                        child: Container(
                          width: 30.0,
                          height: 30.0,
                          color: Colors.blue,
                        ),
                      )
                    : Container(
                        // width: 30.0,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: DotIndicator());
              },
              connectorBuilder: (context, index, type) {
                return index % 2 == 0
                    ? SizedBox(
                        child: SolidLineConnector(),
                      )
                    : SizedBox(
                        child: DashedLineConnector(),
                      );
              },
              oppositeContentsBuilder: (context, index) {
                var model = PlainDataModel.fromJson(listData[index]);
                return Container(
                  // color: Colors.yellow,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${model.day}\n${model.time}'),
                  ),
                );
              },
              contentsBuilder: (context, index) {
                var model = PlainDataModel.fromJson(listData[index]);
                return Card(
                  // color: Colors.yellow,
                  // elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('${model.title}'),
                        Text('${model.day} ${model.time}'),
                        Text(model.description),
                      ],
                    ),
                  ),
                );
              },
              itemCount: listData.length,
            ),
          ),
        ),
      ],
    );
  }

  _buildBody1() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('商品名称: 某某至尊版',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FixedTimeline.tileBuilder(
            theme: _theme1,
            mainAxisSize: MainAxisSize.min,
            builder: TimelineTileBuilder.connectedFromStyle(
              contentsAlign: ContentsAlign.basic,
              firstConnectorStyle: ConnectorStyle.transparent,
              lastConnectorStyle: ConnectorStyle.transparent,
              oppositeContentsBuilder: (context, index) {
                var model = PlainDataModel.fromJson(listData[index]);
                return Container(
                  // color: Colors.yellow,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${model.day}\n${model.time}'),
                  ),
                );
              },
              contentsBuilder: (context, index) {
                var model = PlainDataModel.fromJson(listData[index]);
                return Card(
                  // color: Colors.yellow,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('${model.title}'),
                        Text('${model.day} ${model.time}'),
                        Text(model.description),
                      ],
                    ),
                  ),
                );
              },
              connectorStyleBuilder: (context, index) =>
                  ConnectorStyle.solidLine,
              // connectorStyleBuilder: (context, index) => index == 0 ? ConnectorStyle.transparent : ConnectorStyle.solidLine,
              indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
              itemCount: listData.length,
            ),
          ),
        ),
      ],
    );
  }

  _buildBody2() {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('商品名称: 某某至尊版',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ),
        Padding(
          padding: const EdgeInsets.all(.0),
          child: FixedTimeline.tileBuilder(
            theme: _theme,
            mainAxisSize: MainAxisSize.min,
            builder: TimelineTileBuilder.connected(
              contentsAlign: ContentsAlign.basic,
              indicatorBuilder: (context, index) {
                return index % 2 == 0
                    ? ContainerIndicator(
                        child: Container(
                          width: 30.0,
                          height: 30.0,
                          color: Colors.blue,
                        ),
                      )
                    : Container(
                        // width: 30.0,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: DotIndicator());
              },
              connectorBuilder: (context, index, type) {
                return index % 2 == 0
                    ? SizedBox(
                        child: SolidLineConnector(),
                      )
                    : SizedBox(
                        child: DashedLineConnector(),
                      );
              },
              oppositeContentsBuilder: (context, index) {
                var model = PlainDataModel.fromJson(listData[index]);
                return Container(
                  // color: Colors.yellow,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${model.day}\n${model.time}'),
                  ),
                );
              },
              contentsBuilder: (context, index) {
                var model = PlainDataModel.fromJson(listData[index]);
                return Card(
                  // color: Colors.yellow,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('${model.title}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${model.day} ${model.time}'),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                // minimumSize: Size.zero,
                                // padding: EdgeInsets.all(8),
                                shape: StadiumBorder(
                                  side: BorderSide(color: Colors.red),
                                ),
                              ),
                              onPressed: () {
                                ddlog("onPressed");
                              },
                              child: Text('查看'),
                            ),
                          ],
                        ),
                        Text(model.description),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 60,
                              width: 100,
                              // color: Colors.green,
                              child: Image.asset("assets/images/img_404.png"),
                            ),
                            Container(
                              height: 60,
                              width: 100,
                              // color: Colors.green,
                              child: Image.asset("assets/images/img_404.png"),
                            ),
                            TextButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.all(5),
                              ),
                              onPressed: () {
                                ddlog("onPressed");
                              },
                              child: Text(
                                '更多',
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: listData.length,
            ),
          ),
        ),
      ],
    );
  }
}

class PlainDataModel {
  PlainDataModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.day,
      required this.time});

  late String id;
  late String title;
  late String description;
  late String day;
  late String time;

  // ignore: sort_constructors_first
  PlainDataModel.fromJson(Map<String, dynamic> json) {
    if (json is! Map) {
      return;
    }
    id = json['id'] ?? "-";
    title = json['title'] ?? "-";
    description = json['description'] ?? "-";
    day = json['day'] ?? "-";
    time = json['time'] ?? "-";
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['day'] = day;
    data['time'] = time;
    return data;
  }
}

List listData = [
  {
    'day': '12月9日',
    'time': '10: 53',
    'description': "订单产品已安装，感谢您使用日日顺物流，期待下次继续为您颐务！",
  },
  {
    'day': '12月8日',
    'time': '10: 53',
    'description': "【青岛即墨】日日顺小哥: 【常盼盼】 【13698658853】 正在为您派件，感澍您的耐心e待",
  },
  {
    'day': '12月7日',
    'time': '10: 53',
    'description': "派工完成，并已回传网点: 8600035248",
  },
  {
    'day': '12月6日',
    'time': '10: 53',
    'description': "您的订单已签收，期待下次继续为您胶务",
  },
  {
    'day': '12月5日',
    'time': '10: 53',
    'description': "订单已从【青岛即曼】转出，发往用户预计送达用户时间: 2021一02一19",
  },
  {
    'day': '12月4日',
    'time': '10: 53',
    'description': "订单己由【青怒即壹】配车调度安排发运预计送达用户时间: 2021一02一1912月3日10: 53\n订单已创建",
  }
];

// List listData =  [
//   {
//     'day': '07-08',
//     'time': '13:20',
//     'description': "备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑",
//     'subtitle': '何神(主播)',
//     'title': "新建工单"
//   },
//   {
//     'id': "2",
//     'day': '07-08',
//     'time': '13:20',
//     'description': "备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑",
//     'subtitle': '吴飞飞(销售专员)',
//     'title': "联系客户"
//   },
//   {
//     'id': "3",
//     'day': '07-08',
//     'time': '13:20',
//     'description': "备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合",
//     'subtitle': '何神(主播)',
//     'title': "新建工单"
//   },
//   {
//     'id': "4",
//     'day': '07-08',
//     'time': '13:20',
//     'description': "备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合",
//     'subtitle': '何神(主播)',
//     'title': "新建工单"
//   },
//   {
//     'id': "5",
//     'day': '07-08',
//     'time': '13:20',
//     'description': "备注：降价1000客户可考虑",
//     'subtitle': '何神(主播)',
//     'title': "新建工单"
//   }
// ];
