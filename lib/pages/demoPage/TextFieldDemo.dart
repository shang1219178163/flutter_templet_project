//
//  TextFieldDemo.dart
//  fluttertemplet
//
//  Created by shang on 8/14/21 9:43 AM.
//  Copyright © 8/14/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertemplet/dartExpand/ddlog.dart';

class TextFieldDemo extends StatefulWidget {

  final String? title;

  TextFieldDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _TextFieldDemoState createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {

  late TextEditingController _textController = TextEditingController(text: 'initial text');
  late TextEditingController editingController = TextEditingController(text: 'initial text');

  // 控制器
  final _unameController =  TextEditingController();
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: buildColumn(context),
    );
  }

  Widget buildColumn(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          CupertinoTextField(controller: _textController),
          Spacer(),
          CupertinoSearchTextField(
            onChanged: (String value) {
              print('The text has changed to: $value');
            },
            onSubmitted: (String value) {
              print('Submitted text: $value');
            },
          ),
          Spacer(),
          TextField(
            controller: editingController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Weight (KG)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Spacer(),
          TextFormField( //用户名
            controller: _unameController,
            focusNode: focusNode1,//关联focusNode1
            keyboardType: TextInputType.text,//键盘类型
            maxLength: 12,
            textInputAction: TextInputAction.next,//显示'下一步'
            decoration: InputDecoration(
                hintText: '请输入账号',
                // labelText: "账号",
                // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                prefixIcon:Icon(Icons.perm_identity),
                // border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(4.0) //圆角大小
                // ),
                suffixIcon: _unameController.text.length > 0 ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 21,
                    color: Color(0xff666666),
                  ),
                  onPressed: (){
                    setState(() {
                      _unameController.text = '';
                      // checkLoginText();
                    });
                  },
                ):null
            ),
            validator: (v) {
              return !_unameExp.hasMatch(v!)?'账号由6到12位数字与小写字母组成':null;
            },
            onEditingComplete: ()=>FocusScope.of(context).requestFocus(focusNode2),
            onChanged: (v){
              setState(() {
                // checkLoginText();
              });
            },
          ),
          // SizedBox(height: 15.0),
          TextFormField( //密码
            controller: _pwdController,
            focusNode: focusNode2,//关联focusNode1
            obscureText: isEye, //密码类型 内容用***显示
            maxLength: 12,
            textInputAction: TextInputAction.done, //显示'完成'
            decoration: InputDecoration(
                hintText: '请输入密码',
                // labelText: '密码',
                // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                prefixIcon:Icon(Icons.lock),
                // border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(40.0)
                // ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    size: 21,
                    color: Color(0xff666666),
                  ),
                  onPressed: (){
                    setState(() {
                      isEye = !isEye;
                    });
                  },
                )
            ),
            validator:(v){
              return !_pwdExp.hasMatch(v!)?'密码由6到12位数字与小写字母组成':null;
            },
            onChanged: (v){
              setState(() {
                // checkLoginText();
              });
            },
            onEditingComplete: (){
              ddlog("onEditingComplete");
            }, //'完成'回调
          )
        ],
      ),
    );
  }
}