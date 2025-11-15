//
//  TextFieldDemo.dart
//  flutter_templet_project
//
//  Created by shang on 8/14/21 9:43 AM.
//  Copyright © 8/14/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_order_num_unit.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield_unit.dart';
import 'package:flutter_templet_project/mixin/asset_resource_mixin.dart';
import 'package:flutter_templet_project/util/Debounce.dart';
import 'package:flutter_templet_project/util/Throttle.dart';
import 'package:flutter_templet_project/util/get_util.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class TextFieldDemo extends StatefulWidget {
  final String? title;

  const TextFieldDemo({Key? key, this.title}) : super(key: key);

  @override
  _TextFieldDemoState createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> with AssetResourceMixin {
  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

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

  var tips = [
    "安卓手机普通键盘和安全键盘切换时焦点丢失?可以通过延迟 300ms 通过 focusNode 二次获取焦点解决.",
    "如果 sheet 弹窗中包含 TextField 键盘弹起后焦点丢失?可以给 TextField 的 focusNode属性赋值,解决动画之后焦点丢失的问题.",
    "TextField 的 readOnly 为 true 时,仍会唤起键盘? 可以设置 enabled 为 false 解决."
  ];

  @override
  void initState() {
    super.initState();
    onAssetResourceFinished = () {
      DLog.d(assetFileModels);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text(widget.title ?? "$widget"),
              actions: [
                GestureDetector(
                  onTap: onSheetTips,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Icon(
                      Icons.warning_amber,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
      body: buildColumn(),
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

  Widget buildColumn() {
    return SafeArea(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              NSectionBox(
                title: "CupertinoTextField",
                child: CupertinoTextField(
                  controller: _textController,
                  placeholder: "请输入",
                  textAlign: TextAlign.center,
                  padding: EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
                  suffixMode: OverlayVisibilityMode.editing,
                  decoration: BoxDecoration(
                    // color: CupertinoColors.tertiarySystemFill,
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
              NSectionBox(
                title: "CupertinoSearchTextField",
                child: CupertinoSearchTextField(
                  // prefixIcon: SizedBox(),
                  // prefixInsets: EdgeInsets.zero,
                  padding: EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
                  placeholder: "请输入",
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
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
              NSectionBox(
                title: "TextField",
                child: buildTextField(
                  controller: editingController,
                  keyboardType: TextInputType.number,
                  labelText: 'Weight (KG)',
                ),
              ),
              NSectionBox(
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
              NSectionBox(
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
              NSectionBox(
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
                    isCollapsed: true,
                    hintText: '请输入账号',
                    // labelText: "账号",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    prefixIcon: Icon(Icons.perm_identity),
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(4.0) //圆角大小
                    // ),
                    suffixIcon: _unameController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.grey,
                              size: 18,
                            ),
                            onPressed: () {
                              _unameController.clear();
                              //   _unameController.text = '';
                              //   // checkLoginText();
                              setState(() {});
                            },
                          )
                        : null,
                    border: buildFocusedBorder(),
                    focusedBorder: buildFocusedBorder(color: primaryColor),
                    enabledBorder: buildFocusedBorder(),
                  ),
                  validator: (v) {
                    return !_unameExp.hasMatch(v!) ? '账号由6到12位数字与小写字母组成' : null;
                  },
                  onEditingComplete: () => FocusScope.of(context).requestFocus(focusNode2),
                  onChanged: (v) {
                    // checkLoginText();
                    setState(() {});
                  },
                ),
              ),
              NSectionBox(
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
                    isCollapsed: true,
                    hintText: '请输入密码',
                    // labelText: '密码',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    prefixIcon: Icon(Icons.lock),
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(40.0)
                    // ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        size: 20,
                      ),
                      onPressed: () {
                        isEye = !isEye;
                        setState(() {});
                      },
                    ),
                    border: buildFocusedBorder(),
                    focusedBorder: buildFocusedBorder(color: primaryColor),
                    enabledBorder: buildFocusedBorder(),
                  ),
                  validator: (v) {
                    return !_pwdExp.hasMatch(v!) ? '密码由6到12位数字与小写字母组成' : null;
                  },
                  onChanged: (v) {
                    // checkLoginText();
                    setState(() {});
                  },
                  onEditingComplete: () {
                    DLog.d("onEditingComplete");
                  }, //'完成'回调
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: NSectionBox(
                  title: "buildUnit",
                  child: buildUnit(),
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
    DLog.d("onChanged: $val, $index");
  }

  onPressed() {
    _throttle(() => debugPrint("${DateTime.now()}: onPressed"));
  }

  void onSheetTips() {
    // tips = kuanRong.split("\n");
    GetBottomSheet.showCustom(
      hideDragIndicator: false,
      addUnconstrainedBox: false,
      isScrollControlled: true,
      child: Material(
        child: Container(
          padding: EdgeInsets.only(
            top: 12,
            bottom: max(12, MediaQuery.of(context).padding.bottom) - 8,
          ),
          constraints: BoxConstraints(
            maxHeight: 600,
            minHeight: 300,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 15,
                  right: 15,
                  bottom: 8,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  // border: Border.all(color: Colors.blue),
                ),
                child: const NText(
                  "焦点问题",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColor.fontColor,
                  ),
                ),
              ),
              Flexible(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...tips.map((e) {
                            final i = tips.indexOf(e);
                            final question = "${i + 1}.${e.split("?").firstOrNull ?? "-"}";
                            final answer = e.split("?").lastOrNull ?? "-";

                            return Container(
                              padding: EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              child: ListTile(
                                dense: true,
                                title: NText(question),
                                subtitle: NText(answer),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              NFooterButtonBar(
                // hideCancel: !readOnly,
                boxShadow: const [],
                // enable: enable,
                padding: EdgeInsets.only(
                  top: 12,
                  left: 15,
                  right: 15,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                onCancel: () {
                  Navigator.of(context).pop();
                },
                onConfirm: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
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
      vertical: 6,
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

  Widget buildUnit() {
    final assetFileContent = assetFileModels.firstOrNull?.content ?? "";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NTextfieldUnit(
            name: "输入模式：",
            value: "175.0",
            unit: "kg",
            keyboardType: const TextInputType.numberWithOptions(decimal: true), // 显示数字键盘
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // 允许数字和小数点
            ],
            showClear: true,
            debounceMilliseconds: 500,
            onChanged: (value) async {
              DLog.d("体 重：$value");
            },
          ),
          NTextfieldUnit(
            name: "选择模式：",
            value: '',
            hitText: "请选择",
            onTap: () {
              DLog.d("化疗方案");
            },
            readOnly: true,
            readOnlyFillColor: AppColor.white,
            onChanged: (value) {
              DLog.d("化疗方案：$value");
            },
          ),
          NTextfieldUnit(
            name: "只读模式：",
            value: assetFileContent,
            hitText: "",
            maxLines: 9,
            onChanged: (value) {
              DLog.d("剂量公式：$value");
            },
            hideSuffix: true,
            readOnly: true,
          ),
        ]
            .map((e) => Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: e,
                ))
            .toList(),
      ),
    );
  }

  InputBorder buildFocusedBorder({
    double radus = 4,
    double borderWidth = 1,
    color = AppColor.lineColor,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radus)), //边角
      borderSide: BorderSide(
        color: color, //边框颜色为白色
        width: borderWidth, //宽度为1
      ),
    );
  }
}
