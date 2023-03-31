import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/nn_date_picker.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

class CupertinoFormDemo extends StatefulWidget {
  final String? title;

  const CupertinoFormDemo({Key? key, this.title}) : super(key: key);

  @override
  _CupertinoFormDemoState createState() => _CupertinoFormDemoState();
}

class _CupertinoFormDemoState extends State<CupertinoFormDemo> {
  late final TextEditingController _textController =
      TextEditingController(text: 'initial text');

  bool isSwitch = true;

  DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildCupertinoForm(context),
      // body: buildbody(context),
    );
  }

  Widget buildCupertinoForm(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // padding: EdgeInsets.all(15),
        child: Form(
          child: Column(
            children: [
              CupertinoFormSection.insetGrouped(
                  header: Text('SECTION 1'),
                  children: [
                    CupertinoFormRow(
                      padding: EdgeInsets.all(15),
                      child: InkWell(
                        onTap: () {
                          ddlog("buildSubtitleRow");
                        },
                        child: buildSubtitleRow(context),
                      ),
                    ),
                    CupertinoFormRow(
                      child: InkWell(
                        onTap: () {
                          ddlog("buildRightButtonRow");
                        },
                        child: buildRightButtonRow(context),
                      ),
                    ),
                    CupertinoFormRow(
                      child: InkWell(
                        onTap: () {
                          ddlog("buildSwitchRow");
                        },
                        child: buildSwitchRow(context),
                      ),
                    ),
                    CupertinoFormRow(
                      child: InkWell(
                        onTap: () {
                          showDatePicker(context);
                        },
                        child: buildDatePickerRow(context),
                      ),
                    ),
                    CupertinoTextFormFieldRow(
                      prefix: Text('TextField'),
                      placeholder: 'Enter text',
                      textAlign: TextAlign.end,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (value.length < 6) {
                          return '长度不能小于6';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        ddlog(value);
                        setState(() {

                        });
                      },
                      onEditingComplete: () {
                        ddlog("onEditingComplete");
                      },
                    ),
                  ]),
              CupertinoFormSection.insetGrouped(
                header: Text('SECTION 2'),
                children: List<Widget>.generate(5, (int index) {
                  return CupertinoTextFormFieldRow(
                    prefix: Text('TextField'),
                    placeholder: 'Enter text',
                    textAlign: TextAlign.end,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLogo(Widget? child) {
    return Padding(
      //Paddng控件，用来设置Image控件边距
      padding: EdgeInsets.only(right: 5), //上下左右边距均为1
      child: ClipRRect(
        //圆⻆矩形裁剪控件
        borderRadius: BorderRadius.circular(8.0), //圆⻆半径为8
        // child: Image.asset(data.appIcon, width: 60, height: 60),
        child: child,
      ),
    );
  }

  Widget buildSubtitleRow(BuildContext context) {
    return Row(children: <Widget>[
      buildLogo(FlutterLogo(
        size: 30,
      )),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //垂直方向居中对⻬
          crossAxisAlignment: CrossAxisAlignment.start, //水平方向居左对⻬
          children: <Widget>[
            Text("title", maxLines: 1, overflow: TextOverflow.ellipsis),
            Text("subtitle", maxLines: 1),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      ),
    ]);
  }

  Widget buildDatePickerRow(BuildContext context) {
    return Row(children: <Widget>[
      // buildLogo(FlutterLogo(size: 30,)),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //垂直方向居中对⻬
          crossAxisAlignment: CrossAxisAlignment.start, //水平方向居左对⻬
          children: <Widget>[
            Text("时间日期"),
          ],
        ),
      ),
      Text(
          dateTime.toString() == "null"
              ? "choose"
              : dateTime.toString().split(".").first,
          maxLines: 1),
      // TextButton(
      //   onPressed: onPressed,
      //   child: Text(dateTime.toString() == "null" ? "choose" : dateTime.toString().split(".").first, maxLines: 1),),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      ),
    ]);
  }

  Widget buildSwitchRow(BuildContext context) {
    return Row(children: <Widget>[
      // buildLogo(FlutterLogo(size: 30,)),
      Expanded(
        child: Text(
          "title",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      CupertinoSwitch(
          value: isSwitch,
          onChanged: (value) {
            setState(() {
              isSwitch = !isSwitch;
            });
          }),
    ]);
  }

  Widget buildRightButtonRow(BuildContext context) {
    return Row(children: <Widget>[
      // buildLogo(FlutterLogo(size: 30,)),
      Expanded(
        child: Text(
          "title",
        ),
      ),
      TextButton(
        onPressed: () {
          ddlog("button");
        },
        child: Text(
          "button",
          style: TextStyle(color: Colors.blue),
        ),
      ),
    ]);
  }

  ///显示时间选择器
  void showDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return NNDatePicker(
            // mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (val) {
              ddlog(val.toString());
              dateTime = val;
            },
            confirmOnPressed: () {
              ddlog("confirm");
              setState(() {});

              Navigator.of(context).pop();
            },
            cancellOnPressed: () {
              ddlog("cancell");
              Navigator.of(context).pop();
            },
          );
        });
  }
}
