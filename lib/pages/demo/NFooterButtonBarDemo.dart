
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
import 'package:flutter_templet_project/util/debug_log.dart';

class NFooterButtonBarDemo extends StatefulWidget {

  NFooterButtonBarDemo({
    super.key,
    this.title
  });

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
      DDLog("_scrollController.offset: ${_scrollController.offset}/${_scrollController.position.maxScrollExtent}");
      enableVN.value = (_scrollController.offset >= _scrollController.position.maxScrollExtent);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

  Widget buildBody() {
    enableVN.value = true;

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
        buildPageFooter(
          onConfirm: (){
            DDLog("NFooterButtonBar");
          }
        ),
        buildPageFooter1(
          onConfirm: (){
            DDLog("NFooterButtonBar");
          }
        ),
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
            border: Border(
              top: BorderSide(color: Color(0xffE5E5E5))
            )
          ),
          confirmTitle: "保存",
          enable: value,
          // hideCancel: true,
          // isReverse: true,
          onConfirm: onConfirm,
        );
      }
    );
  }

  buildPageFooter1({required VoidCallback onConfirm}) {
    return ValueListenableBuilder(
        valueListenable: enableVN,
        builder: (context, value, child) {

          return NFooterButtonBar(
            primary: Colors.red,
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Color(0xffE5E5E5))
                )
            ),
            confirmTitle: "保存",
            enable: value,
            // hideCancel: true,
            // isReverse: true,
            onConfirm: onConfirm,
            gap: 0,
            btnBorderRadius: BorderRadius.zero,
            padding: EdgeInsets.zero,
          );
        }
    );
  }
}

