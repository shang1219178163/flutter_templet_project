//
//  AutofillGroupDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/10/23 5:19 PM.
//  Copyright © 3/10/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class AutofillGroupDemo extends StatefulWidget {
  const AutofillGroupDemo({Key? key, this.title}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: onPressed,
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: buildListView(),
    );
  }

  onPressed() {
    const str = "streetAddressLine2";
    final result =
        str.splitMapJoin(RegExp('[A-Z]'), onMatch: (m) => " ${m[0]}");
    debugPrint("result: $result");
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
                  hintText: AutofillHints.streetAddressLine1.splitMapJoin(
                      RegExp('[A-Z]'),
                      onMatch: (m) => " ${m[0]}"),
                ),
              ),
              TextField(
                controller: shippingAddress2,
                autofillHints: const <String>[AutofillHints.streetAddressLine2],
                decoration: _buildInputDecoration(
                  textEditingController: shippingAddress2,
                  hintText: AutofillHints.streetAddressLine2.splitMapJoin(
                      RegExp('[A-Z]'),
                      onMatch: (m) => " ${m[0]}"),
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
                    hintText: AutofillHints.streetAddressLine1.splitMapJoin(
                        RegExp('[A-Z]'),
                        onMatch: (m) => " ${m[0]}"),
                  ),
                ),
                TextField(
                  controller: billingAddress2,
                  autofillHints: const <String>[
                    AutofillHints.streetAddressLine2,
                  ],
                  decoration: _buildInputDecoration(
                    textEditingController: billingAddress2,
                    hintText: AutofillHints.streetAddressLine2.splitMapJoin(
                        RegExp('[A-Z]'),
                        onMatch: (m) => " ${m[0]}"),
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
                    hintText: AutofillHints.creditCardNumber.splitMapJoin(
                        RegExp('[A-Z]'),
                        onMatch: (m) => " ${m[0]}")),
              ),
              TextField(
                controller: creditCardSecurityCode,
                autofillHints: const <String>[
                  AutofillHints.creditCardSecurityCode,
                ],
                decoration: _buildInputDecoration(
                    textEditingController: billingAddress2,
                    hintText: AutofillHints.creditCardSecurityCode.splitMapJoin(
                        RegExp('[A-Z]'),
                        onMatch: (m) => " ${m[0]}")),
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
            hintText: AutofillHints.telephoneNumber
                .splitMapJoin(RegExp('[A-Z]'), onMatch: (m) => " ${m[0]}"),
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
    InputBorder? enabledBorder,
  }) {
    final enabledBorderWidget = enabledBorder ??
        (!hasEnabledBorder
            ? null
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    const BorderSide(width: 1.5, color: Colors.lightBlue),
              ));

    return InputDecoration(
      contentPadding: const EdgeInsets.all(10),

      ///设置输入文本框的提示文字
      ///输入框获取焦点时 并且没有输入文字时
      hintText: hintText,

      ///设置输入文本框的提示文字的样式
      hintStyle: TextStyle(
        color: Colors.grey,
        textBaseline: TextBaseline.ideographic,
      ),

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
