

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

final accountGlobalKey = GlobalKey(debugLabel: "accountGlobalKey");

final pwdGlobalKey = GlobalKey(debugLabel: "pwdGlobalKey");


class TextFieldColorChangeDemo extends StatefulWidget {

  TextFieldColorChangeDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _TextFieldColorChangeDemoState createState() => _TextFieldColorChangeDemoState();
}

class _TextFieldColorChangeDemoState extends State<TextFieldColorChangeDemo> {
    late final FocusNode _focusNode = FocusNode();

    String loginId = "";
    String password = "";


    @override
    void dispose() {
      super.dispose();
      _focusNode.dispose();
    }

    @override
    void initState() {
      super.initState();
      _focusNode.addListener(_onOnFocusNodeEvent);
    }

    _onOnFocusNodeEvent() {
      setState(() {});
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Changing Colors'),
        ),
        body: Container(
            padding: EdgeInsets.all(40.0),
            child: Column(
              children: [
                buildLoginBox(),
              ],
            )
        ),
      );
    }
    /// 登录盒子
    buildLoginBox() {
      return Center(
        // heightFactor: 1.9,
        child: Container(
          margin: EdgeInsets.only(top: 25.w, left: 30, right: 30, bottom: 27),
          child: Column(
            children: [
              LoginInput(
                textfieldKey: accountGlobalKey,
                image: 'icon_account.png'.toPath(),
                hint: '请输入手机号/账号',
                // keyboardType: TextInputType.number,
                value: loginId,
                onChanged: (text) {
                  loginId = text;
                },
              ),
              LoginInput(
                textfieldKey: pwdGlobalKey,
                image: 'icon_lock.png'.toPath(),
                hint: '请输入密码',
                obscureText: true,
                isPwd: true,
                value: password,
                onChanged: (text) {
                  password = text;
                },
              ),
            ],
          ),
        ),
      );
    }
  }


///登录输入框，自定义widget
class LoginInput extends StatefulWidget {


  const LoginInput({
    Key? key,
    this.textfieldKey,
    this.image,
    this.hint = "请输入",
    this.value,
    this.onChanged,
    this.focusChanged,
    this.lineStretch = false,
    this.obscureText = false,
    this.isPwd = false,
    this.isIcon = false,
    this.keyboardType,
    this.fillColor = bgColor,
    this.focusColor = Colors.white,
    this.radius = 30,
  }) : super(key: key);

  final Key? textfieldKey;
  final String? value;
  final String? image;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? focusChanged;
  final bool lineStretch;
  final bool obscureText;
  final bool isPwd;
  final TextInputType? keyboardType;
  final bool isIcon;

  final Color? fillColor;
  final Color? focusColor;
  final double radius;


  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();
  final _focusNodePwd = FocusNode();

  final hasFocusVN = ValueNotifier<bool>(false);

  bool isEyeClose = true;

  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    textEditingController.value = TextEditingValue(
        text: widget.value ?? "",
        selection: TextSelection.fromPosition(
            TextPosition(
                affinity: TextAffinity.downstream,
                offset: (widget.value ?? "").length
            )
        )
    );

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();

