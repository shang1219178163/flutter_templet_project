
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/chioce_wrap.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_templet_project/basicWidget/chioce_list.dart';
import 'package:flutter_templet_project/extension/list_extension.dart';
import 'package:flutter_templet_project/extension/widget_extension.dart';

import 'ListTileDemo.dart';

class PickerDemo extends StatefulWidget {

  @override
  _PickerDemoState createState() => _PickerDemoState();
}

class _PickerDemoState extends State<PickerDemo> {

  var titles = [
    "datePicker", "datePicker浅封装", "datePicker封装",
    "Picker浅封装", "Picker封装", "自定义",
    "单选滚动列表", "多选滚动列表", "多种类按钮",
    "日期选择", "日期时段选择"];

  late String title = "$widget";

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text("$title"),
        ),
        // body: buildWrap(context).padding(all: 10)
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
        child: Text(e, style: TextStyle(fontSize: 12, color: Colors.black87)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1.0, color: Colors.blue),
          padding: EdgeInsets.all(0),
        ),
    )).toList();
  }

  Future<void> _onPressed(int e) async {
    ddlog(e);

    switch (e) {
      case 0:
        {
          _showDatePicker(
              context: context,
              callback: (DateTime dateTime, String title) {
                ddlog([dateTime, title]);

              });
        }
        break;
      case 1:
       {
         DateTime dateTime = DateTime.now();

         widget.showBottomPicker(context: context,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: dateTime,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() => dateTime = newDateTime);
                  ddlog(dateTime);
                },
              ),
              callback: (title){
                ddlog(title);
              });

       }
        break;

      case 2:
        {
          widget.showDatePicker(context: context, callback: (dateTime, title){
            ddlog([dateTime, title]);
          });
        }
        break;

      case 3:
        {
          int _selectedValue = 0;

          widget.showBottomPicker(
              context: context,
              child: SafeArea(
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 30,
                  scrollController: FixedExtentScrollController(initialItem: 1),
                  children: List.generate(10, (index) =>
                      Text('选择_$index',
                    style: TextStyle(fontSize: 16),)
                  ),
                  onSelectedItemChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                ),
              ),
              callback: (title){
                ddlog([_selectedValue, title]);
              });
        }
        break;

      case 4:
        {
          widget.showPickerList(context: context,
              children: List.generate(10, (index) => Text('item_$index')),
              callback: (index, title){
                ddlog([index, title]);
              });
        }
        break;

      case 5:
        {
          widget.showBottomPicker(context: context,
              height: 600,
              child: Container(
                color: Colors.green,
                // height: 500,
                child: TextButton(child: Text("Button"),
                  onPressed: (){
                    ddlog("Button");
                  },
                ),
              ), callback: (String title) {
                ddlog(title);
            },
          );
        }
        break;

      case 6:
        {
          final list = [
            ChioceModel(title: Text("微信支付"), subtitle: Text("微信支付，不止支付"), secondary: Icon(Icons.camera), selected: true),
            ChioceModel(title: Text("阿里支付"), subtitle: Text("支付就用支付宝"), secondary: Icon(Icons.palette), selected: true),
            ChioceModel(title: Text("银联支付"), subtitle: Text("不打开APP就支付"), secondary: Icon(Icons.payment), selected: true),
          ];

          widget.showBottomPicker(context: context,
            height: 500,
            child: Container(
              // color: Colors.green,
              child: ChioceList(
                // isMutiple: true,
                children: list*5,
                indexs: [0],
                canScroll: true,
                callback: (Object index) {
                  ddlog(index);
                },
              ),
            ).toMaterial(),
            callback: (String title) {
              ddlog(title);
            },
          );
        }
        break;

      case 7:
        {
          final list = [
            ChioceModel(title: Text("微信支付"), subtitle: Text("微信支付，不止支付"), secondary: Icon(Icons.camera), selected: true),
            ChioceModel(title: Text("阿里支付"), subtitle: Text("支付就用支付宝"), secondary: Icon(Icons.palette), selected: true),
            ChioceModel(title: Text("银联支付"), subtitle: Text("不打开APP就支付"), secondary: Icon(Icons.payment), selected: true),

          ];

          widget.showBottomPicker(context: context,
            height: 600,
            child: Container(
              // color: Colors.green,
              // height: 500,
              child: ChioceList(
                isMutiple: true,
                children: list*5,
                indexs: [0],
                canScroll: true,
                callback: (Object index) {
                  ddlog(index);
                  },
              ),
            )
                // .toMaterial()
            ,
            callback: (String title) {
              ddlog(title);
            },
          );
        }
        break;

      case 8:
        {
          widget.showBottomPicker(
            context: context,
            height: 600,
            child: ListTileDemo(),
            callback: (String title) {
              ddlog(title);
            },
          );
        }
        break;

      case 9:
        {
          final DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: DateTime(2020, 11, 17),
            firstDate: DateTime(2017, 1),
            lastDate: DateTime(2022, 7),
            helpText: 'Select a date',

          );
          setState(() {
            title = newDate.toString();
          });
        }
        break;

      case 10:
        {
          final DateTimeRange? dateRange = await showDateRangePicker(
            context: context,
            initialDateRange: DateTimeRange(
              start: DateTime(2020, 11, 17),
              end: DateTime(2020, 11, 24),
            ),
            firstDate: DateTime(2017, 1),
            lastDate: DateTime(2022, 7),
            helpText: 'Select a date',
          );
          setState(() {
            title = dateRange.toString();
          });
        }
        break;
      default:
        break;
    }
  }


  void _showDatePicker({
    required BuildContext context,
    DateTime? initialDateTime,
    CupertinoDatePickerMode? mode,
    required void callback(DateTime dateTime, String title)}) {

    DateTime dateTime = initialDateTime ?? DateTime.now();

    final title = "请选择";
    final actionTitles = ['取消', '确定'];

    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 300,
          // color: Color.fromARGB(255, 255, 255, 255),
          color: Colors.white,
          child: Column(
            children: [
              Row(children: [
                // Close the modal
                CupertinoButton(
                  child: Text(actionTitles[0]),
                  // onPressed: () => Navigator.of(ctx).pop(),
                  onPressed: (){
                    callback(dateTime, actionTitles[1]);
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(child: Text(title,
                  style: TextStyle(fontSize: 17,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      backgroundColor: Colors.white,
                      decoration: TextDecoration.none),
                  textAlign: TextAlign.center,)
                ),

                CupertinoButton(
                  child: Text(actionTitles[1]),
                  // onPressed: () => Navigator.of(ctx).pop(),
                  onPressed: (){
                    callback(dateTime, actionTitles[1]);
                    Navigator.of(context).pop();
                  },
                ),
              ],),
              Container(
                height: 216,
                color: Colors.white,
                child: CupertinoDatePicker(
                    mode: mode ?? CupertinoDatePickerMode.date,
                    initialDateTime: dateTime,
                    onDateTimeChanged: (val) {
                      setState(() {
                        dateTime = val;
                        ddlog(val);
                      });
                    }),
              ),
            ],
          ),
        ));
  }

  void _showPicker({required BuildContext ctx,
    required void callBlack(int)}) {
    // int _selectedValue = 0;

    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
          width: 300,
          height: 250,
          child: CupertinoPicker(
            backgroundColor: Colors.white,
            itemExtent: 30,
            scrollController: FixedExtentScrollController(initialItem: 1),
            children: [
              Text('0'),
              Text('1'),
              Text('2'),
            ],
            onSelectedItemChanged: (value) {
              setState(() {
                // _selectedValue = value;
                callBlack(value);
              });
            },
          ),
        ));
  }
}



class DatePickerDemo extends StatefulWidget {
  DateTime? dateTime = DateTime.now();
  void Function(DateTime dateTime)? callback;

  DatePickerDemo({
    this.dateTime,
    this.callback,
  });

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
          child: Text('Show Picker'),
          onPressed: () {
            // _showDatePicker(context);
            _datePickerValueChange(context);
          },
        ),),
      ),
      child: SafeArea(
        child: Center(
          child: TextButton(
            child: Text(time),
            onPressed: (){
            // _showDatePicker(context);
              _datePickerValueChange(context);
            },
          )
        ),
      ),
    );
  }

  ///时间变动
  void _datePickerValueChange(context) {
    widget.showDatePicker(
        context: context,
        mode: CupertinoDatePickerMode.date,
        callback: (datetime, title){
      ddlog("$datetime, $title");
      if (title == "取消") {
        return;
      }
      setState(() {
        widget.dateTime = datetime;
      });
    });

    // groovyScript("def result = ''; _1.split().eachWithIndex { item, index -> result = result + index.next() + '. ' + item + System.lineSeparator() }; return result;", SELECTION);
    // groovyScript("return _editor.filePath().split('/').get(4)");
  }

}

