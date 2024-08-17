import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';

class LoginPageTwo extends StatefulWidget {
  const LoginPageTwo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageTwoState createState() => _LoginPageTwoState();
}

class _LoginPageTwoState extends State<LoginPageTwo> {
  late final _unameController = TextEditingController();
  late final _pwdController = TextEditingController();
  bool pwdShow = false; //密码是否显示明文
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  void initState() {
    // 自动填充上次登录的用户名，填充后将焦点定位到密码输入框
    // _unameController.text = Global.profile.lastLogin;
    _unameController.text = "Global.profile.lastLogin";
    if (_unameController.text != null) {
      _nameAutoFocus = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildInputBox(),
    );
  }

  Widget buildInputBox() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              autofocus: _nameAutoFocus,
              controller: _unameController,
              decoration: InputDecoration(
                labelText: "userName",
                hintText: "userNameOrEmail",
                prefixIcon: Icon(Icons.person),
              ),
              // 校验用户名（不能为空）
              // validator: (v) {
              //   return v!.trim().isNotEmpty;
              // }
            ),
            TextFormField(
              controller: _pwdController,
              autofocus: !_nameAutoFocus,
              decoration: InputDecoration(
                  labelText: "password",
                  hintText: "password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon:
                        Icon(pwdShow ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        pwdShow = !pwdShow;
                      });
                    },
                  )),
              obscureText: !pwdShow,
              //校验密码（不能为空）
              // validator: (v) {
              //   return v!.trim().isNotEmpty ? null : gm.passwordRequired;
              // },
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 25),
            //   child: ConstrainedBox(
            //     constraints: BoxConstraints.expand(height: 55.0),
            //     child: RaisedButton(
            //       color: Theme.of(context).primaryColor,
            //       onPressed: _onLogin,
            //       textColor: Colors.white,
            //       child: Text(gm.login),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // void _onLogin() async {
  //   // 提交前，先验证各个表单字段是否合法
  //   if ((_formKey.currentState as FormState).validate()) {
  //     showLoading(context);
  //     User user;
  //     try {
  //       user = await Git(context).login(_unameController.text, _pwdController.text);
  //       // 因为登录页返回后，首页会build，所以我们传false，更新user后不触发更新
  //       Provider.of<UserModel>(context, listen: false).user = user;
  //     } catch (e) {
  //       //登录失败则提示
  //       if (e.response?.statusCode == 401) {
  //         showToast(GmLocalizations.of(context).userNameOrPasswordWrong);
  //       } else {
  //         showToast(e.toString());
  //       }
  //     } finally {
  //       // 隐藏loading框
  //       Navigator.of(context).pop();
  //     }
  //     if (user != null) {
  //       // 返回
  //       Navigator.of(context).pop();
  //     }
  //   }
  // }
}