    super.dispose();
  }

  void _onFocusChange() {
    // hasFocusVN.value = _focusNode.hasFocus;
    // debugPrint("hasFocusVN: ${hasFocusVN.value}");
    // if (hasFocusVN.value) {
    //   FocusScope.of(context).requestFocus(_focusNode);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 18,),
          child: Row(
            children: [
              widget.isPwd ? _passwordInput(textfieldKey: widget.textfieldKey) :
              _input(textfieldKey: widget.textfieldKey),
              buildInput(),
            ],
          ),
        ),
      ],
    );
  }

  _input({Key? textfieldKey}) {
    return Expanded(
      child: ValueListenableBuilder<bool>(
          valueListenable: hasFocusVN,
          builder: (_, isFocus, child) {

            return Container(
              decoration: isFocus == false ? null : buidBoxDecoration(),
              child: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.redAccent,
                ),
                child: TextField(
                  autofocus: true,
                  // key: textfieldKey,
                  cursorColor: primaryColor,
                  focusNode: _focusNode,
                  controller: textEditingController,
                  // focusNode: focusChanged,
                  onChanged: widget.onChanged,
                  // obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  // autofocus: !widget.obscureText,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: fontColor,
                  ),
                  decoration: InputDecoration(
                    // focusColor: Colors.blue,
                    filled: true,
                    // fillColor: isFocus ? widget.focusColor : widget.fillColor,
                    fillColor: widget.focusColor,
                    contentPadding: const EdgeInsets.only(left: 20, right: 20),
                    border: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: TextStyle(fontSize: 16.sp, color: fontColor[10]),
                    prefixIcon: IconButton(
                      focusColor: primaryColor,
                      icon: widget.image == null ? SizedBox() : Image.asset(
                        widget.image!,
                        width: 20,
                        height: 20,
                        color: isFocus ? primaryColor : null,
                      ),
                      onPressed: () {
                        setState(() {
                          isEyeClose = !isEyeClose;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      /*边角*/
                      borderRadius: BorderRadius.all(
                        Radius.circular(widget.radius), //边角
                      ),
                      borderSide: BorderSide(
                        color: lineColor, //边线颜色为白色
                        width: 1, //边线宽度为1
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryColor, //边框颜色为白色
                        width: 1, //宽度为1
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(widget.radius), //边角
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  _passwordInput({Key? textfieldKey}) {
    return Expanded(
      child: ValueListenableBuilder<bool>(
          valueListenable: hasFocusVN,
          builder: (_, isFocus, child){

            return Container(
              decoration: isFocus == false ? null : buidBoxDecoration(),
              child: TextField(
                // key: textfieldKey,
                focusNode: _focusNodePwd,
                onChanged: widget.onChanged,
                obscureText: isEyeClose,
                keyboardType: TextInputType.visiblePassword,
                autofocus: !isEyeClose,
                cursorColor: primaryColor,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: fontColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _focusNode.hasFocus ? Colors.red : Colors.green,
                  // fillColor:  widget.focusColor,
                  contentPadding: const EdgeInsets.only(left: 20, right: 20),
                  border: InputBorder.none,
                  enabledBorder: const OutlineInputBorder(
                    /*边角*/
                    borderRadius: BorderRadius.all(
                      Radius.circular(30), //边角
                    ),
                    borderSide: BorderSide(
                      color: lineColor, //边线颜色为白色
                      width: 1, //边线宽度为1
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor, //边框颜色为白色
                      width: 1, //宽度为1
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30), //边角
                    ),
                  ),
                  hintText: widget.hint,
                  hintStyle: TextStyle(fontSize: 16.sp, color: fontColor[10]),
                  prefixIcon: IconButton(
                    focusColor: primaryColor,
                    icon: widget.image == null ? SizedBox() : Image.asset(
                      widget.image!,
                      width: 20,
                      height: 20,
                      color: isFocus ? primaryColor : null,
                    ),
                    onPressed: () {
                      setState(() {
                        isEyeClose = !isEyeClose;
                      });
                    },
                  ),
                  suffixIcon: IconButton(
                    focusColor: fontColor[10],
                    icon: Image.asset(
                      isEyeClose
                          ? 'icon_eye_close.png'.toPath()
                          : 'icon_eye_open.png'.toPath(),
                      width: 20,
                      height: 20,
                      color: isFocus ? primaryColor : null,
                    ),
                    onPressed: () {
                      setState(() {
                        isEyeClose = !isEyeClose;
                      });
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }

  buildInput({
    Key? textfieldKey,
    bool isFocus = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: isFocus == false ? null : buidBoxDecoration(),
      child: TextField(
        // key: textfieldKey,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        obscureText: isEyeClose,
        // keyboardType: TextInputType.visiblePassword,
        keyboardType: keyboardType,
        autofocus: !isEyeClose,
        cursorColor: primaryColor,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: fontColor,
        ),
        decoration: InputDecoration(
          filled: true,
          // fillColor: isFocus ? widget.focusColor : widget.fillColor,
          fillColor: widget.focusColor,
          contentPadding: const EdgeInsets.only(left: 20, right: 20),
          border: InputBorder.none,
          enabledBorder: const OutlineInputBorder(
            /*边角*/
            borderRadius: BorderRadius.all(
              Radius.circular(30), //边角
            ),
            borderSide: BorderSide(
              color: lineColor, //边线颜色为白色
              width: 1, //边线宽度为1
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor, //边框颜色为白色
              width: 1, //宽度为1
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(30), //边角
            ),
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(fontSize: 16.sp, color: fontColor[10]),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon ?? (keyboardType == TextInputType.visiblePassword ? IconButton(
            focusColor: fontColor[10],
            icon: Image.asset(
              isEyeClose
                  ? 'icon_eye_close.png'.toPath()
                  : 'icon_eye_open.png'.toPath(),
              width: 20,
              height: 20,
              color: isFocus ? primaryColor : null,
            ),
            onPressed: () {
              isEyeClose = !isEyeClose;
              setState(() {});
            },
          ) : SizedBox()),
        ),
      ),
    );
  }

  BoxDecoration buidBoxDecoration() {
    return BoxDecoration(
      // color: Colors.white,
      borderRadius: BorderRadius.circular(widget.radius),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 4.w),
          blurRadius: 12.w,
          color: primaryColor.withOpacity(0.1),
        ),
      ],
    );
  }
}
