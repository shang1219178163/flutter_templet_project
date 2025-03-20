//
//  TestFunction.dart
//  flutter_templet_project
//
//  Created by shang on 3/28/23 9:49 AM.
//  Copyright © 3/28/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield_search.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/function_ext.dart';
import 'package:flutter_templet_project/extension/future_ext.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/util/Debounce.dart';

class TestFunction extends StatefulWidget {
  const TestFunction({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TestFunctionState createState() => _TestFunctionState();
}

class _TestFunctionState extends State<TestFunction> {
  late final items = <({String name, VoidCallback action})>[
    (name: "apply", action: onApply),
    (name: "防抖", action: onDebounce),
    (name: "防抖1", action: onDebounceOne),
    (name: "函数执行时长", action: onExecution),
  ];

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
      body: buildBody(),
    );
  }

  buildBody() {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              runSpacing: 8,
              children: [
                ...items.map((e) {
                  return TextButton(onPressed: e.action, child: NText(e.name));
                }).toList(),
                OutlinedButton(
                  onPressed: testVoidCallback.debounce,
                  child: NText("testVoidCallback.debounce"),
                ),
                OutlinedButton(
                  onPressed: testVoidCallback.auth(onAuth: () {
                    return false;
                  }, onUnauth: () {
                    DLog.d("OutlinedButton - onUnauth");
                  }),
                  child: NText("testVoidCallback.auth"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: NSearchTextField(
                backgroundColor: Colors.black12,
                onChanged: (val) => onChanged.debounce(val),
              ),
            )
          ],
        ),
      ),
    );
  }

  onPressed() {
    final func = closure();
    debugPrint("b: ${func()}");
    debugPrint("b: ${func()}");

    final funcOne = repeat(onChanged: (val) {
      debugPrint("onChanged: ${val}");
    });

    funcOne();
    funcOne();
    funcOne();
    funcOne();
    funcOne();
    funcOne();
  }

  fc(int n, int m, {operation = "add"}) {
    if (operation == "add") {
      return n + m;
    }
    return n - m;
  }

  fcOne(int year, {String? country, String? city}) {
    debugPrint('city: $city, Country: $country, year: $year');
  }

  onApply() {
    int a = Function.apply(fc, [10, 3]);
    debugPrint("a: $a"); //a: 13
    int b = Function.apply(fc, [10, 3], {Symbol("operation"): "subtract"});
    debugPrint("b: $b"); //b: 7

    Function.apply(fcOne, [2018], {#country: 'USA', #city: 'Dominus Estate'});
    final map = {"country": 'USA', "city": 'Dominus Estate'};
    final mapNew = {"country": 'USA1', "city": 'Dominus Estate1'}.mapSymbolKey();

    Function.apply(fcOne, [2018], mapNew);
    FunctionExt.apply(fcOne, [2019], map);

    fcOne.applyNew(
      positionalArguments: [
        2024,
      ],
      namedArguments: {"country": 'China', "city": 'HongKong'},
    );
  }

  Function closure() {
    var i = 0;
    return () {
      return ++i;
    };
  }

  Function repeat({int time = 3, required ValueChanged<int> onChanged}) {
    var i = 0;
    return () {
      if (i > time - 1) {
        return i;
      }
      onChanged.call(i);
      ++i;
      return i;
    };
  }

  void onDebounce() {
    testVoidCallback.debounce();
    // testFuntion.debounce(namedArguments: {"name": "testFuntion1"});
  }

  void onDebounceOne() {
    testVoidCallbackOne.debounce();
  }

  Future<void> onExecution() async {
    await tes().codeExecution();
  }

  Future<void> tes() async {
    await Future.delayed(Duration(milliseconds: 1234));
  }

  void onChanged(val) {
    final index = IntExt.random(max: 1000);
    DLog.d("onChanged: $val, index: $index");
  }

  void testFuntion({
    required String name,
  }) {
    final index = IntExt.random(max: 1000);
    DLog.d("name: $name, index: $index");
  }

  void testVoidCallback() {
    final index = IntExt.random(max: 1000);
    DLog.d("testVoidCallback index: $index");

    final isEqual = Symbol("city") == #city;
    DLog.d("testVoidCallback isEqual: $isEqual");
    // [log] 2024-04-21 12:33:04.265310 testVoidCallback isEqual: true
  }

  void testVoidCallbackOne() {
    // final index = IntExt.random(max: 1000);
    // DLog.d("testVoidCallbackOne index: $index");
    //
    // final isEqual = Symbol("city") == #city;
    // DLog.d("testVoidCallbackOne isEqual: $isEqual");
    // [log] 2024-04-21 12:33:04.265310 testVoidCallback isEqual: true

    // fn1();
    // fn2();

    fn1.debounce(
      duration: Duration(seconds: 1),
    );
    fn2.debounce(
      duration: Duration(seconds: 1),
    );
  }

  void fn1() {
    final index = IntExt.random(max: 1000);
    DLog.d("fn1 index: $index");
  }

  void fn2() {
    final index = IntExt.random(max: 1000);
    DLog.d("fn2 index: $index");
  }
}

extension MapExt on Map {
  Map<Symbol, dynamic> mapSymbolKey() {
    return map((key, value) => MapEntry(Symbol("$key"), value));
  }
}
