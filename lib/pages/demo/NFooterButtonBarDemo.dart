//
//  NFooterButtonBarDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/16 14:05.
//  Copyright © 2024/1/16 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

class NFooterButtonBarDemo extends StatefulWidget {
  NFooterButtonBarDemo({super.key, this.title});

  final String? title;

  @override
  State<NFooterButtonBarDemo> createState() => _NFooterButtonBarDemoState();
}

class _NFooterButtonBarDemoState extends State<NFooterButtonBarDemo> {
  final _scrollController = ScrollController();
  late final enableVN = ValueNotifier(true);

  final items = List.generate(20, (index) => index);

  @override
  void initState() {
    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      ddlog(
          "_scrollController.offset: ${_scrollController.offset}/${_scrollController.position.maxScrollExtent}");
      enableVN.value = (_scrollController.offset >=
          _scrollController.position.maxScrollExtent);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    enableVN.value = false;

    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: items.map((e) {
                  return Column(
                    children: [
                      ListTile(
                        // contentPadding: EdgeInsets.zero,
                        // dense: true,
                        title: NText("row_$e"),
                      ),
                      Divider(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        buildPageFooter(onConfirm: () {
          ddlog("NFooterButtonBar");
        }),
        buildPageFooter1(onConfirm: () {
          ddlog("NFooterButtonBar");
        }),
      ],
    );
  }

  buildPageFooter({required VoidCallback onConfirm}) {
    return ValueListenableBuilder(
      valueListenable: enableVN,
      builder: (context, value, child) {
        return NFooterButtonBar(
          primary: Colors.red,
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xffE5E5E5)))),
          confirmTitle: "保存",
          enable: value,
          // hideCancel: true,
          isReverse: true,
          onConfirm: onConfirm,
          leading: GestureDetector(
            onTap: () {
              ddlog("left");
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.keyboard_double_arrow_left,
                color: Colors.blue,
              ),
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              ddlog("right");
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.keyboard_double_arrow_right,
                color: Colors.blue,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildPageFooter1({required VoidCallback onConfirm}) {
    return ValueListenableBuilder(
        valueListenable: enableVN,
        builder: (context, value, child) {
          return NFooterButtonBar(
            primary: Colors.red,
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xffE5E5E5)))),
            confirmTitle: "保存",
            enable: value,
            // hideCancel: true,
            // isReverse: true,
            onConfirm: onConfirm,
            gap: 0,
            btnBorderRadius: BorderRadius.zero,
            padding: EdgeInsets.zero,
          );
        });
  }
}
