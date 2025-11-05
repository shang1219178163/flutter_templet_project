import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:tuple/tuple.dart';

class KeyboardAttachDemo extends StatefulWidget {
  KeyboardAttachDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _KeyboardAttachDemoState createState() => _KeyboardAttachDemoState();
}

class _KeyboardAttachDemoState extends State<KeyboardAttachDemo> with WidgetsBindingObserver {
  final _textController = TextEditingController();

  final isKeyboardVisibleVN = ValueNotifier(false);

  Widget get safeAreaBottom =>
      SizedBox(height: max(MediaQuery.of(context).viewInsets.bottom, MediaQuery.of(context).viewPadding.bottom));

  @override
  void onKeyboardChanged(bool visible) {
    // TODO deal with keyboard visibility change.
    debugPrint("onKeyboardChanged:${visible ? "展开键盘" : "收起键盘"}");
    // isKeyboardVisibleVN.value = visible;
    // if (isKeyboardVisibleVN.value) {
    //   onPressed();
    // } else {
    //   Navigator.of(context).pop();
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    SystemChannels.navigation.setMethodCallHandler((call) {
      debugPrint('<SystemChannels.navigation> ${call.method} (${call.arguments})');
      /*
   popRoute
   pushRoute
   */
      return Future<dynamic>.value();
    });
    SemanticsService.announce('Hello world', TextDirection.ltr);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/images/bg.png"),
            //   fit: BoxFit.fill,
            // ),
            ),
        child: ListView(
          children: List.generate(20, (i) {
            return ListTile(
              title: NText("item_$i"),
            );
          }).toList(),
        ),
      ),
      Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 0,
        right: 0,
        child: textfieldBar(),
      ),
    ]);
  }

  //键盘推起界面
  Widget buildBody2() {
    return Container(
      // color: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              // color: Colors.yellow,
              child: NText(
                _textController.text,
                maxLines: 100,
              ),
            ),
          ),
          textfieldBar(),
          safeAreaBottom,
        ],
      ),
    );
  }

  Widget buildTextfield({
    hintText = "hintText",
    maxLines = 1,
    TextEditingController? controller,
    FocusNode? focusNode,
    double? fontSize = 15,
  }) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12),
        hintText: hintText,
        hintStyle: TextStyle(
          color: const Color(0xff999999),
          fontSize: fontSize,
          fontWeight: FontWeight.w300,
        ),
        fillColor: AppColor.bgColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        counterText: '',
      ),
      onChanged: (val) async {
        // debugPrint("onChanged: $val");
      },
      onSubmitted: (val) {
        debugPrint("onSubmitted: $val");
      },
      onEditingComplete: () {
        debugPrint("onEditingComplete: ");
      },
      // onTap: (){
      //   debugPrint("onTap: ${controller?.value.text}");
      // },
      // onTapOutside: (e){
      //   debugPrint("onTapOutside: $e ${controller?.value.text}");
      // },
    );
  }

  Widget textfieldBar() {
    return Container(
      // height: 70,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12,
      ),
      color: Colors.green,
      child: Row(
        children: [
          Expanded(
            child: buildTextfield(
              controller: _textController,
              maxLines: null,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: StadiumBorder(),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size(64, 32),
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
            child: Text("发送"),
          )
        ],
      ),
    );
  }

  onPressed() {
    showSheet();
  }

  final items = <Tuple2<int, String>>[
    Tuple2(0, "选项一"),
    Tuple2(1, "选项二"),
    Tuple2(2, "选项三"),
  ];

  Object? selectedIndex = 0;

  showSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // !important
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          // height: viewInsets.bottom,
          color: Colors.white,
          child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...items.map((e) {
                  return ColoredBox(
                    color: ColorExt.random,
                    child: Material(
                      child: RadioListTile(
                        tileColor: Colors.red,
                        title: Text(e.item2),
                        value: e.item1,
                        groupValue: selectedIndex,
                        onChanged: (val) {
                          selectedIndex = val;
                          debugPrint("selectedIndex:$selectedIndex");
                          setState(() {});
                        },
                      ),
                    ),
                  );
                }).toList(),
                ColoredBox(
                  color: ColorExt.random,
                  child: Material(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                          tileColor: Colors.red,
                          title: Text("其他"),
                          groupValue: selectedIndex,
                          value: items.length,
                          onChanged: (val) {
                            selectedIndex = val;
                            debugPrint("selectedIndex:$selectedIndex");
                            setState(() {});
                          },
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 70,
                            ),
                            Expanded(
                                child: buildTextfield(
                              maxLines: 3,
                            )),
                          ],
                        ),
                        safeAreaBottom,
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
        );
      },
    );
  }
}
