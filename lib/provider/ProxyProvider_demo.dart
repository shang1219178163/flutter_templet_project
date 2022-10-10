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
import 'package:provider/provider.dart';

class ProxyProviderDemo extends StatelessWidget {
  const ProxyProviderDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ProxyProvider"),
      ),
      // body: Text(arguments.toString())
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Consumer<EatModel>(builder: (ctx,eatModel,child) => Text(eatModel.whoEat)),
            Consumer<Person>( // 拿到person对象，调用方法
              builder: (ctx,person,child){
                return ElevatedButton( /// 点击按钮更新Person的name，eatModel.whoEat会同步更新
                  onPressed: () => person.changName(),
                  child: const Text("点击修改"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class Person extends ChangeNotifier{
  String _initail = "小虎牙";
  String _changed = "更新的小虎牙";

  String name = "小虎牙";

  void changName(){
    name = name == _initail ? _changed : _initail;
    notifyListeners();
  }
}

class EatModel{
  EatModel({required this.name});

  final String name;

  String get whoEat => "$name正在吃饭";
}
