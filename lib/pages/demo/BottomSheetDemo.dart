//
//  BottomSheetDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/8/21 1:31 PM.
//  Copyright © 12/8/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_alignment_drawer.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/button_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/navigator_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/get_util.dart';
import 'package:get/get.dart';

class BottomSheetDemo extends StatefulWidget {
  const BottomSheetDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<BottomSheetDemo> createState() => _BottomSheetDemoState();
}

class _BottomSheetDemoState extends State<BottomSheetDemo> {
  bool get hideApp =>
      Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  late var items = [
    ("默认样式", onShowModalBottomSheet),
    ("GetSheet - showBottom", onGetBottom),
    ("GetSheet - showInput", onGetBottomInput),
  ];

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Text(textController.text),
            Wrap(
              spacing: 8.0, // 主轴(水平)方向间距
              runSpacing: 8.0, // 纵轴（垂直）方向间距
              alignment: WrapAlignment.start, //沿主轴方向居中
              children: items
                  .map((e) => ActionChip(
                        avatar: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(e.$1.characters.first.toUpperCase())),
                        label: Text(e.$1),
                        onPressed: () {
                          e.$2();
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void onShowModalBottomSheet() {
    SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildList(context),
          Positioned(
            top: -30,
            right: 15,
            child: FloatingActionButton(
              foregroundColor: Colors.blue,
              backgroundColor: Colors.white,
              onPressed: () {
                ddlog("directions_bike");
              },
              child: Icon(Icons.directions_bike),
            ),
          ),
        ],
      ),
    ).toShowModalBottomSheet(context: context);
  }

  Widget _buildList(BuildContext context) {
    final theme = Theme.of(context);

    final titleMediumStyle = theme.textTheme.titleMedium
        ?.copyWith(color: theme.colorScheme.onPrimary);

    return Wrap(
      children: [
        Container(
          height: 80,
          color: theme.colorScheme.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Header',
                  style: titleMediumStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'this is subtitle',
                      style: titleMediumStyle,
                    ),
                    Text(
                      "trailing",
                      style: titleMediumStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        buildMid(cb: (i) {
          debugPrint("index: $i");
        }),
        Divider(),
        buildBottom(cb: (i) {
          debugPrint("index: $i");
        }),
      ],
    );
  }

  Widget buildMid({required ValueChanged<int?> cb}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        NPair<int>(
          child: Text("CALL"),
          icon: Icon(Icons.call),
          direction: Axis.vertical,
          data: 0,
        ),
        NPair<int>(
          child: Text("SHARE"),
          icon: Icon(Icons.open_in_new),
          direction: Axis.vertical,
          data: 1,
        ),
        NPair<int>(
          child: Text("SAVE"),
          icon: Icon(Icons.playlist_add),
          direction: Axis.vertical,
          data: 2,
        ),
      ].map((e) {
        return TextButton(
          onPressed: () {
            cb(e.data);
          },
          child: e,
        );
      }).toList(),
    );
  }

  Widget buildBottom({required ValueChanged<int?> cb}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        NPair<int>(
          child: Text("Share"),
          icon: Icon(
            Icons.share,
            color: Colors.blue,
          ),
          data: 0,
        ),
        NPair<int>(
          child: Text("Get link"),
          icon: Icon(
            Icons.link,
            color: Colors.blue,
          ),
          data: 1,
        ),
        NPair<int>(
          child: Text("Edit name"),
          icon: Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          data: 2,
        ),
        NPair<int>(
          child: Text('Delete collection'),
          icon: Icon(
            Icons.delete,
            color: Colors.blue,
          ),
          data: 3,
        ),
      ].map((e) {
        return ListTile(
            leading: e.icon,
            title: e.child,
            onTap: () {
              cb(e.data);
            });
      }).toList(),
    );
  }

  void onGetBottom() {
    GetBottomSheet.showActions(
      actions: [
        (onTap: () {}, child: NText('拍摄')),
        (onTap: () {}, child: NText('从相册选择')),
      ],
    );
  }

  void onGetBottomInput() {
    GetBottomSheet.showInput(
      controller: textController,
      onConfirm: () {
        Navigator.of(context).pop();
        setState(() {});
      },
    );
  }
}
