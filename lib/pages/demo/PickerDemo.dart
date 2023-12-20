

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/PickerUtil.dart';
import 'package:flutter_templet_project/basicWidget/n_picker_tool_bar.dart';
import 'package:flutter_templet_project/basicWidget/chioce_wrap.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/date_time_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/basicWidget/chioce_list.dart';
import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/mixin/bottom_sheet_mixin.dart';
import 'package:flutter_templet_project/pages/demo/AlertSheetDemo.dart';

import 'package:flutter_templet_project/pages/demo/ListTileDemo.dart';
import 'package:get_storage/get_storage.dart';

class PickerDemo extends StatefulWidget {
  const PickerDemo({Key? key}) : super(key: key);

  @override
  _PickerDemoState createState() => _PickerDemoState();
}

class _PickerDemoState extends State<PickerDemo> with BottomSheetMixin {

  var titles = [
    "datePicker", "datePicker mixin封装", "datePicker封装",
    "Picker浅封装", "Picker封装", "自定义",
    "单选滚动列表", "多选滚动列表", "多种类按钮",
    "日期选择", "日期时段选择", "多项选择", "多项选择1"];

  late String title = "";

  /// 体重
  final weightData = <List<String>>[
    List<String>.generate(240, (index) => (index + 10).toString()).toList(),
    List<String>.generate(10, (index) => '.$index').toList(),
  ];

  late final weightSelectedData = [
    weightData[0][1],
    weightData[1][1],
  ];

  @override
  void initState() {
    super.initState();

    title = "$widget";
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: buildGridView(titles)
    );
  }

  Widget buildGridView(List<String> list) {
    return GridView.count(
      padding: EdgeInsets.all(15.0),
      //一行多少个
      crossAxisCount: 3,
      //滚动方向
      scrollDirection: Axis.vertical,
      // 左右间隔
      crossAxisSpacing: 8,
      // 上下间隔
      mainAxisSpacing: 8,
      //宽高比
      childAspectRatio: 1 / 0.3,

      children: initListWidget(list),
    );
  }

  List<Widget> initListWidget(List<String> list) {
    return list.map((e) => OutlinedButton(
        onPressed: (){
          _onPressed(list.indexOf(e));
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1.0, color: Colors.blue),
          padding: EdgeInsets.all(0),
        ),
        child: Text('${e}_${list.indexOf(e)}', style: TextStyle(fontSize: 12, color: Colors.black87)),
    )).toList();
  }

  Future<void> _onPressed(int e) async {
    switch (e) {
      case 0:
        {
          _showDatePicker(
            context: context,
            onConfirm: () {
              debugPrint("${DateTime.now()}");
            },
            onDateTimeChanged: (DateTime val) {
              debugPrint("${val}");
            },
          );
        }
        break;
      case 1:
       {
         presentCupertinoDatePicker(
           context: context,
           onDateTimeConfirm: (DateTime val) {
             debugPrint("${val}");
             Navigator.of(context).pop();
           },
         );
       }
        break;

      case 2:
        {

        }
        break;

      case 3:
        {
          var _selectedValue = 0;

          presentBottomSheet(
            context: context,
            onConfirm: () {
              debugPrint("${DateTime.now()} ${_selectedValue}");
              Navigator.of(context).pop();
            },
            child: SafeArea(
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 30,
                scrollController: FixedExtentScrollController(initialItem: _selectedValue),
                onSelectedItemChanged: (val) {
                  _selectedValue = val;
                  // setState(() {});
                },
                children: List.generate(10, (index) {
                  return Text('选择_$index',
                    style: TextStyle(fontSize: 16),
                  );
                }),
              ),
            ),
          );
        }
        break;

      case 4:
        {

        }
        break;

      case 5:
        {
          presentBottomSheet(
            context: context,
            // height: 600,
            onConfirm: () {
              debugPrint("${DateTime.now()}");
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.green,
              // height: 500,
              child: TextButton(
                onPressed: (){
                  ddlog("Button");
                },child: Text("Button"),
              ),
            ),
          );
        }
        break;

      case 6:
        {
          presentBottomSheet(
            context: context,
            // height: 500,
            onConfirm: () {
              debugPrint("${DateTime.now()}");
              Navigator.of(context).pop();
            },
            child: Material(
              child: Container(
                // color: Colors.green,
                child: ChioceList(
                  // isMutiple: true,
                  children: payTypes*5,
                  indexs: [0],
                  canScroll: true,
                  callback: (Object index) {
                    ddlog(index);
                  },
                ),
              ),
            ),
          );
        }
        break;

      case 7:
        {
          presentBottomSheet(
            context: context,
            // height: 600,
            onConfirm: () {
              debugPrint("${DateTime.now()}");
              Navigator.of(context).pop();
            },
            child: Container(
              // color: Colors.green,
              // height: 500,
              child: ChioceList(
                isMutiple: true,
                children: payTypes*5,
                indexs: [0],
                canScroll: true,
                callback: (Object index) {
                  ddlog(index);
                  },
              ),
            ),
          );
        }
        break;

      case 8:
        {
          presentBottomSheet(
            context: context,
            // height: 600,
            onConfirm: () {
              debugPrint("${DateTime.now()}");
              Navigator.of(context).pop();
            },
            child: Container(
              // height: 300,
              child: ListTileDemo()
            ),
          );
        }
        break;

      case 9:
        {
          final newDate = await showDatePicker(
            context: context,
            initialDate: DateTime(2020, 11, 17),
            firstDate: DateTime(2017, 1),
            lastDate: DateTime(2022, 7),
            helpText: 'Select a date',
          );

          title = newDate.toString();
          setState(() {});
        }
        break;

      case 10:
        {
          final dateRange = await showDateRangePicker(
            context: context,
            initialDateRange: DateTimeRange(
              start: DateTime(2020, 11, 17),
              end: DateTime(2020, 11, 24),
            ),
            firstDate: DateTime(2017, 1),
            lastDate: DateTime(2022, 7),
            helpText: 'Select a date',
          );

          title = dateRange.toString();
          setState(() {});
        }
        break;
      case 11:
      {
          PickerUtil.show(
            context: context,
            data: weightData[0],
            selectedData: weightData[0][1],
            onChanged: (val){
              debugPrint('onChanged: $val');
            },
            onSelected: (val){
              debugPrint('onSelected: $val');
            },
            onConfirm: (val){
              debugPrint('onConfirm: $val');
              Navigator.of(context).pop();
            },
            onCancel: () {
              Navigator.of(context).pop();
            }
          );
        }
        break;
      case 12:
        {
          PickerUtil.showMutible(
            context: context,
            data: weightData,
            selectedData: weightSelectedData,
            onChanged: (val){
              debugPrint('onChanged: $val');
            },
            onSelected: (val){
              // debugPrint('onSelected: $val');
            },
            onConfirm: (selectedItems) {
              debugPrint('onConfirm: $selectedItems');
              Navigator.of(context).pop();
            },
            onCancel: () {
              Navigator.of(context).pop();
            }
          );
        }
        break;
      default:
        break;
    }
  }

  void _showDatePicker({
    required BuildContext context,
    DateTime? initialDateTime,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
    required ValueChanged<DateTime> onDateTimeChanged,
    VoidCallback? onCancel,
    required VoidCallback onConfirm,
  }) {

    var dateTime = initialDateTime ?? DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return Container(
          height: 300,
          // color: Color.fromARGB(255, 255, 255, 255),
          color: Colors.white,
          child: Column(
            children: [
              NPickerToolBar(
                onCancel: onCancel,
                onConfirm: onConfirm,
              ),
              Divider(height: 1.0),
              Container(
                height: 216,
                color: Colors.white,
                child: CupertinoDatePicker(
                  mode: mode,
                  initialDateTime: dateTime,
                  dateOrder: DatePickerDateOrder.ymd,
                  onDateTimeChanged: (val) {
                    dateTime = val;
                    onDateTimeChanged(val);
                    setState(() {});
                  }
                ),
              ),
            ],
          ),
        );
      }
    );
  }



}



