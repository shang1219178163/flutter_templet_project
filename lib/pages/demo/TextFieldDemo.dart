//
//  TextFieldDemo.dart
//  flutter_templet_project
//
//  Created by shang on 8/14/21 9:43 AM.
//  Copyright © 8/14/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_section_header.dart';
import 'package:flutter_templet_project/basicWidget/n_order_num_unit.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/function_ext.dart';
import 'package:flutter_templet_project/extension/image_ext.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/util/Debounce.dart';
import 'package:flutter_templet_project/util/Throttle.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

class TextFieldDemo extends StatefulWidget {
  final String? title;

  const TextFieldDemo({Key? key, this.title}) : super(key: key);

  @override
  _TextFieldDemoState createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  bool get hideApp =>
      Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  late final _textController = TextEditingController(text: '测试');
  late final editingController = TextEditingController(text: '测试');

  // 控制器
  final _unameController = TextEditingController();
  final _pwdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // 焦点
  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();

  bool isEye = true;
  bool isBtnEnabled = false;
  bool showLoading = false;
  final _unameExp = RegExp(r'^(?![0-9]+$)(?![a-z]+$)[0-9a-z]{6,12}$'); //用户名正则
  final _pwdExp = RegExp(r'^(?![0-9]+$)(?![a-z]+$)[0-9a-z]{6,12}$'); //密码正则

  final delayed = Debouncer(delay: Duration(milliseconds: 1000));
  final _debounce = Debounce();

