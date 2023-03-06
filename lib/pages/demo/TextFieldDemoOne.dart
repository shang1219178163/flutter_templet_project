//
//  TextFieldDemo.dart
//  flutter_templet_project
//
//  Created by shang on 8/14/21 9:43 AM.
//  Copyright © 8/14/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

class TextFieldDemoOne extends StatefulWidget {

  final String? title;

  TextFieldDemoOne({ Key? key, this.title}) : super(key: key);

  
  @override
  _TextFieldDemoOneState createState() => _TextFieldDemoOneState();
}

class _TextFieldDemoOneState extends State<TextFieldDemoOne> {

  ///用来控制  TextField 焦点的获取与关闭
  FocusNode focusNode = new FocusNode();
  ///文本输入框是否可编辑
  bool isEnable = true;

  @override
  void initState() {
    super.initState();

    ///添加获取焦点与失去焦点的兼听
    focusNode.addListener((){
      ///当前兼听的 TextFeild 是否获取了输入焦点
      bool hasFocus = focusNode.hasFocus;
      ///当前 focusNode 是否添加了兼听
      bool hasListeners = focusNode.hasListeners;

      print("focusNode 兼听 hasFocus:$hasFocus  hasListeners:$hasListeners");
    });

    /// WidgetsBinding 它能监听到第一帧绘制完成，第一帧绘制完成标志着已经Build完成
    WidgetsBinding.instance?.addPostFrameCallback((_) {
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
      body:  Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildButtons(),
          ),
          _buildTextField(),
        ],
      ),
    );
  }

  List<Widget> _buildButtons() {
    return [
      TextButton(child: Text("获取焦点"),onPressed: (){
        FocusScope.of(context).requestFocus(focusNode);
      },),
      TextButton(child: Text("失去焦点"),onPressed: (){
        focusNode.unfocus();
      },),
      TextButton(child: Text("编辑"),onPressed: (){
        setState(() {
          isEnable = true;
        });
      },),
      TextButton(child: Text("不可编辑"),onPressed: (){
        setState(() {
          isEnable = false;
        });
      },),
    ];
  }

  _buildTextField() {
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

            ///是否可编辑
            enabled: isEnable,
            ///焦点获取
            focusNode: focusNode,
            ///用来配置 TextField 的样式风格
            decoration: InputDecoration(
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
              prefixText: "prefix",
              prefixStyle: TextStyle(color: Colors.deepPurple),
              ///输入框获取焦点时才会显示出来 输入文本的后面
              suffixText: "suf ",
              suffixStyle: TextStyle(color: Colors.black),

              ///文本输入框右下角显示的文本
              ///文字计数器默认使用
              counterText: "count",
              counterStyle:TextStyle(color: Colors.deepPurple[800]),

              ///输入文字前的小图标
              prefixIcon: Icon(Icons.phone),
              ///输入文字后面的小图标
              suffixIcon: Icon(Icons.close),

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