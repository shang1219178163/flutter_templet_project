//
//  FormDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/28 16:53.
//  Copyright © 2024/3/28 shang. All rights reserved.
//

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/editable_text_ext.dart';
import 'package:flutter_templet_project/extension/rich_text_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:get/get.dart';

/// 表单组件测试
class FormDemo extends StatefulWidget {
  FormDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<FormDemo> createState() => _FormDemoState();
}

class _FormDemoState extends State<FormDemo> {
  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  static const weChatSubTitleColor = Color(0xff737373);

  late final items = [
    (
      title: "真实姓名",
      key: "name",
      value: "",
      maxLines: 1,
      controller: TextEditingController(),
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(20),
      ],
    ),
    (
      title: "身份证号",
      key: "idCard",
      value: "",
      maxLines: 1,
      controller: TextEditingController(),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp('[X]|[0-9]')),
        LengthLimitingTextInputFormatter(18)
      ],
    ),
    (
      title: "手机号码",
      key: "phone",
      value: "",
      maxLines: 1,
      controller: TextEditingController(),
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(11),
      ],
    ),
    (
      title: "简       介",
      key: "description",
      value:
          "宝石：我曾踏足山巅，也曾进入低谷，二者都使我受益良多。 英文翻译——Once,I was the top.Once,I was the last.Both of them have benefited me a lot.",
      maxLines: null,
      controller: TextEditingController(),
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(200),
      ],
    ),
  ];

  final resultVN = ValueNotifier("");

  String text = "字段【执业版APP】核心指标&电子病历，N类（数值类）字段历史记录统计可视化趋势图支持拉取更多历史数据;核心指标&电子病历";
  List<String> delimiters = ['APP', '指标', '电子', '数据', '字段', '类'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                'done',
              ]
                  .map((e) => TextButton(
                        onPressed: onPressed,
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                  .toList(),
            ),
      body: buildBody(),
    );
  }

  onPressed() {
    final isSame = items[1].controller == items[1].controller;
    DLog.d("isSame: $isSame");
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // ...items.map((e){
            //   e.controller.text = e.value;
            //
            //   return Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       buildCell(
            //         title: e.title,
            //         trailing: buildTextfield(
            //           controller: e.controller,
            //           enabled: true,
            //           inputFormatters: e.inputFormatters,
            //           autofocus: false,
            //           maxLines: e.maxLines,
            //           onChanged: (v) {
            //             debugPrint('单行输入内容：$v');
            //           },
            //           onEditingComplete: () {
            //             FocusScope.of(context).unfocus();
            //           },
            //         ),
            //       ),
            //       // Text(e.toString()),
            //       Divider(height: 1, indent: 15, endIndent: 0,),
            //     ],
            //   );
            // }).toList(),
            NText(
              text,
              fontSize: 14,
              maxLines: 100,
            ),
            ValueListenableBuilder(
                valueListenable: resultVN,
                builder: (context, value, child) {
                  return NText(
                    value,
                    fontSize: 14,
                    maxLines: 100,
                  );
                }),
            Divider(
              height: 1,
            ),
            Text.rich(
              TextSpan(
                children: RichTextExt.createTextSpans(
                  text: text,
                  textTaps: delimiters,
                  onLink: (textTap) {
                    DLog.d("textTap: $textTap");
                  },
                ),
              ),
              maxLines: 100,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCell({
    required String title,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xff181818),
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: trailing,
          ),
        ],
      ),
    );
  }

  /// 身份证输入框
  Widget buildTextfield({
    required TextEditingController controller,
    String hintText = "请输入",
    List<TextInputFormatter>? inputFormatters,
    int? maxLines = 1,
    int maxLength = 1000,
    bool autofocus = false,
    bool readOnly = false,
    bool enabled = true,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
  }) {
    Color? borderColor = context.primaryColor;
    // borderColor = Color(0xffe4e4e4);

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
        color: borderColor,
        width: 1,
      ),
    );

    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.name,
      readOnly: readOnly,
      decoration: InputDecoration(
        enabled: enabled,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xffb3b3b3),
        ),
        border: !readOnly && maxLines == 1 ? InputBorder.none : focusedBorder,
        focusedBorder: focusedBorder,
        // focusedErrorBorder: null,
        // disabledBorder: null,
        // enabledBorder: null,
        contentPadding: EdgeInsets.symmetric(vertical: 4),
        isCollapsed: true,
        // counterText: readOnly || maxLines == 1 ? null : "${controller.text.length}/$maxLength",
        counter: readOnly || maxLines == 1
            ? null
            : controller.buildInputDecorationCounter(
                maxLength: maxLength,
              ),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: weChatSubTitleColor,
      ),
      inputFormatters: inputFormatters,
      autofocus: autofocus,
      maxLines: maxLines,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete ??
          () {
            FocusScope.of(context).unfocus();
          },
    );
  }

  /// 身份证输入框
  Widget buildPhoneTextfield({
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines = 1,
    bool autofocus = false,
    bool enabled = true,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
  }) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.name,
      decoration: InputDecoration.collapsed(
        enabled: enabled,
        hintText: "请输入身份证号码",
        hintStyle: const TextStyle(
          color: Color(0xffb3b3b3),
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: weChatSubTitleColor,
      ),
      autofocus: autofocus,
      maxLines: maxLines,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete ??
          () {
            FocusScope.of(context).unfocus();
          },
    );
  }
}
