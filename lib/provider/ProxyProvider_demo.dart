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
import 'package:flutter_templet_project/provider/provider_demo.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ProxyProviderDemo extends StatelessWidget {
  const ProxyProviderDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ProxyProvider"),
      ),
      body: Column(
        children: [
          _buildConsumer(),
          Divider(),
          _buildSelector(),
        ],
      )
    );
  }
  
  _buildConsumer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Consumer<EatModel>(builder: (ctx, model, child) => Text(model.whoEat)),
        Consumer<Person>( // 拿到person对象，调用方法
          builder: (ctx, model, child){
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
              Text("其他更多组件"),
              Text("其他更多组件"),
              Text("其他更多组件"),
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
          builder: (ctx, model, child){
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () => model.changName(),
                  child: const Text("点击修改1"),
                ),
                child!
              ],
            );
          },
          child: Column(
            children: [
              Text("其他更多组件"),
              Text("其他更多组件"),
              Text("其他更多组件"),
            ],
          ),
        ),
      ],
    );
  }

}
