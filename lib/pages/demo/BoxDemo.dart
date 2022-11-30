//
//  BoxDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/10/21 10:11 AM.
//  Copyright © 12/10/21 shang. All rights reserved.
//

/// 尺寸限制类容器:
/// AspectRatio它可以指定子组件的长宽比、
/// LimitedBox 用于指定最大宽高、
/// FractionallySizedBox 可以根据父容器宽高的百分比来设置子组件宽高等
///

import 'package:flutter/material.dart';

class BoxDemo extends StatefulWidget {

  final String? title;

  BoxDemo({ Key? key, this.title}) : super(key: key);


  @override
  _BoxDemoState createState() => _BoxDemoState();
}

class _BoxDemoState extends State<BoxDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildBody(),
    );
  }

  _buildBody() {
    return Column(
      children: [
        _buildSizedBox(),
        Divider(),
        _buildConstrainedBox(),
        Divider(),
        _buildFittedBox(),
        Divider(),
        _buildUnconstrainedBox(),
        // Divider(),
        // _buildOverflowBox(),
        Divider(),
        _buildOverflowBox1(),
        Divider(),
        _buildOverflowBox2(),
      ],
    );
  }


  _buildSizedBox() {
    return Container(
      width: 300,
      height: 100,
      // color: Colors.green,
      child: SizedBox.expand(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.5,
          alignment: FractionalOffset.center,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 4,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ConstrainedBox用于对子组件添加额外的约束。
  _buildConstrainedBox() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity, //宽度尽可能大
        minHeight: 50.0 //最小高度为50像素
      ),
      child: Container(
        height: 5.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.green
          ),
        ) ,
      ),
    );
  }

  _buildFittedBox() {
    return Container(
      height: 100,
      width: 300,
      color: Colors.green,
      child: FittedBox(
        // child: Image.network('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
        child: Image.asset('images/bg.jpg',
          fit: BoxFit.cover,
        ),
        fit: BoxFit.contain,
      ),
    );
  }
  
  /// UnconstrainedBox会消除上层组件的约束，也就意味着UnconstrainedBox 的子组件将不再受到约束，大小完全取决于自己。
  _buildUnconstrainedBox() {
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 200.0, minHeight: 100.0),  //父
        child: UnconstrainedBox( //“去除”父级限制
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 90.0, minHeight: 30.0),//子
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.red),
            ),
          ),
        )
      )
    );
  }


  _buildOverflowBox({
    width: 70.0,
    height: 70.0,
    padding: const EdgeInsets.all(5.0),
  }) {
    return Container(
      color: Colors.green,
      width: width,
      height: height,
      padding: padding,
      child: OverflowBox(
        alignment: Alignment.topLeft,
        maxWidth: width + 20 * 2,
        maxHeight: width + 20 * 2,
        child: Container(
          color: Colors.yellow.withOpacity(0.5),
        ),
      ),
    );
  }

  _buildOverflowBox1({
    width: 70.0,
    height: 70.0,
    padding: const EdgeInsets.all(5.0),
  }) {
    return Container(
      color: Colors.green,
      width: width,
      height: height,
      // padding: padding,
      child: OverflowBox(
        alignment: Alignment.center,
        maxWidth: width + 20 * 2,
        maxHeight: width + 20 * 2,
        child: Container(
          color: Colors.yellow.withOpacity(0.5),
        ),
      ),
    );
  }

  _buildOverflowBox2({
    width: 70.0,
    height: 70.0,
    padding: const EdgeInsets.all(5.0),
  }) {
    return Container(
      color: Colors.green,
      width: width,
      height: height,
      // padding: padding,
      child: OverflowBox(
        alignment: Alignment.topRight,
        maxWidth: 140,
        maxHeight: 140,
        child: Container(
          color: Colors.blue.withOpacity(0.5),
        ),
      ),
    );
  }
}


