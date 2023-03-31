//
//  AfterLayoutDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/2/21 6:39 PM.
//  Copyright © 12/2/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class AfterLayoutDemo extends StatefulWidget {

  final String? title;

  const AfterLayoutDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _AfterLayoutDemoState createState() => _AfterLayoutDemoState();
}

class _AfterLayoutDemoState extends State<AfterLayoutDemo> {
  String _text = 'flutter 实战 ';
  final Size _size = Size.zero;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () => print('Text1: ${context.size}'),
                child: Text(
                  'Text1: 点我获取我的大小',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue),
                ),
              );
            },
          ),
        ),
        // AfterLayout(
        //   callback: (RenderAfterLayout ral) {
        //     print('Text2： ${ral.size}, ${ral.offset}');
        //   },
        //   child: Text('Text2：flutter@wendux'),
        // ),
        // Builder(builder: (context) {
        //   return Container(
        //     color: Colors.grey.shade200,
        //     alignment: Alignment.center,
        //     width: 100,
        //     height: 100,
        //     child: AfterLayout(
        //       callback: (RenderAfterLayout ral) {
        //         Offset offset = ral.localToGlobal(
        //           Offset.zero,
        //           ancestor: context.findRenderObject(),
        //         );
        //         print('A 在 Container 中占用的空间范围为：${offset & ral.size}');
        //       },
        //       child: Text('A'),
        //     ),
        //   );
        // }),
        // Divider(),
        // AfterLayout(
        //   child: Text(_text),
        //   callback: (RenderAfterLayout value) {
        //     setState(() {
        //       //更新尺寸信息
        //       _size = value.size;
        //     });
        //   },
        // ),
        // //显示上面 Text 的尺寸
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Text size: $_size ',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _text += 'flutter 实战 ';
            });
          },
          child: Text('追加字符串'),
        ),
      ],
    );
  }
}