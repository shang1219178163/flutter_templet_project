//
//  DateTableDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/4/21 8:09 AM.
//  Copyright © 6/4/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tuple/tuple.dart';

class DataTableDemo extends StatefulWidget {
  final String? title;

  const DataTableDemo({Key? key, this.title}) : super(key: key);

  @override
  _DataTableDemoState createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo> {
  // List<String> titles = ['姓名', '年龄', '性别', '出生年份', '出生月份'];
  List<Tuple2> titles = [
    Tuple2("姓名", "name", ),
    Tuple2("性别", "sex", ),
    Tuple2("年龄", "age", ),
    Tuple2('出生年份', "birdthYear", ),
    Tuple2('出生月份', "birdthMonth", ),
  ];

  List<User> models = [
    User(name: "name", sex: "男", age: 28, birdthYear: 2020, birdthMonth: 12),
    User(name: "name1", sex: "女", age: 18, birdthYear: 2018, birdthMonth: 8),
    User(name: "name2", sex: "男", age: 21, birdthYear: 2017, birdthMonth: 5),
    User(name: "name3", sex: "女", age: 19, birdthYear: 2020, birdthMonth: 7),
    User(name: "name4", sex: "男", age: 30, birdthYear: 2019, birdthMonth: 9),
    User(name: "name5", sex: "女", age: 22, birdthYear: 2016, birdthMonth: 18),
    User(name: "name6", sex: "男", age: 28, birdthYear: 2020, birdthMonth: 12),
    User(name: "name7", sex: "女", age: 18, birdthYear: 2018, birdthMonth: 8),
    User(name: "name8", sex: "男", age: 21, birdthYear: 2017, birdthMonth: 5),
    User(name: "name9", sex: "女", age: 19, birdthYear: 2020, birdthMonth: 7),
    User(name: "name10", sex: "男", age: 30, birdthYear: 2019, birdthMonth: 9),
    User(name: "name11", sex: "女", age: 22, birdthYear: 2016, birdthMonth: 18),
    User(name: "name12", sex: "男", age: 28, birdthYear: 2020, birdthMonth: 12),
    User(name: "name13", sex: "女", age: 18, birdthYear: 2018, birdthMonth: 8),
    User(name: "name14", sex: "男", age: 21, birdthYear: 2017, birdthMonth: 5),
    User(name: "name15", sex: "女", age: 19, birdthYear: 2020, birdthMonth: 7),
    User(name: "name16", sex: "男", age: 30, birdthYear: 2019, birdthMonth: 9),
    User(name: "name17", sex: "女", age: 22, birdthYear: 2016, birdthMonth: 18),
    User(name: "name18", sex: "男", age: 28, birdthYear: 2020, birdthMonth: 12),
    User(name: "name19", sex: "女", age: 18, birdthYear: 2018, birdthMonth: 8),
    User(name: "name20", sex: "男", age: 21, birdthYear: 2017, birdthMonth: 5),
    User(name: "name21", sex: "女", age: 19, birdthYear: 2020, birdthMonth: 7),
    User(name: "name22", sex: "男", age: 30, birdthYear: 2019, birdthMonth: 9),
    User(name: "name23", sex: "女", age: 22, birdthYear: 2016, birdthMonth: 18),
    User(name: "name24", sex: "男", age: 30, birdthYear: 2019, birdthMonth: 9),
  ];

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
            columns: titles.map((e) => DataColumn(
              label: Text(e.item1),
              onSort: (int columnIndex, bool ascending) {
                _changeSort(columnIndex: columnIndex, ascending: ascending);
              },
            )).toList(),
            rows: models.map((e) => DataRow(
              cells: [
                DataCell(Text(e.name)),
                DataCell(Text('${e.age}')),
                DataCell(Text(e.sex)),
                DataCell(Text('${e.birdthYear}')),
                DataCell(Text('${e.birdthMonth}')),
              ],
              selected: e.isSelected,
              onSelectChanged: (bool? value) {
                if (value == null) return;
                setState(() {
                  e.isSelected = value;
                });
                ddlog(models
                    .where((e) => e.isSelected == true)
                    .map((e) => "${e.name}_${e.isSelected}")
                    .toList());
              },
            )).toList(),
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
            models.sortedByValue(ascending: ascending, cb: (obj) => obj.age);
          break;

        case 2:
            models.sortedByValue(ascending: ascending, cb: (obj) => obj.sex);
          break;

        case 3:
            models.sortedByValue(ascending: ascending, cb: (obj) => obj.birdthYear);
          break;

        case 4:
            models.sortedByValue(ascending: ascending, cb: (obj) => obj.birdthMonth);
          break;

        default:
          // if (ascending) {
          //   models.sort((a, b) => a.name.compareTo(b.name));
          // } else {
          //   models.sort((a, b) => b.name.compareTo(a.name));
          // }
          models.sortedByValue(ascending: ascending, cb: (obj) => obj.name);
          break;
      }
    });
  }
}

class User {
  User({
    required this.name,
    required this.sex,
    required this.age,
    required this.birdthYear,
    required this.birdthMonth
  });

  final String name;
  final String sex;

  final int age;
  final int birdthYear;
  final int birdthMonth;

  bool isSelected = false;
}

class PaginatedDataTableDemo extends StatelessWidget {
  PaginatedDataTableDemo({Key? key}) : super(key: key);

  List<Tuple2> titles = [
    Tuple2("姓名", "name", ),
    Tuple2("性别", "sex", ),
    Tuple2("年龄",  "age", ),
    Tuple2('出生年份', "birdthYear", ),
    Tuple2('出生月份', "birdthMonth", ),
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
            header: Text('Header Text'),
            rowsPerPage: 3,
            columns: titles.map((e) => DataColumn(
              label: Text(e.item1),
            )).toList(),
            source: _DataSource(context),
          ),
        ],
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  _DataSource(this.context) {
    _rows = <User>[
      User(name: "name", sex: "男", age: 28, birdthYear: 2020, birdthMonth: 12),
      User(name: "name1", sex: "女", age: 18, birdthYear: 2018, birdthMonth: 8),
      User(name: "name2", sex: "男", age: 21, birdthYear: 2017, birdthMonth: 5),
      User(name: "name3", sex: "女", age: 19, birdthYear: 2019, birdthMonth: 7),
    ];
  }

  final BuildContext context;
  late List<User> _rows;

  int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    if (index >= _rows.length) return null;
    final e = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: e.isSelected,
      onSelectChanged: (value) {
        if (value == null) return;
        if (e.isSelected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          e.isSelected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(e.name)),
        DataCell(Text('${e.age}')),
        DataCell(Text(e.sex)),
        DataCell(Text('${e.birdthYear}')),
        DataCell(Text('${e.birdthMonth}')),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
