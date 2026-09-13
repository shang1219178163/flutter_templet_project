//
//  TextFieldDemo.dart
//  flutter_templet_project
//
//  Created by shang on 8/14/21 9:43 AM.
//  Copyright © 8/14/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/TextInputFormatter/fraction_digits_text_input_formatter.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class TextFieldDemoOne extends StatefulWidget {

  const TextFieldDemoOne({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _TextFieldDemoOneState createState() => _TextFieldDemoOneState();
}

class _TextFieldDemoOneState extends State<TextFieldDemoOne> {
  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final textEditingController = TextEditingController();

  final current = ValueNotifier("");

  ///用来控制  TextField 焦点的获取与关闭
  FocusNode focusNode = FocusNode();

  ///文本输入框是否可编辑
  bool isEnable = true;

  final inputFormatters = <Tuple3<String, TextInputFormatter, String>>[
    Tuple3("禁止换行符", FilteringTextInputFormatter.deny(RegExp(r'\n')), "FilteringTextInputFormatter.deny(RegExp(r'\n'))"),
    Tuple3("长度限制", LengthLimitingTextInputFormatter(10), "LengthLimitingTextInputFormatter(10)"),
    Tuple3("英文字母/汉字/数字", FilteringTextInputFormatter(RegExp("[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]"), allow: true),
        "FilteringTextInputFormatter(RegExp('[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]'), allow: true)"),
    Tuple3("仅数字", FilteringTextInputFormatter.digitsOnly, "FilteringTextInputFormatter.digitsOnly"),
    Tuple3("仅单行", FilteringTextInputFormatter.singleLineFormatter, "FilteringTextInputFormatter.singleLineFormatter,"),
  ];

  @override
  void initState() {
    super.initState();

    textEditingController.value = TextEditingValue(text: "widget.value");

    ///添加获取焦点与失去焦点的兼听
    focusNode.addListener(() {
      ///当前兼听的 TextFeild 是否获取了输入焦点
      var hasFocus = focusNode.hasFocus;

      ///当前 focusNode 是否添加了兼听
      debugPrint("focusNode 兼听 hasFocus:$hasFocus");
    });

    /// WidgetsBinding 它能监听到第一帧绘制完成，第一帧绘制完成标志着已经Build完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ///获取输入框焦点
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text(widget.title ?? "$widget"),
            ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buildButtons(),
          ),
          buildTextField(),
          Divider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...inputFormatters.map((e) {
                return ListTile(
                  title: Text(e.item1),
                  subtitle: Text(e.item3),
                );
              }).toList()
            ],
          )
        ],
      ),
    );
  }

  List<Widget> buildButtons() {
    return [
      TextButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(focusNode);
        },
        child: Text("获取焦点"),
      ),
      TextButton(
        onPressed: () {
          focusNode.unfocus();
        },
        child: Text("失去焦点"),
      ),
      TextButton(
        onPressed: () {
          isEnable = true;
          setState(() {});
        },
        child: Text("编辑"),
      ),
      TextButton(
        onPressed: () {
          isEnable = false;
          setState(() {});
        },
        child: Text("不可编辑"),
      ),
    ];
  }

  Widget buildTextField({
    ValueChanged<String>? onChanged,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final fill = theme.inputDecorationTheme.fillColor;
    OutlineInputBorder outline(Color color, {double radius = 10}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        borderSide: BorderSide(color: color, width: 2),
      );
    }

    return SizedBox(
      width: 400,
      height: 130,
      child: Container(
        color: cs.surfaceContainer,
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: TextField(
          controller: textEditingController,
          onChanged: (val) {
            current.value = val;
            onChanged?.call(val);
          },
          enabled: isEnable,
          focusNode: focusNode,
          inputFormatters: [FractionDigitsTextInputFormatter()],
          decoration: InputDecoration(
            filled: true,
            fillColor: fill,
            hintText: "请输入用户名",
            hintStyle: TextStyle(
              color: theme.hintColor,
              textBaseline: TextBaseline.ideographic,
            ),
            labelText: "用户名",
            labelStyle: TextStyle(color: cs.primary),
            helperText: "这里是帮助提示语",
            helperStyle: TextStyle(color: cs.tertiary),
            errorText: "这里是错误文本提示",
            errorStyle: TextStyle(color: cs.error),
            prefixText: "prefix  ",
            prefixStyle: TextStyle(color: cs.primary),
            suffixText: "suf ",
            suffixStyle: TextStyle(color: cs.onSurface),
            counterText: "count",
            counterStyle: TextStyle(color: cs.onSurfaceVariant),
            prefixIcon: const Icon(Icons.phone),
            suffixIcon: ValueListenableBuilder<String>(
              valueListenable: current,
              builder: (context, value, child) {
                if (value.isEmpty) {
                  return const SizedBox();
                }
                return IconButton(
                  onPressed: () {
                    textEditingController.clear();
                    current.value = "";
                  },
                  icon: Image(
                    image: AssetImage(Assets.imagesIconClear),
                    width: 16,
                    height: 16,
                  ),
                );
              },
            ),
            border: outline(cs.outline),
            enabledBorder: outline(cs.primary),
            disabledBorder: outline(cs.outlineVariant),
            focusedBorder: outline(cs.primary, radius: 20),
          ),
        ),
      ),
    );
  }
}

// const TextField({
// Key key,
// this.controller,                    // 控制正在编辑文本
// this.focusNode,                     // 获取键盘焦点
// this.decoration = const InputDecoration(),              // 边框装饰
// TextInputType keyboardType,         // 键盘类型
// this.textInputAction,               // 键盘的操作按钮类型
// this.textCapitalization = TextCapitalization.none,      // 配置大小写键盘
// this.style,                         // 输入文本样式
// this.textAlign = TextAlign.start,   // 对齐方式
// this.textDirection,                 // 文本方向
// this.autofocus = false,             // 是否自动对焦
// this.obscureText = false,           // 是否隐藏内容，例如密码格式
// this.autocorrect = true,            // 是否自动校正
// this.maxLines = 1,                  // 最大行数
// this.maxLength,                     // 允许输入的最大长度
// this.maxLengthEnforced = true,      // 是否允许超过输入最大长度
// this.onChanged,                     // 文本内容变更时回调
// this.onEditingComplete,             // 提交内容时回调
// this.onSubmitted,                   // 用户提示完成时回调
// this.inputFormatters,               // 验证及格式
// this.enabled,                       // 是否不可点击
// this.cursorWidth = 2.0,             // 光标宽度
// this.cursorRadius,                  // 光标圆角弧度
// this.cursorColor,                   // 光标颜色
// this.keyboardAppearance,            // 键盘亮度
// this.scrollPadding = const EdgeInsets.all(20.0),        // 滚动到视图中时，填充边距
// this.enableInteractiveSelection,    // 长按是否展示【剪切/复制/粘贴菜单LengthLimitingTextInputFormatter】
// this.onTap,                         // 点击时回调
// })
