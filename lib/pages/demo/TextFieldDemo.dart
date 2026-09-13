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
import 'package:flutter_templet_project/basicWidget/AreaCodePicker/PhoneAreaCodeBtn.dart';
import 'package:flutter_templet_project/basicWidget/AreaCodePicker/PhoneAreaCodePopup.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_order_num_unit.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield_unit.dart';
import 'package:flutter_templet_project/mixin/asset_resource_mixin.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/get_util.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

class TextFieldDemo extends StatefulWidget {
  const TextFieldDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _TextFieldDemoState createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> with AssetResourceMixin {
  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  late final _textController = TextEditingController(text: '测试');
  late final editingController = TextEditingController(text: '测试');

  final _unameController = TextEditingController();
  final _pwdController = TextEditingController();

  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();

  bool isEye = true;
  final _unameExp = RegExp(r'^(?![0-9]+$)(?![a-z]+$)[0-9a-z]{6,12}$');
  final _pwdExp = RegExp(r'^(?![0-9]+$)(?![a-z]+$)[0-9a-z]{6,12}$');

  final delayed = Debouncer(delay: Duration(milliseconds: 1000));

  var tips = [
    "安卓手机普通键盘和安全键盘切换时焦点丢失?可以通过延迟 300ms 通过 focusNode 二次获取焦点解决.",
    "如果 sheet 弹窗中包含 TextField 键盘弹起后焦点丢失?可以给 TextField 的 focusNode属性赋值,解决动画之后焦点丢失的问题.",
    "TextField 的 readOnly 为 true 时,仍会唤起键盘? 可以设置 enabled 为 false 解决."
  ];

  final valueVN = ValueNotifier<AreaCodeEntity?>(null);

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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Icon(Icons.warning_amber),
                  ),
                ),
              ],
            ),
      body: buildColumn(),
      bottomSheet: buildScaffoldBottomSheet(),
    );
  }

  Widget buildScaffoldBottomSheet() {
    return Material(
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 12),
        decoration: BoxDecoration(
          border: Border(top: Divider.createBorderSide(context)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: <Widget>[
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    hintText: '输入消息',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {},
                child: const Text('发送'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColumn() {
    final theme = Theme.of(context);
    final fill = theme.inputDecorationTheme.fillColor;
    final cupertinoDecoration = BoxDecoration(
      color: fill,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      border: Border.all(color: theme.colorScheme.outline),
    );

    return SafeArea(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              NSectionBox(
                title: "NationalCode",
                child: Container(
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      PhoneAreaCodeBtn<AreaCodeEntity>(
                        onTap: () {
                          PhoneAreaCodePopup.show(
                            context,
                            onChange: (e) {
                              DLog.d(e.toJson());
                              valueVN.value = e;
                            },
                          );
                        },
                        valueVN: valueVN,
                        nameCb: (e) => e?.phoneCode != null ? "+${e?.phoneCode}" : "请选择",
                        padding: const EdgeInsets.only(left: 0, right: 0, top: 2),
                      ),
                      const Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            hintText: '请输入手机号',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              NSectionBox(
                title: "CupertinoTextField",
                child: CupertinoTextField(
                  controller: _textController,
                  placeholder: "请输入",
                  textAlign: TextAlign.center,
                  padding: const EdgeInsets.all(8),
                  suffixMode: OverlayVisibilityMode.editing,
                  decoration: cupertinoDecoration,
                ),
              ),
              NSectionBox(
                title: "CupertinoSearchTextField",
                child: CupertinoSearchTextField(
                  padding: const EdgeInsets.all(8),
                  placeholder: "请输入",
                  backgroundColor: fill,
                  onChanged: (value) {
                    delayed(() => debugPrint('delayed: $value'));
                  },
                  onSubmitted: (value) {
                    debugPrint('onSubmitted: $value');
                  },
                ),
              ),
              NSectionBox(
                title: "TextField（默认 InputDecorationTheme）",
                child: TextField(
                  controller: editingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight (KG)',
                  ),
                ),
              ),
              NSectionBox(
                title: "TextField readOnly",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: NOrderNumUnit(
                        value: editingController.text,
                        readOnly: false,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      child: NOrderNumUnit(
                        value: editingController.text,
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      child: NOrderNumUnit(
                        value: editingController.text,
                        readOnly: true,
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
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      child: NOrderNumUnit(
                        value: '2222',
                        readOnly: true,
                        unit: " g ",
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      child: NOrderNumUnit(
                        value: '3333',
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
              ),
              NSectionBox(
                title: "TextFormField",
                child: TextFormField(
                  controller: _unameController,
                  focusNode: focusNode1,
                  keyboardType: TextInputType.text,
                  maxLength: 12,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    hintText: '请输入账号',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    prefixIcon: const Icon(Icons.perm_identity),
                    suffixIcon: _unameController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.cancel, size: 18),
                            onPressed: () {
                              _unameController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  validator: (v) {
                    return !_unameExp.hasMatch(v!) ? '账号由6到12位数字与小写字母组成' : null;
                  },
                  onEditingComplete: () => FocusScope.of(context).requestFocus(focusNode2),
                  onChanged: (v) {
                    setState(() {});
                  },
                ),
              ),
              NSectionBox(
                title: "TextFormField - pwd",
                child: TextFormField(
                  controller: _pwdController,
                  focusNode: focusNode2,
                  obscureText: isEye,
                  maxLength: 12,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    hintText: '请输入密码',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.remove_red_eye, size: 20),
                      onPressed: () {
                        isEye = !isEye;
                        setState(() {});
                      },
                    ),
                  ),
                  validator: (v) {
                    return !_pwdExp.hasMatch(v!) ? '密码由6到12位数字与小写字母组成' : null;
                  },
                  onChanged: (v) {
                    setState(() {});
                  },
                  onEditingComplete: () {
                    DLog.d("onEditingComplete");
                  },
                ),
              ),
              NSectionBox(
                title: "buildUnit",
                child: buildUnit(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSheetTips() {
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
          constraints: const BoxConstraints(
            maxHeight: 600,
            minHeight: 300,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 12, left: 15, right: 15, bottom: 8),
                child: NText(
                  "焦点问题",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Flexible(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...tips.map((e) {
                          final i = tips.indexOf(e);
                          final question = "${i + 1}.${e.split("?").firstOrNull ?? "-"}";
                          final answer = e.split("?").lastOrNull ?? "-";

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
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
              NFooterButtonBar(
                boxShadow: const [],
                padding: const EdgeInsets.only(top: 12, left: 15, right: 15),
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

  Widget buildUnit() {
    final assetFileContent = assetFileModels.firstOrNull?.content ?? "";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NTextfieldUnit(
          name: "输入模式：",
          value: "175.0",
          unit: "kg",
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
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
                padding: const EdgeInsets.only(bottom: 8),
                child: e,
              ))
          .toList(),
    );
  }
}
