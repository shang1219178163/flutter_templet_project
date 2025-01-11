//
//  DateTableDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/4/21 8:09 AM.
//  Copyright © 6/4/21 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/extension/map_ext.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/object_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/mixin/selectable_mixin.dart';
import 'package:flutter_templet_project/model/user_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tuple/tuple.dart';

final titles = [
  (title: "姓名", key: "name"),
  (title: "年龄", key: "age"),
  (title: "性别", key: "sex"),
  (title: '出生年份', key: "birdthYear"),
  (title: '描述', key: "desc"),
];

List<UserModel> models = [
  ...List.generate(120, (i) {
    // final name = "name$i";
    final name = "${1.generateList(items: ["张三", "赵四", "王五", "李六"])}$i";
    final age = IntExt.random(max: 100);
    final sex = [0, 1].randomOne == 1 ? "男" : "女";
    final birdthYear = IntExt.random(min: 1990, max: 2024);
    final birthMonth = 1.generateList(
        items: "子（鼠）、丑（牛）、寅（虎）、卯（兔）、辰（龙）、巳"
                "（蛇）、午（马）、未（羊）、申（猴）、酉（鸡）、戌（狗）、亥（猪）"
            .split("、")
            .toList());

    return UserModel(
      name: name,
      sex: sex,
      age: age,
      birthYear: birdthYear,
      desc: birthMonth,
    );
  }),
];

class DataTableDemo extends StatefulWidget {
  final String? title;

  const DataTableDemo({Key? key, this.title}) : super(key: key);

  @override
  _DataTableDemoState createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo> {
  var _sortAscending = true;
  var _sortColumnIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.title ?? "$widget"),
        title: buildSegmentedControl(),
      ),
      body: buildExcel(),
    );
  }

  final children = <int, Widget>{
    0: Container(
      padding: EdgeInsets.all(8),
      child: Text("Item 1", style: TextStyle(fontSize: 15, color: Colors.black)),
    ),
    1: Container(
      padding: EdgeInsets.all(8),
      child: Text("Item 2", style: TextStyle(fontSize: 15, color: Colors.black)),
    ),
    2: Container(
      padding: EdgeInsets.all(8),
      child: Text("Item 3", style: TextStyle(fontSize: 15, color: Colors.black)),
    ),
  };

  int groupValue = 0;

  Widget buildSegmentedControl() {
    return CupertinoSegmentedControl<int>(
      children: children,
      borderColor: Colors.white,
      onValueChanged: (int newValue) {
        setState(() {
          groupValue = newValue;
        });
        ddlog(groupValue);
      },
      groupValue: groupValue,
    );
  }

  Widget buildExcel() {
    return Container(
      // color: Colors.green,
      padding: EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            showBottomBorder: true,
            showCheckboxColumn: true,
            columns: titles
                .map((e) => DataColumn(
                      label: Text(e.title),
                      onSort: (int columnIndex, bool ascending) {
                        _changeSort(columnIndex: columnIndex, ascending: ascending);
                      },
                    ))
                .toList(),
            rows: models
                .map((e) => DataRow(
                      cells: [
                        DataCell(Text(e.name ?? "")),
                        DataCell(Text('${e.age ?? ""}')),
                        DataCell(Text(e.sex ?? "")),
                        DataCell(Text('${e.birthYear ?? ""}')),
                        DataCell(Text('${e.desc ?? ""}')),
                      ],
                      selected: e.isSelected,
                      onSelectChanged: (bool? value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          e.isSelected = value;
                        });
                        ddlog(
                            models.where((e) => e.isSelected == true).map((e) => "${e.name}_${e.isSelected}").toList());
                      },
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  void _changeSort({required int columnIndex, required bool ascending}) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      switch (columnIndex) {
        case 1:
          models.sortedByValue(ascending: ascending, cb: (obj) => obj.age?.toString());
          break;

        case 2:
          models.sortedByValue(ascending: ascending, cb: (obj) => obj.sex?.toString());
          break;

        case 3:
          models.sortedByValue(ascending: ascending, cb: (obj) => obj.birthYear?.toString());
          break;

        case 4:
          models.sortedByValue(ascending: ascending, cb: (obj) => obj.desc?.toString());
          break;

        default:
          models.sortedByValue(ascending: ascending, cb: (obj) => obj.name?.toString());
          break;
      }
    });
  }
}

class PaginatedDataTableDemo extends StatelessWidget {
  PaginatedDataTableDemo({Key? key}) : super(key: key);

  final titles = [
    (title: "姓名", key: "name"),
    (title: "年龄", key: "sex"),
    (title: "性别", key: "age"),
    (title: '出生年份', key: "birdthYear"),
    (title: '描述', key: "desc"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PaginatedDataTable'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PaginatedDataTable(
            header: Text('人员花名册'),
            rowsPerPage: 10,
            columns: titles
                .map((e) => DataColumn(
                      label: Text(e.title),
                    ))
                .toList(),
            source: _DataSource(
              dataList: models,
              rowKeys: ["name", "age", "sex", "birthYear", "desc"],
              cellBuilder: (i, e, k) {
                final map = e.toJson();
                final val = map[k];
                if (val == null) {
                  return Text("-");
                }
                return Text("$val");
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DataSource<E extends SelectableMixin> extends DataTableSource {
  _DataSource({
    required this.rowKeys,
    required this.dataList,
    required this.cellBuilder,
  });

  final List<String> rowKeys;

  final List<E> dataList;

  final Widget Function(int i, E e, String key) cellBuilder;

  int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    if (index >= dataList.length) {
      return null;
    }

    final e = dataList[index];
    return DataRow.byIndex(
      index: index,
      selected: e.isSelected,
      onSelectChanged: (value) {
        if (value == null) {
          return;
        }
        if (e.isSelected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          e.isSelected = value;
          notifyListeners();
        }
      },
      cells: [
        ...List.generate(rowKeys.length, (i) {
          return DataCell(cellBuilder(i, e, rowKeys[i]));
        }),
      ],
    );
  }

  @override
  int get rowCount => dataList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

extension _ListExtObject<E extends Object> on List<E> {
  /// 排序
  List<E> sortedByValue({bool ascending = true, required String? Function(E e) cb}) {
    if (ascending) {
      // this.sort((a, b) => cb(a).compareTo(cb(b)));
      sort((a, b) => _customeCompare(cb(a), cb(b)));
    } else {
      // this.sort((a, b) => cb(b).compareTo(cb(a)));
      sort((a, b) => _customeCompare(cb(b), cb(a)));
    }
    return this;
  }

  /// 处理字符串中包含数字排序异常的问题
  int _customeCompare(String? a, String? b) {
    if (a == null || b == null) {
      return -1;
    }
    final result = (a ?? "").compareContainInt(b ?? "");
    return result;
  }
}