class DatePickerDemo extends StatefulWidget {

  DatePickerDemo({
    Key? key,
    this.dateTime,
    this.callback,
  }) : super(key: key);

  DateTime? dateTime = DateTime.now();

  void Function(DateTime dateTime)? callback;

  @override
  _DatePickerDemoState createState() => _DatePickerDemoState();
}

class _DatePickerDemoState extends State<DatePickerDemo> {

  @override
  Widget build(BuildContext context) {

    final time = widget.dateTime != null ? widget.dateTime!.toString19() : 'datetime picked';
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('$widget.dateTime'),
        // This button triggers the _showDatePicker function
        trailing: Container(child:
        CupertinoButton(
          padding: EdgeInsetsDirectional.zero,
          onPressed: () {
            // _showDatePicker(context);
            // _datePickerValueChange();
          },
          child: Text('Show Picker'),
        ),),
      ),
      child: SafeArea(
        child: Center(
          child: TextButton(
            onPressed: (){
            // _showDatePicker(context);
            //   _datePickerValueChange();
            },
            child: Text(time),
          )
        ),
      ),
    );
  }

  ///时间变动
  // void _datePickerValueChange() {
  //   context.showDatePicker(
  //       mode: CupertinoDatePickerMode.date,
  //       callback: (datetime, title){
  //     ddlog("$datetime, $title");
  //     if (title == "取消") {
  //       return;
  //     }
  //     setState(() {
  //       widget.dateTime = datetime;
  //     });
  //   });

    // groovyScript("def result = ''; _1.split().eachWithIndex { item, index -> result = result + index.next() + '. ' + item + System.lineSeparator() }; return result;", SELECTION);
    // groovyScript("return _editor.filePath().split('/').get(4)");
  // }

}

