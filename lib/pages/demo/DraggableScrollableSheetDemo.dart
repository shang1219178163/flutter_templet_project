//
//  DraggableScrollableSheetDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/7/21 11:10 AM.
//  Copyright © 6/7/21 shang. All rights reserved.
//

// mac不支持

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/network/dio_upload_service.dart';
import 'package:flutter_templet_project/util/R.dart';

class DraggableScrollableSheetDemo extends StatefulWidget {
  final String? title;

  const DraggableScrollableSheetDemo({Key? key, this.title}) : super(key: key);

  @override
  _DraggableScrollableSheetDemoState createState() =>
      _DraggableScrollableSheetDemoState();
}

class _DraggableScrollableSheetDemoState
    extends State<DraggableScrollableSheetDemo> {
  final _scrollController = ScrollController();

  final draggableController = DraggableScrollableController();

  double minExtent = 0.15;

  late double extent = 0.15;

  final extentVN = ValueNotifier(0.15);

  @override
  void initState() {
    // TODO: implement initState

    // _scrollController.addListener(() {
    //   final isBottom =_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent;
    //   final isTop =_scrollController.position.pixels <= 0;
    //   ddlog("isTop: $isTop, isBottom: $isBottom");
    //
    //   if (isBottom) {
    //     // 滑动到底部，执行加载更多操作
    //   } else {
    //
    //   }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
            valueListenable: extentVN,
            builder: (context, value, child) {
              var desc = widget.title ?? "$widget";
              if (value == minExtent) {
                desc = "底部";
              } else {
                desc = "中间";
                return Opacity(
                  opacity: value / 1.0,
                  child: buildTopBar(),
                );
              }
              return Text(
                desc,
                style: TextStyle(fontSize: 15),
              );
            }),
        actions: [
          ElevatedButton(
            onPressed: () {
              draggableController.reset();
            },
            child: const Text('reset'),
          ),
        ],
      ),
      // body: buildBody(),
      body: buildBody1(),
    );
  }

  Widget buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            FlutterLogo(
              size: 40,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "我是标题",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "评分9.0",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
        Row(
          children: <({IconData iconData, VoidCallback click})>[
            (iconData: Icons.star_border, click: onCollect),
            (iconData: Icons.share, click: onShare),
            (iconData: Icons.more_horiz, click: onMore),
          ].map((e) {
            return InkWell(
              onTap: e.click,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Icon(e.iconData),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void onCollect() {
    ddlog("onCollect");
  }

  void onShare() {
    ddlog("onShare");
  }

  void onMore() {
    ddlog("onMore");
  }

  Widget buildBody({double minChildSize = 0.3}) {
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.top -
        MediaQuery.of(context).viewPadding.bottom -
        kToolbarHeight;

    minChildSize = minExtent;

    return SizedBox.expand(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            bottom: height * minChildSize,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                  image: ExtendedNetworkImageProvider(
                    R.image.urls[6],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                ),
                child: Column(
                  children: [
                    ...[
                      MediaQuery.of(context).viewPadding,
                      kToolbarHeight,
                    ].map((e) => Text(e.toString())).toList(),
                  ],
                ),
              ),
            ),
          ),
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (DraggableScrollableNotification e) {
              // doing this in setState breaks DraggableScrollableSheet behaviour
              ddlog("e: $e");
              extentVN.value = e.extent;
              return false;
            },
            child: DraggableScrollableSheet(
              controller: draggableController,
              initialChildSize: minChildSize,
              minChildSize: minChildSize,
              maxChildSize: 1,
              snap:
                  true, //true：触发滚动则滚动到maxChildSize或者minChildSize，不在跟随手势滚动距离 false:滚动跟随手势滚动距离
              builder: (context, scrollController) {
                return Container(
                  color: Colors.green,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 20,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text('Item $index'),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildBody1() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        image: DecorationImage(
          image: ExtendedNetworkImageProvider(
            R.image.urls[6],
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SizedBox.expand(
        child: DraggableScrollableSheet(
          controller: draggableController,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              color: Colors.white,
              child: ListView.builder(
                controller: scrollController,
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 75,
                    child: Column(
                      children: [
                        ListTile(
                          leading: FlutterLogo(
                            size: 48,
                          ),
                          title: Text('Item $index'),
                        ),
                        Divider(
                          indent: 75,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
