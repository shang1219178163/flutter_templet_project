//
//  AutofillGroupDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/10/23 5:19 PM.
//  Copyright © 3/10/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';

class AutofillGroupDemo extends StatefulWidget {

  AutofillGroupDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _AutofillGroupDemoState createState() => _AutofillGroupDemoState();
}

class _AutofillGroupDemoState extends State<AutofillGroupDemo> {

  bool isSameAddress = true;
  final shippingAddress1 = TextEditingController();
  final shippingAddress2 = TextEditingController();
  final billingAddress1 = TextEditingController();
  final billingAddress2 = TextEditingController();

  final creditCardNumber = TextEditingController();
  final creditCardSecurityCode = TextEditingController();

  final phoneNumber = TextEditingController();

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
          onPressed: onPressed,)
        ).toList(),
      ),
      body: buildListView(),
    );
  }

  onPressed(){
    final str = "streetAddressLine2";
    final reg = RegExp('[A-Z]');
    final matchs = reg.allMatches(str);
    for (final Match m in matchs) {
      String match = m[0]!;
      print(match);
    }
    final seperators = matchs.map((e) => e[0] ?? "").toList();
    print("seperators: ${seperators}");

    var str1 = "streetAddressLine2";
    seperators.forEach((e) => str1 = str1.replaceAll(e, "_$e") );
    print("str1: ${str1}");

    final original = 'Hello World';
    final find = 'World';
    final replaceWith = 'Home';
    final newString = original.replaceAll(find, replaceWith);
    print("newString: ${newString}");

    final result = str.seperatorByChars(cb: (String e) => " $e");
    print("result: ${result}");
  }

  Widget buildListView() {
    return ListView(
      children: <Widget>[
        const Text('Shipping address'),
        AutofillGroup(
          child: Column(
            children: <Widget>[
              TextField(
                controller: shippingAddress1,
                autofillHints: const <String>[AutofillHints.streetAddressLine1],
                decoration: _buildInputDecoration(
                  textEditingController: shippingAddress1,
                  hintText: AutofillHints.streetAddressLine1.seperatorByChars(cb: (String e) => " $e")
                ),
              ),
              TextField(
                controller: shippingAddress2,
                autofillHints: const <String>[AutofillHints.streetAddressLine2],
                decoration: _buildInputDecoration(
                  textEditingController: shippingAddress2,
                  hintText: AutofillHints.streetAddressLine2.seperatorByChars(cb: (String e) => " $e")
                ),
              ),
            ],
          ),
        ),
        const Text('Billing address'),
        Checkbox(
          value: isSameAddress,
          onChanged: (bool? newValue) {
            if (newValue != null) {
              isSameAddress = newValue;
              setState(() {});
            }
          },
        ),
        if (!isSameAddress)
          AutofillGroup(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: billingAddress1,
                  autofillHints: const <String>[
                    AutofillHints.streetAddressLine1,
                  ],
                  decoration: _buildInputDecoration(
                    textEditingController: billingAddress1,
                    hintText: AutofillHints.streetAddressLine1.seperatorByChars(cb: (String e) => " $e")
                  ),
                ),
                TextField(
                  controller: billingAddress2,
                  autofillHints: const <String>[
                    AutofillHints.streetAddressLine2,
                  ],
                  decoration: _buildInputDecoration(
                    textEditingController: billingAddress2,
                    hintText: AutofillHints.streetAddressLine2.seperatorByChars(cb: (String e) => " $e")
                  ),
                ),
              ],
            ),
          ),
        const Text('Credit Card Information'),
        AutofillGroup(
          child: Column(
            children: <Widget>[
              TextField(
                controller: creditCardNumber,
                autofillHints: const <String>[AutofillHints.creditCardNumber],
                decoration: _buildInputDecoration(
                    textEditingController: creditCardNumber,
                    hintText: AutofillHints.creditCardNumber.seperatorByChars(cb: (String e) => " $e")
                ),
              ),
              TextField(
                controller: creditCardSecurityCode,
                autofillHints: const <String>[
                  AutofillHints.creditCardSecurityCode,
                ],
                decoration: _buildInputDecoration(
                    textEditingController: billingAddress2,
                    hintText: AutofillHints.creditCardSecurityCode.seperatorByChars(cb: (String e) => " $e")
                ),
              ),
            ],
          ),
        ),
        const Text('Contact Phone Number'),
        TextField(
          controller: phoneNumber,
          autofillHints: const <String>[AutofillHints.telephoneNumber],
          decoration: _buildInputDecoration(
              textEditingController: phoneNumber,
              hintText: AutofillHints.telephoneNumber.seperatorByChars(cb: (String e) => " $e")
          ),
        ),
      ],
    );
  }

  /// 输入框修饰器
  _buildInputDecoration({
    required TextEditingController textEditingController,
    String hintText = "请输入",
    bool hasEnabledBorder = false,
    InputBorder? enabledBorder = null
  }) {
    final enabledBorderWidget = enabledBorder ?? (!hasEnabledBorder ? null : OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
          width: 1.5,
          color: Colors.lightBlue
      ),
    ));

    return InputDecoration(
      contentPadding: const EdgeInsets.all(10),
      ///设置输入文本框的提示文字
      ///输入框获取焦点时 并且没有输入文字时
      hintText: hintText,
      ///设置输入文本框的提示文字的样式
      hintStyle: TextStyle(color: Colors.grey,textBaseline: TextBaseline.ideographic,),
      ///输入文字前的小图标
      prefixIcon: Icon(Icons.search),
      ///输入文字后面的小图标
      // suffixIcon: IconButton(
      //   onPressed: () => textEditingController.clear(),
      //   icon: Icon(Icons.close, color: Colors.grey)
      // ),
      enabledBorder: enabledBorderWidget,
    );
  }

}