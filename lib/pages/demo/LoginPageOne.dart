import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_account_sheet.dart';
import 'package:flutter_templet_project/basicWidget/n_account_sheet_new.dart';
import 'package:flutter_templet_project/basicWidget/n_origin_sheet.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/network/RequestConfig.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class LoginPageOne extends StatefulWidget {
  const LoginPageOne({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageOneState createState() => _LoginPageOneState();
}

class _LoginPageOneState extends State<LoginPageOne> {
  // 控制器
  final accountController = TextEditingController();
  final pwdController = TextEditingController();

  // final accountExp = RegExp(r'^(?![0-9]+$)(?![a-z]+$)[0-9a-z]{6,12}$');
  final accountExp = RegExp(r'^\d{6,12}$');
  final pwdExp = RegExp(r'^(?![0-9]+$)(?![a-z]+$)[0-9a-z]{6,12}$');

  // 焦点
  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool isEye = true;
  final isBtnEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    initData();
  }

  initData() {
    final phone = IntExt.random(max: 200000000, min: 100000000);
    final pwd = IntExt.random(max: 200000, min: 100000);
    final result = "${1.generateChars()}${pwd}";
    accountController.text = "$phone";
    pwdController.text = result;
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text('登录', style: TextStyle(color: Colors.white)),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    var childrens = <Widget>[];
    final _main = Center(
      child: ListView(
        padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0),
        children: [
          Hero(
            tag: 'avatar',
            child: InkWell(
              onTap: () {
                initData();
              },
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 50.0,
                child: Image.asset('avatar.png'.toPath()),
              ),
            ),
          ),
          NOriginSheet(),
          // NAccountSheet(
          //   items: [
          //     "18729742696",
          //     "18766668888",
          //   ],
          //   selectedItem: accountController.text,
          //   onChanged: (String value) {
          //     accountController.text = value;
          //     // setState(() {});
          //   },
          //   selecetdCb: (String e) {
          //     return e.isEmpty ? "请选择账号" : e;
          //   },
          //   titleCb: (String e) {
          //     return e;
          //   },
          // ),
          buildAccountSheet(),
          SizedBox(height: 30),
          buildInputBox(),
          SizedBox(height: 25),
          ValueListenableBuilder(
              valueListenable: isBtnEnabled,
              builder: (context, enabled, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  onPressed: !enabled ? null : onLogin,
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text('登录',
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.white))),
                );
              }),
          TextButton(
            onPressed: () {
              // Navigator.pushNamed(context, 'forget');
              Get.toNamed(APPRouter.forgetPasswordPage, arguments: "forget");
            },
            child: Text('忘记密码?',
                style: TextStyle(color: Colors.black54, fontSize: 15.0)),
          ),
          // buildOriginSheet(),
        ],
      ),
    );

    childrens.add(_main);
    // if(this.showLoading){
    //   childrens.add(Loadding());
    // }
    return Stack(children: childrens);
  }

  Widget buildInputBox() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          TextFormField(
            //用户名
            controller: accountController,
            focusNode: focusNode1, //关联focusNode1
            keyboardType: TextInputType.text, //键盘类型
            maxLength: 12,
            textInputAction: TextInputAction.next, //显示'下一步'
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                isCollapsed: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                hintText: '请输入账号',
                // labelText: "账号",
                // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                prefixIcon: Icon(Icons.perm_identity),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0) //圆角大小
                    ),
                suffixIcon: accountController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: 21,
                          color: Color(0xff666666),
                        ),
                        onPressed: () {
                          setState(() {
                            accountController.text = '';
                            checkLogin();
                          });
                        },
                      )
                    : null),
            validator: (v) {
              return !accountExp.hasMatch(v!) ? '账号由6到12位数字与小写字母组成' : null;
            },
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(focusNode2),
            onChanged: (v) {
              checkLogin();
              setState(() {});
            },
          ),
          // SizedBox(height: 15.0),
          TextFormField(
            //密码
            controller: pwdController,
            focusNode: focusNode2, //关联focusNode1
            obscureText: isEye, //密码类型 内容用***显示
            maxLength: 12,
            textInputAction: TextInputAction.done, //显示'完成'
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                isCollapsed: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    size: 21,
                  ),
                  onPressed: () {
                    setState(() {
                      isEye = !isEye;
                    });
                  },
                )),
            validator: (v) {
              return !pwdExp.hasMatch(v!) ? '密码由6到12位数字与小写字母组成' : null;
            },
            onChanged: (v) {
              checkLogin();
              setState(() {});
            },
            onEditingComplete: onLogin, //'完成'回调
          )
        ],
      ),
    );
  }

  // 异步操作
  Future loginRequest() async {
    return Future.delayed(Duration(seconds: 3), () {
      debugPrint('login success');
    });
  }

  // 登录按钮是否可点击
  void checkLogin() {
    if (accountExp.hasMatch(accountController.text) &&
        pwdExp.hasMatch(pwdController.text)) {
      isBtnEnabled.value = true;
    } else {
      isBtnEnabled.value = false;
    }
  }

  // 登录提交
  Future<void> onLogin() async {
    FocusScope.of(context).requestFocus(FocusNode());

    ToastUtil.loading("请求中...");
    await Future.delayed(Duration(milliseconds: 300), () {});
    ToastUtil.hideLoading();

    // Get.toNamed(APPRouter.appTabPage)

    accountSheetController.addAccount(
      account: accountController.text.trim(),
      pwd: pwdController.text.trim(),
    );
    setState(() {});
  }

  final accountSheetController = NAccountSheetController();

  Widget buildAccountSheet() {
    return NAccountSheet(
      controller: accountSheetController,
      items: [],
      onChanged: (e) {
        accountController.text = e.key;
        pwdController.text = e.value;
      },
      // titleCb: (e) {
      //   return e.key;
      // },
    );
  }
}
