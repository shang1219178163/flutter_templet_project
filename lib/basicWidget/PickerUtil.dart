//
//  PickerUtil.dart
//  flutter_templet_project
//
//  Created by shang on 2023/12/20 16:15.
//  Copyright © 2023/12/20 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_picker_tool_bar.dart';

/// Picker 工具类
class PickerUtil {
  /// 单选
  static void show({
    required BuildContext context,
    required List<String> data,
    required String selectedData,
    ValueChanged<int>? onChanged,
    required ValueChanged<String> onSelected,
    VoidCallback? onCancel,
    required ValueChanged<String> onConfirm,
  }) {
    final selectedIndex = data.indexOf(selectedData);

    final content = Container(
      width: double.maxFinite,
      height: 300,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            NPickerToolBar(
              onCancel: onCancel ??
                  () {
                    Navigator.of(context).pop();
                  },
              onConfirm: () {
                onConfirm(selectedData);
              },
            ),
            Divider(
              height: 0.5,
            ),
            Expanded(
              child: buildPickerView(
                items: data,
                selectedIndex: selectedIndex,
                onChanged: onChanged,
                onSelected: (val) {
                  selectedData = val;
                  onSelected(selectedData);
                },
              ),
            ),
          ],
        ),
      ),
    );

    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return content;
      },
    );
  }

  /// 多选
  static void showMultiple({
    required BuildContext context,
    required List<List<String>> data,
    required List<String> selectedData,
    ValueChanged<List<int>>? onChanged,
    required ValueChanged<List<String>> onSelected,
    VoidCallback? onCancel,
    required ValueChanged<List<String>> onConfirm,
  }) {
    assert(data.isNotEmpty && data.length == selectedData.length);

    final indexs = <int>[];
    for (var i = 0; i < selectedData.length; i++) {
      final e = selectedData[i];
      final selectedIndex = data[i].indexOf(e);
      indexs.add(selectedIndex);
    }

    final content = Container(
      // width: double.maxFinite,
      height: 300,
      color: Colors.white,
      child: Column(
        children: [
          NPickerToolBar(
            onCancel: onCancel ??
                () {
                  Navigator.of(context).pop();
                },
            onConfirm: () {
              onConfirm(selectedData);
            },
          ),
          Divider(
            height: 0.5,
          ),
          Expanded(
            child: Row(
              children: List.generate(data.length, (i) {
                final items = data[i];

                // final selectedIndex = items.indexOf(selectedData[i]);
                // debugPrint("___selectedData: $selectedData");
                // debugPrint("___selectedIndex: $selectedIndex");
                final selectedIndex = indexs[i];

                return Expanded(
                  child: buildPickerView(
                    items: items,
                    selectedIndex: selectedIndex,
                    onChanged: (val) {
                      indexs[i] = val;
                      // debugPrint("indexs: $indexs, val: $val");

                      onChanged?.call(indexs);
                    },
                    onSelected: (val) {
                      selectedData[i] = val;

                      // debugPrint("selectedData: $selectedData");
                      onSelected(selectedData);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );

    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return content;
      },
    );
  }

  /// 多栏选择
  static Widget buildPickerView({
    required List<String> items,
    ValueChanged<int>? onChanged,
    required ValueChanged<String> onSelected,
    int selectedIndex = 1,
  }) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return CupertinoPicker.builder(
        backgroundColor: Colors.white,
        itemExtent: 50,
        scrollController: FixedExtentScrollController(
          initialItem: selectedIndex,
        ),
        // selectionOverlay: Container(color: Colors.red.withOpacity(0.3), height: 30),
        onSelectedItemChanged: (value) {
          onChanged?.call(value);
          onSelected(items[value]);
          // setState(() {});
        },
        childCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          var text = items[index];

          return Align(
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16),
            ),
          );
        },
      );
    });
  }
}
