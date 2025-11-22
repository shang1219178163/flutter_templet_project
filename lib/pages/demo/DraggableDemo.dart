//
//  DraggableDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/2/21 5:37 PM.
//  Copyright © 6/2/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_drag_sort_wrap.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class DraggableDemo extends StatefulWidget {
  final String? title;

  const DraggableDemo({Key? key, this.title}) : super(key: key);

  @override
  _DraggableDemoState createState() => _DraggableDemoState();
}

class _DraggableDemoState extends State<DraggableDemo> {
  final scrollController = ScrollController();

  int acceptedData = 0;

  List<String> tags = List.generate(20, (i) => "标签$i");
  late List<String> others = List.generate(10, (i) => "其他${i + tags.length}");

  bool canEdit = true;

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
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildDraggable(),
            Divider(height: 16),
            buildDragSortWrap(),
          ],
        ),
      ),
    );
  }

  Widget buildDraggable() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Draggable<int>(
          data: 10,
          feedback: Container(
            color: Colors.deepOrange,
            height: 100,
            width: 100,
            child: const Icon(Icons.directions_run),
          ),
          childWhenDragging: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.pinkAccent,
            child: const Center(
              child: Text('Child When Dragging'),
            ),
          ),
          child: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.lightGreenAccent,
            child: const Center(
              child: Text('Draggable'),
            ),
          ),
        ),
        DragTarget<int>(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Container(
              height: 100.0,
              width: 100.0,
              color: Colors.cyan,
              child: Center(
                child: Text(
                  'Value is updated to: $acceptedData',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          // onAccept: (int data) {
          //   setState(() {
          //     acceptedData += data;
          //   });
          // },
          onAcceptWithDetails: handleOnAccept,
        ),
      ],
    );
  }

  void handleOnAccept(DragTargetDetails details) {
    final int data = details.data;
    acceptedData += data;
    setState(() {});
  }

  Widget buildDragSortWrap() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTagBar(
              onEdit: () {
                canEdit = !canEdit;
                setState(() {});
              },
            ),
            NDragSortWrap<String>(
              spacing: 12,
              runSpacing: 8,
              items: tags,
              itemBuilder: (context, item, isDragging) {
                return buildItem(
                  isDragging: isDragging,
                  item: item,
                  isTopRightVisible: canEdit,
                  topRight: GestureDetector(
                    onTap: () {
                      DLog.d(item);
                      tags.remove(item);
                      setState(() {});
                    },
                    child: Icon(Icons.remove, size: 14, color: Colors.white),
                  ),
                );
              },
              onChanged: (newList) {
                tags = newList;
                setState(() {});
              },
            ),
            Divider(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                ...others.map(
                  (item) {
                    return buildItem(
                      isDragging: false,
                      item: item,
                      isTopRightVisible: canEdit,
                      topRight: GestureDetector(
                        onTap: () {
                          DLog.d(item);
                          others.remove(item);
                          tags.add(item);
                          setState(() {});
                        },
                        child: Icon(Icons.add, size: 14, color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget buildItem({
    required bool isDragging,
    required String item,
    bool isTopRightVisible = true,
    required Widget topRight,
  }) {
    return Badge(
      backgroundColor: Colors.red,
      textColor: Colors.white,
      offset: Offset(4, -4),
      isLabelVisible: isTopRightVisible,
      label: topRight,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDragging ? Colors.green.withOpacity(0.6) : Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          item,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildTagBar({required VoidCallback onEdit}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '我的频道',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF303034),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  ' (点击编辑可排序)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF7C7C85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Text(
              '编辑',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF303034),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
