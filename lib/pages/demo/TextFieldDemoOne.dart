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
import 'package:flutter_templet_project/basicWidget/text_input_formatter_decimal.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:tuple/tuple.dart';

class TextFieldDemoOne extends StatefulWidget {

  final String? title;

  const TextFieldDemoOne({ Key? key, this.title}) : super(key: key);

  
  @override
  _TextFieldDemoOneState createState() => _TextFieldDemoOneState();
}

class _TextFieldDemoOneState extends State<TextFieldDemoOne> {
  final textEditingController = TextEditingController();

 final current = ValueNotifier("");


  ///用来控制  TextField 焦点的获取与关闭
  FocusNode focusNode = FocusNode();
  ///文本输入框是否可编辑
  bool isEnable = true;

  final inputFormatters = <Tuple3<String, TextInputFormatter, String>>[
    Tuple3(
      "长度限制",
      LengthLimitingTextInputFormatter(10),
      "LengthLimitingTextInputFormatter(10)"
    ),
    Tuple3(
      "英文字母/汉字/数字",
      FilteringTextInputFormatter(RegExp("[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]"), allow: true),
      "FilteringTextInputFormatter(RegExp('[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]'), allow: true)"
    ),
    Tuple3(
      "仅数字",
      FilteringTextInputFormatter.digitsOnly,
      "FilteringTextInputFormatter.digitsOnly"
    ),
    Tuple3(
      "仅单行",
      FilteringTextInputFormatter.singleLineFormatter,
      "FilteringTextInputFormatter.singleLineFormatter,"
    ),
  ];

  @override
  void initState() {
    super.initState();

    textEditingController.value = TextEditingValue(text: "widget.value") ;

    ///添加获取焦点与失去焦点的兼听
    focusNode.addListener((){
      ///当前兼听的 TextFeild 是否获取了输入焦点
      var hasFocus = focusNode.hasFocus;
      ///当前 focusNode 是否添加了兼听
      var hasListeners = focusNode.hasListeners;

      debugPrint("focusNode 兼听 hasFocus:$hasFocus  hasListeners:$hasListeners");
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
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildButtons(),
          ),
          _buildTextField(),
          Divider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...inputFormatters.map((e){
                return ListTile(
                  title: Text("${e.item1}"),
                  subtitle: Text("${e.item3}"),
                );
              }).toList()
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _buildButtons() {
    return [
      TextButton(
        onPressed: (){
          FocusScope.of(context).requestFocus(focusNode);
        },
        child: Text("获取焦点"),
      ),
      TextButton(
        onPressed: (){
          focusNode.unfocus();
        },
        child: Text("失去焦点"),
      ),
      TextButton(
        onPressed: (){
        isEnable = true;
        setState(() {});
      },
        child: Text("编辑"),
      ),
      TextButton(
        onPressed: (){
          isEnable = false;
          setState(() {});
        },
        child: Text("不可编辑"),
      ),
    ];
  }

  _buildTextField({
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      ///SizedBox 用来限制一个固定 width height 的空间
      child: SizedBox(
        width: 400,
        height: 130,
        child: Container(
          color: Colors.white24,
          ///距离顶部
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.all(10),
          ///Alignment 用来对齐 Widget
          alignment: Alignment(0, 0),
          ///文本输入框
          child: TextField(
            controller: textEditingController,
            onChanged: (val) {
              current.value = val;
              onChanged?.call(val);
            },
            ///是否可编辑
            enabled: isEnable,
            ///焦点获取
            focusNode: focusNode,
            inputFormatters: [TextInputFormatterDecimal()],
            ///用来配置 TextField 的样式风格
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF3F3F3),
              ///设置输入文本框的提示文字
              ///输入框获取焦点时 并且没有输入文字时
              hintText: "请输入用户名",
              ///设置输入文本框的提示文字的样式
              hintStyle: TextStyle(color: Colors.grey,textBaseline: TextBaseline.ideographic,),
              ///输入框内的提示 输入框没有获取焦点时显示
              labelText: "用户名",
              labelStyle: TextStyle(color: Colors.blue),
              ///显示在输入框下面的文字
              helperText: "这里是帮助提示语",
              helperStyle: TextStyle(color: Colors.green),

              ///显示在输入框下面的文字
              ///会覆盖了 helperText 内容
              errorText: "这里是错误文本提示",
              errorStyle: TextStyle(color: Colors.red),

              ///输入框获取焦点时才会显示出来 输入文本的前面
              prefixText: "prefix  ",
              prefixStyle: TextStyle(color: Colors.deepPurple),
              ///输入框获取焦点时才会显示出来 输入文本的后面
              suffixText: "suf ",
              suffixStyle: TextStyle(color: Colors.black),

              ///文本输入框右下角显示的文本
              ///文字计数器默认使用
              counterText: "count",
              counterStyle: TextStyle(color: Colors.deepPurple[800]),

              ///输入文字前的小图标
              prefixIcon: Icon(Icons.phone),
              ///输入文字后面的小图标
              suffixIcon: ValueListenableBuilder<String>(
                 valueListenable: current,
                 builder: (context, value, child){
                  if (value.isEmpty) {
                    return SizedBox();
                  }
                  return IconButton(
                    onPressed: () {
                      textEditingController.clear();
                      current.value = "";
                    },
                    // icon: Icon(Icons.clear),
                    icon: Image(
                      image:"icon_clear.png".toAssetImage(),
                      width: 16,
                      height: 16,
                    ),
                  );
                }),
              // suffixIcon: textEditingController.text.isEmpty ? null : IconButton(
              //     onPressed: () => textEditingController.clear(),
              //     icon: Icon(Icons.close),
              // ),
              ///与 prefixText 不能同时设置
//                prefix: Text("A") ,
              /// 与 suffixText 不能同时设置
//                suffix:  Text("B") ,
              ///设置边框
              ///   InputBorder.none 无下划线
              ///   OutlineInputBorder 上下左右 都有边框
              ///   UnderlineInputBorder 只有下边框  默认使用的就是下边框
              border: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),
                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.red,
                  ///设置边框的粗细
                  width: 2.0,
                ),
              ),
              ///设置输入框可编辑时的边框样式
              enabledBorder: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),
                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.blue,
                  ///设置边框的粗细
                  width: 2.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(10)),
                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.red,
                  ///设置边框的粗细
                  width: 2.0,
                ),
              ),
              ///用来配置输入框获取焦点时的颜色
              focusedBorder: OutlineInputBorder(
                ///设置边框四个角的弧度
                borderRadius: BorderRadius.all(Radius.circular(20)),
                ///用来配置边框的样式
                borderSide: BorderSide(
                  ///设置边框的颜色
                  color: Colors.green,
                  ///设置边框的粗细
                  width: 2.0,
                ),
              ),
            ),
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

