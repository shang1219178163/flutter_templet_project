//
//  TestFunction.dart
//  flutter_templet_project
//
//  Created by shang on 3/28/23 9:49 AM.
//  Copyright © 3/28/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/function_ext.dart';

class TestFunction extends StatefulWidget {

  const TestFunction({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _TestFunctionState createState() => _TestFunctionState();
}

class _TestFunctionState extends State<TestFunction> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: onPressed,
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: Text(arguments.toString())
    );
  }

  fc(int n, int m, {operation = "add"}) {
    if (operation == "add") {
      return n + m;
    }
    return n - m;
  }

  fcOne(int vintage, {String? country, String? name}) {
    debugPrint('Name: $name, Country: $country, Vintage: $vintage');
  }

  onPressed() {
    int a = Function.apply(fc, [10, 3]);
    debugPrint("a: $a");//a: 13
    int b = Function.apply(fc, [10, 3], {Symbol("operation"): "subtract"});
    debugPrint("b: $b");//b: 7

    Function.apply(fcOne, [2018], {#country: 'USA', #name: 'Dominus Estate'});
    final map = {
      "country": 'USA',
      "name": 'Dominus Estate'
    };
    final mapNew = {
      "country": 'USA1',
      "name": 'Dominus Estate1'
    }.mapSymbolKey();

    Function.apply(fcOne, [2018], mapNew);
    FunctionExt.apply(fcOne, [2019], map);
  }
}

extension MapExt on Map{
  Map<Symbol, dynamic> mapSymbolKey() {
    return map((key, value) => MapEntry(Symbol("$key"), value));
  }
}
