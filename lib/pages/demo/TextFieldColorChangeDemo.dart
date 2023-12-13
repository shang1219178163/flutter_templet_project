

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
          margin: EdgeInsets.only(top: 25, left: 30, right: 30, bottom: 27),
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
              SizedBox(height: 16,),
              LoginInput(
                textfieldKey: pwdGlobalKey,
                image: 'icon_lock.png'.toPath(),
                hint: '请输入密码',
                obscureText: true,
                isPwd: true,
                showEyeIcon: true,
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
    this.controller,
    this.image,
    this.hint = "请输入",
    this.value,
    this.onChanged,
    this.focusChanged,
    this.lineStretch = false,
    this.obscureText = false,
    this.isPwd = false,
    this.isFocusClear = false,
    this.showEyeIcon = false,
    this.keyboardType,
    this.fillColor = bgColor,
    this.focusColor = Colors.white,
    this.radius = 30,
    this.suffixIcon,
    this.suffix,
  }) : super(key: key);

  final Key? textfieldKey;
  final TextEditingController? controller;

  final String? value;
  final String? image;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? focusChanged;
  final bool lineStretch;
  final bool obscureText;
  final bool isPwd;
  final bool isFocusClear;
  final bool showEyeIcon;
  final TextInputType? keyboardType;

  final Color? fillColor;
  final Color? focusColor;
  final double radius;

  final Widget? suffixIcon;
  final Widget? suffix;


  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();
  // final _focusNodePwd = FocusNode();

  final hasFocusVN = ValueNotifier<bool>(false);

  bool isCloseEye = true;

  late final _textEditingController = widget.controller ?? TextEditingController();

  @override
  void initState() {
    super.initState();

    _textEditingController.value = TextEditingValue(
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
    hasFocusVN.value = _focusNode.hasFocus;
    if (hasFocusVN.value && widget.isPwd && widget.isFocusClear) {
      _textEditingController.clear();
      widget.onChanged?.call("");
    }
    // debugPrint("hasFocusVN: ${hasFocusVN.value}");
    // if (hasFocusVN.value) {
    //   FocusScope.of(context).requestFocus(_focusNode);
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPwd) {
      return _passwordInput(textfieldKey: widget.textfieldKey);
    }
    return _input(textfieldKey: widget.textfieldKey);
  }

  _input({Key? textfieldKey}) {
    return TextField(
      autofocus: true,
      // key: textfieldKey,
      cursorColor: primaryColor,
      focusNode: _focusNode,
      controller: _textEditingController,
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
            color: primaryColor,
          ),
          onPressed: () {
            isCloseEye = !isCloseEye;
            setState(() {});
          },
        ),
        suffix: widget.suffix ?? buildClearButton(),
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
    );
  }

  _passwordInput({Key? textfieldKey}) {
    Widget? suffixIconTmp;
    if (widget.showEyeIcon) {
      suffixIconTmp = widget.suffixIcon ?? ValueListenableBuilder<bool>(
          valueListenable: hasFocusVN,
          builder: (_, isFocus, child) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                focusColor: fontColor[10],
                icon: Image.asset(
                  isCloseEye
                      ? 'assets/images/icon_eye_close.png'
                      : 'assets/images/icon_eye_open.png',
                  width: 20,
                  height: 20,
                  color: isFocus ? primaryColor : null,
                ),
                onPressed: () {
                  isCloseEye = !isCloseEye;
                  setState(() {});
                },
              ),
            );
          });
    }

    return TextField(
      key: textfieldKey,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      obscureText: isCloseEye,
      keyboardType: TextInputType.visiblePassword,
      autofocus: !isCloseEye,
      cursorColor: primaryColor,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: fontColor,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
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
            color: primaryColor,
          ),
          onPressed: () {

          },
        ),
        suffixIcon: suffixIconTmp,
        suffix: widget.suffix ?? buildClearButton(),
      ),
    );
  }

  buildInput({
    Key? textfieldKey,
    bool isFocus = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      // key: textfieldKey,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      // keyboardType: TextInputType.visiblePassword,
      keyboardType: keyboardType,
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
            isCloseEye
                ? 'icon_eye_close.png'.toPath()
                : 'icon_eye_open.png'.toPath(),
            width: 20,
            height: 20,
            color: isFocus ? primaryColor : null,
          ),
          onPressed: () {
            isCloseEye = !isCloseEye;
            setState(() {});
          },
        ) : SizedBox()),
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

  /// 清除按钮
  Widget buildClearButton() {
    return ValueListenableBuilder(
        valueListenable: hasFocusVN,
        builder: (context, value, child){
          if (!value) {
            return SizedBox();
          }
          return InkWell(
            onTap: (){
              _textEditingController.clear();
              widget.onChanged?.call("");
            },
            child: Container(
              padding: const EdgeInsets.only(
                left: 8.0,
                top: 4,
              ),
              child: Icon(Icons.cancel,
                color: Colors.black.withOpacity(0.3),
                size: 16,
              ),
            ),
          );
        }
    );
  }
}
