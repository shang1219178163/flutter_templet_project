//
//  ProxyProviderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/9/22 8:42 AM.
//  Copyright © 10/9/22 shang. All rights reserved.
//

/*
* 我们日常开发中会遇到一种模型嵌套另一种模型、或一种模型的参数用到另一种模型的值、
* 或是需要几种模型的值组合成一个新的模型的情况，在这种情况下，就可以使用 ProxyProvider 。
* 它能够将多个 provider 的值聚合为一个新对象，将结果传递给 Provider（注意是Provider而不是
* ChangeNotifierProvider），这个新对象会在其依赖的任意一个 provider 更新后同步更新值。
* */

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ProviderDemo extends StatelessWidget {
  const ProviderDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ProviderDemo"),
        ),
        // body: Text(arguments.toString())
        // body: _buildConsumer(),
        body: Column(
          children: [
            _buildConsumer(),
            Divider(),
            _buildSelector(),
            Divider(),
            _buildSelectorTuple(),
          ],
        ));
  }

  _buildConsumer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Consumer<EatModel>(builder: (ctx, model, child) => Text(model.whoEat)),
        Consumer<Person>(
          // 拿到person对象，调用方法
          builder: (ctx, model, child) {
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () => model.changName(),
                  child: const Text("点击修改"),
                ),
                child!
              ],
            );
          },
          child: Column(
            children: [
              Text("Consumer 监听 EatModel 类型"),
            ],
          ),
        ),
      ],
    );
  }

  _buildSelector() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Selector<EatModel, String>(
          selector: (ctx, person) => person.name,
          builder: (ctx, value, child) => Text(value),
        ),
        Selector<Person, Person>(
          selector: (ctx, person) => person,
          builder: (ctx, model, child) {
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () => model.changName(),
                  child: const Text("点击修改"),
                ),
                child!
              ],
            );
          },
          child: Column(
            children: [
              Text("Selector 监听 person 的 name (String)属性"),
            ],
          ),
        ),
      ],
    );
  }

  _buildSelectorTuple() {
    return Container(
      height: 100,
      child: Column(
        children: [
          Selector<Foo, Tuple2<String, String>>(
              selector: (ctx, foo) => Tuple2(foo.bar.name, foo.baz.name),
              builder: (ctx, data, child) {
                return Text('${data.item1}/${data.item2}');
              }),
          Consumer<Foo>(
            // 拿到person对象，调用方法
            builder: (ctx, model, child) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () => model.change(),
                    child: const Text("点击修改 Consumer"),
                  ),
                  child!
                ],
              );
            },
            child: Column(
              children: [
                Text(
                    "Selector 监听 Foo 的 bar.name (String) 和 foo.baz.name (String)"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Person extends ChangeNotifier {
  Person({
    this.name = "小虎牙",
    this.age = 18,
  });

  String name;
  int age;

  final String _initail = "小虎牙";
  final String _changed = "更新的小虎牙";

  void changName() {
    name = name == _initail ? _changed : _initail;
    notifyListeners();
  }

  void increaseAge() {
    age++;
    notifyListeners();
  }
}

class EatModel {
  EatModel({required this.name});

  final String name;

  String get whoEat => "$name正在吃饭";
}

class Foo with ChangeNotifier {
  int count = 0;

  Bar bar = Bar();
  Baz baz = Baz();

  // 年龄改变
  void increment() {
    count++;
    notifyListeners();
  }

  void change() {
    bar = Bar(name: IntExt.random(min: 10, max: 99).toString());
    baz = Baz(name: IntExt.random(min: 10, max: 99).toString());
    debugPrint("change ${bar.name} ${baz.name}");
    notifyListeners();
  }
}

class Bar with ChangeNotifier {
  Bar({
    this.name = "Bar",
  });

  String name;

  @override
  String toString() {
    return 'Bar';
  }
}

class Baz with ChangeNotifier {
  Baz({
    this.name = "Baz",
  });

  String name;

  @override
  String toString() {
    return 'Baz';
  }
}
