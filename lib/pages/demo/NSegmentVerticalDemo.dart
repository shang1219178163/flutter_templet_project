//
//  NSegmentVerticalDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/6/8 11:52.
//  Copyright © 2024/6/8 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/n_skeleton_screen.dart';

import 'package:flutter_templet_project/mixin/selectable_mixin.dart';
import 'package:flutter_templet_project/model/user_model.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class SegmentVerticalDemo extends StatefulWidget {
  const SegmentVerticalDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<SegmentVerticalDemo> createState() => _SegmentVerticalDemoState();
}

class _SegmentVerticalDemoState extends State<SegmentVerticalDemo> {
  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final isLoadding = ValueNotifier(true);

  final leftItems = ValueNotifier(<SelectableMixin>[]);

  SelectableMixin? selectedModel;

  @override
  void initState() {
    super.initState();

    leftItems.value = List.generate(
      6,
      (i) => UserModel(id: i.toString(), name: "人员$i"),
    );
    isLoadding.value = false;
  }

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
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: ValueListenableBuilder(
        valueListenable: leftItems,
        builder: (context, List<SelectableMixin> list, child) {
          if (isLoadding.value) {
            return const NSkeletonScreen();
          }
          if (list.isEmpty) {
            return const NPlaceholder();
          }
          selectedModel ??= list.first;
          return Row(
            children: [
              leftList(
                list: list,
                onChanged: (SelectableMixin e) {
                  DLog.d("onChanged $e");
                },
              ),
              // Expanded(child: _rightListWidget()),
            ],
          );
        },
      ),
    );
  }

  Widget leftList({
    required List<SelectableMixin> list,
    required ValueChanged<SelectableMixin> onChanged,
  }) {
    return Container(
      width: 98,
      color: AppColor.bgColor,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final model = list[index];

              return InkWell(
                onTap: () {
                  selectedModel = model;
                  setState(() {});
                  onChanged(model);
                },
                child: leftItem(
                  list: list,
                  index: index,
                  selectedIndex: list.indexOf(selectedModel!),
                ),
              );
            },
            itemCount: list.length,
          );
        }),
      ),
    );
  }

  Widget leftItem({
    required List<SelectableMixin> list,
    required int index,
    required int selectedIndex,
    Widget? child,
  }) {
    final model = list[index];
    var isSelected = model.selectableId == selectedModel?.selectableId;
    var bgColor = isSelected ? AppColor.white : AppColor.bgColorF9F9F9;
    // bgColor = isSelected ? white : Colors.green;

    var name = model.selectableName ?? "";

    return ColoredBox(
      color: AppColor.white,
      child: Container(
        width: double.infinity,
        height: 59,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular((selectedIndex - 1) >= 0 && index == selectedIndex - 1 ? 8 : 0),
            topRight: Radius.circular((selectedIndex < list.length - 1 && index == selectedIndex + 1) ? 8 : 0),
          ),
        ),
        child: child ??
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? context.primaryColor : AppColor.fontColor737373,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                Divider(
                  height: 0.5,
                  color: (!isSelected &&
                          !((selectedIndex - 1) >= 0 && index == selectedIndex - 1) &&
                          index != list.length - 1)
                      ? AppColor.lineColor
                      : Colors.transparent,
                ),
              ],
            ),
      ),
    );
  }
}
