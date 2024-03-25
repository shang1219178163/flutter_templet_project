//
//  SegmentedControlDemoOne.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/25 10:21.
//  Copyright © 2024/3/25 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_segment_control_emoj_view.dart';
import 'package:flutter_templet_project/basicWidget/n_segment_control_emoji.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:get/get.dart';

class SegmentedControlDemoOne extends StatefulWidget {

  SegmentedControlDemoOne({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<SegmentedControlDemoOne> createState() => _SegmentedControlDemoOneState();
}

class _SegmentedControlDemoOneState extends State<SegmentedControlDemoOne> {

  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  final items = [
    SegmentEmojiModel(
      iconPath: 'assets/images/icon_segment_emoji.png',
      name: '',
      activeColor: Color(0xff007DBF),
    ),
    SegmentEmojiModel(
      iconPath: 'assets/images/icon_segment_collect.png',
      name: '',
      activeColor: Color(0xffFF8F3E),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp ? null : AppBar(
        title: Text("$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),
        ),
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return buildSegmentControlEmojView();

    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15),
            //   child: buildSegmentControl(),
            // ),
            // NSegmentControlEmoji(
            //   items: items,
            //   onChanged: (int value) {  },
            // ),
            Container(
              height: double.maxFinite,
              child: NSegmentControlEmojView(
                items: items,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSegmentControl({
    double gap = 6,
    double? segmentWidth = 150,
    double segmentGap = 5,
    double segmentRadius = 4,
    EdgeInsets segmentPadding = const EdgeInsets.symmetric(vertical: 7),
  }) {
    var current = items[0];

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.map((e){

            final index = items.indexOf(e);
            final isSelected = current == e;
            final iconColor = isSelected ? e.activeColor : null;
            final textColor = isSelected ? e.activeColor : Colors.black54;

            return Expanded(
              child: InkWell(
                onTap: (){
                  current = e;
                  setState((){});
                },
                child: Container(
                  width: segmentWidth,
                  margin: EdgeInsets.only(left: index == 0 ? 0 : segmentGap),
                  padding: EdgeInsets.symmetric(vertical: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: iconColor?.withOpacity(0.08),
                    borderRadius: BorderRadius.all(Radius.circular(segmentRadius)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(e.iconPath.isNotEmpty)Image(
                        image: e.iconPath.toAssetImage(),
                        width: 25,
                        height: 25,
                        color: iconColor,
                      ),
                      if(e.iconPath.isNotEmpty || e.name.isNotEmpty)SizedBox(width: 6,),
                      if(e.name.isNotEmpty)Flexible(
                        child: Text(e.name,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }
    );
  }


  Widget buildSegmentControlEmojView() {
    return NSegmentControlEmojView(
      items: items,
    );
  }
}
