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
import 'package:flutter_templet_project/uti/Debounce.dart';
import 'package:flutter_templet_project/uti/Throttle.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';


class TextFieldDemo extends StatefulWidget {

  final String? title;

  const TextFieldDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _TextFieldDemoState createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {

  late final _textController = TextEditingController(text: 'initial text');
  late final editingController = TextEditingController(text: 'initial text');

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

  final delayed = Debouncer(delay: Duration(milliseconds: 1000));
  final _debounce = Debounce(milliseconds: 1000);

  final _throttle = Throttle(milliseconds: 500);


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onPressed,
        )).toList(),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CupertinoTextField(
              controller: _textController,
              placeholder: "请输入",
              padding: EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
              suffixMode: OverlayVisibilityMode.editing,
            ),
            Spacer(),
            CupertinoSearchTextField(
              // prefixIcon: SizedBox(),
              padding: EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
              placeholder: "请输入",
              onChanged: (String value) {
                // debugPrint('onChanged: $value');
                delayed(() => debugPrint( 'delayed: $value' ));
                // _debounce(() => debugPrint( 'delayed: $value' ));
              },
              onSubmitted: (String value) {
                debugPrint('onSubmitted: $value');
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
                suffixIcon: _unameController.text.isNotEmpty ? IconButton(
                  icon: Icon(Icons.cancel, color: Colors.grey,),
                  onPressed: (){
                    _unameController.clear();
                    //   _unameController.text = '';
                    //   // checkLoginText();
                    setState(() {});
                  },
                ):null
              ),
              validator: (v) {
                return !_unameExp.hasMatch(v!)?'账号由6到12位数字与小写字母组成':null;
              },
              onEditingComplete: ()=>FocusScope.of(context).requestFocus(focusNode2),
              onChanged: (v){
                // checkLoginText();
                setState(() {});
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
                  icon: Icon(Icons.remove_red_eye,),
                  onPressed: (){
                    isEye = !isEye;
                    setState(() {});
                  },
                )
              ),
              validator:(v){
                return !_pwdExp.hasMatch(v!)?'密码由6到12位数字与小写字母组成':null;
              },
              onChanged: (v){
                // checkLoginText();
                setState(() {});
              },
              onEditingComplete: (){
                ddlog("onEditingComplete");
              }, //'完成'回调
            )
          ],
        ),
      ),
    );
  }

  onPressed(){
    _throttle(() => debugPrint("${DateTime.now()}: onPressed"));
  }
}