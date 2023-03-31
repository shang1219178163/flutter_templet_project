//
//  TimelineDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/13/21 10:56 AM.
//  Copyright © 12/13/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/timeline/timeline.dart';

import 'package:flutter_templet_project/vendor/timeline/common/colors.dart';

class TimelineDemo extends StatefulWidget {

  final String? title;

  const TimelineDemo({ Key? key, this.title}) : super(key: key);


  @override
  _TimelineDemoState createState() => _TimelineDemoState();
}

class _TimelineDemoState extends State<TimelineDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: TimelineComponent(
          timelineList: listData,
          lineColor: WBColors.color_cccccc,
          leftContent: true,
        ),
    );
  }

  List listData =  [
    {
      'day': '07-08',
      'time': '13:20',
      'remark': "备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑",
      'description': '',
      'subtitle': '何神(主播)',
      'title': "新建工单"
    },
    {
      'id': "2",
      'day': '07-08',
      'time': '13:20',
      'description': "备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑",
      'subtitle': '吴飞飞(销售专员)',
      'title': "联系客户"
    },
    {
      'id': "3",
      'day': '07-08',
      'time': '13:20',
      'description': "备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合",
      // 'subtitle': '何神(主播)',
      'title': "新建工单"
    },
    {
      'id': "4",
      'day': '07-08',
      'time': '13:20',
      'description': "备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑，辛苦再撮合",
      'subtitle': '何神(主播)',
      'title': "新建工单"
    },
    {
      'id': "5",
      'day': '07-08',
      'time': '13:20',
      'description': "备注：降价1000客户可考虑",
      'subtitle': '何神(主播)',
      'title': "新建工单"
    }
  ];
}