  final _throttle = Throttle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text(widget.title ?? "$widget"),
              actions: [
                'done',
              ]
                  .map((e) => TextButton(
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: onPressed,
                      ))
                  .toList(),
            ),
      body: buildColumn(context),
      bottomSheet: Container(
        child: Row(
          children: <Widget>[
            Expanded(child: TextField()),
            ElevatedButton(
              onPressed: () {},
              child: Text('发送'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildColumn(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              NSectionHeader(
                title: "CupertinoTextField",
                child: CupertinoTextField(
                  controller: _textController,
                  placeholder: "请输入",
                  textAlign: TextAlign.start,
                  padding:
                      EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
                  suffixMode: OverlayVisibilityMode.editing,
                  onChanged: (val) => onChanged.debounce(value: val),
                ),
              ),
              NSectionHeader(
                title: "CupertinoTextField 1",
                child: CupertinoTextField(
                    controller: _textController,
                    placeholder: "请输入",
                    textAlign: TextAlign.center,
                    padding:
                        EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
                    suffixMode: OverlayVisibilityMode.editing,
                    decoration: BoxDecoration(
                      color: CupertinoColors.tertiarySystemFill,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    )),
              ),
              NSectionHeader(
                title: "CupertinoSearchTextField",
                child: CupertinoSearchTextField(
                  // prefixIcon: SizedBox(),
                  // prefixInsets: EdgeInsets.zero,
                  // backgroundColor: Colors.white,
                  padding:
                      EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
                  placeholder: "请输入",
                  onChanged: (String value) {
                    // debugPrint('onChanged: $value');
                    delayed(() => debugPrint('delayed: $value'));
                    // _debounce(() => debugPrint( 'delayed: $value' ));
                  },
                  onSubmitted: (String value) {
                    debugPrint('onSubmitted: $value');
                  },
                ),
              ),
              NSectionHeader(
                title: "TextField",
                child: buildTextField(
                  controller: editingController,
                  keyboardType: TextInputType.number,
                  labelText: 'Weight (KG)',
                ),
              ),
              NSectionHeader(
                title: "TextField readOnly",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: buildTextFieldUnit(
                          controller: editingController,
                          readOnly: false,
                          fillColorReadOnly: Colors.white,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                            FilteringTextInputFormatter.digitsOnly,
                          ]),
                    ),
                    SizedBox(
                      width: 48,
                    ),
                    Expanded(
                      child: buildTextFieldUnit(
                        controller: editingController,
                        readOnly: true,
                        fillColorReadOnly: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 48,
                    ),
                    Expanded(
                      child: buildTextFieldUnit(
                        controller: editingController,
                        readOnly: true,
                        fillColorReadOnly: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              NSectionHeader(
                title: "NOrderNumUnit",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: NOrderNumUnit(
                        value: '1111',
                        readOnly: false,
                        fillColorReadOnly: Colors.white,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 48,
                    ),
                    Expanded(
                      child: NOrderNumUnit(
                        value: '2222',
                        readOnly: true,
                        fillColorReadOnly: Colors.white,
                        unit: " g ",
                      ),
                    ),
                    SizedBox(
                      width: 48,
                    ),
                    Expanded(
                      child: NOrderNumUnit(
                        value: '3333',
                        readOnly: true,
                        fillColorReadOnly: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              NSectionHeader(
                title: "TextFormField",
                child: TextFormField(
                  //用户名
                  controller: _unameController,
                  focusNode: focusNode1,
                  //关联focusNode1
                  keyboardType: TextInputType.text,
                  //键盘类型
                  maxLength: 12,
                  textInputAction: TextInputAction.next,
                  //显示'下一步'
                  decoration: InputDecoration(
                      hintText: '请输入账号',
                      // labelText: "账号",
                      // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      prefixIcon: Icon(Icons.perm_identity),
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(4.0) //圆角大小
                      // ),
                      suffixIcon: _unameController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _unameController.clear();
                                //   _unameController.text = '';
                                //   // checkLoginText();
                                setState(() {});
                              },
                            )
                          : null),
                  validator: (v) {
                    return !_unameExp.hasMatch(v!) ? '账号由6到12位数字与小写字母组成' : null;
                  },
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(focusNode2),
                  onChanged: (v) {
                    // checkLoginText();
                    setState(() {});
                  },
                ),
              ),
              NSectionHeader(
                title: "TextFormField - pwd",
                child: TextFormField(
                  //密码
                  controller: _pwdController,
                  focusNode: focusNode2,
                  //关联focusNode1
                  obscureText: isEye,
                  //密码类型 内容用***显示
                  maxLength: 12,
                  textInputAction: TextInputAction.done,
                  //显示'完成'
                  decoration: InputDecoration(
                      hintText: '请输入密码',
                      // labelText: '密码',
                      // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      prefixIcon: Icon(Icons.lock),
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(40.0)
                      // ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                        ),
                        onPressed: () {
                          isEye = !isEye;
                          setState(() {});
                        },
                      )),
                  validator: (v) {
                    return !_pwdExp.hasMatch(v!) ? '密码由6到12位数字与小写字母组成' : null;
                  },
                  onChanged: (v) {
                    // checkLoginText();
                    setState(() {});
                  },
                  onEditingComplete: () {
                    ddlog("onEditingComplete");
                  }, //'完成'回调
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onChanged(val) {
    final index = IntExt.random(min: 1000, max: 9999);
    ddlog("onChanged: $val, $index");
  }

  onPressed() {
    _throttle(() => debugPrint("${DateTime.now()}: onPressed"));
  }

  Widget buildTextField({
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    String? labelText,
    Color? fillColor,
    Color borderColor = Colors.blue,
    double borderRadius = 4,
    bool isCollapsed = false,
    EdgeInsetsGeometry? contentPadding,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixIcon,
    BoxConstraints? suffixIconConstraints,
  }) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: borderColor),
      borderRadius: BorderRadius.circular(borderRadius),
    );

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      textAlignVertical: TextAlignVertical.center,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: fillColor,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        isCollapsed: isCollapsed,
        contentPadding: contentPadding,
        suffixIcon: suffixIcon,
        suffixIconConstraints: suffixIconConstraints,
      ),
    );
  }

  /// 高度 36
  buildTextFieldUnit({
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.number,
    bool readOnly = true,
    String? labelText,
    Color? fillColor = Colors.black12,
    Color? fillColorReadOnly = Colors.transparent,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixIcon,
    String unit = "元",
  }) {
    final contentPadding = EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 12,
    );
    return buildTextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      // labelText: 'Weight (KG)',
      borderColor: Colors.transparent,
      isCollapsed: true,
      contentPadding: contentPadding,
      fillColor: readOnly ? fillColorReadOnly : fillColor,
      inputFormatters: inputFormatters,
      suffixIconConstraints: BoxConstraints().loosen(),
      suffixIcon: suffixIcon ??
          Row(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: contentPadding.left),
                child: Text(
                  "| $unit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
