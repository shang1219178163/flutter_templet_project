//
//  NnCollectionNavWidgetDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2/13/23 3:21 PM.
//  Copyright © 2/13/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_collection_nav_widget.dart';
import 'package:flutter_templet_project/basicWidget/number_stepper.dart';
import 'package:flutter_templet_project/util/R.dart';
import 'package:tuple/tuple.dart';

class NCollectionNavWidgetDemo extends StatefulWidget {
  const NCollectionNavWidgetDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _NCollectionNavWidgetDemoState createState() =>
      _NCollectionNavWidgetDemoState();
}

class _NCollectionNavWidgetDemoState extends State<NCollectionNavWidgetDemo> {
  List<String> imgUrls = R.image.urls;

  var _items = <AttrNavItem>[];

  ///金刚区每页行数
  int pageRowNum = 2;

  ///金刚区每页列数
  int pageColumnNum = 5;

  /// 图标默认高度
  double iconSize = DEFALUT_ICON_SIZE;

  /// 垂直间距
  double columnSpacing = 16;

  /// 水平间距
  double rowSpacing = SPACING;

  /// 文字间距
  double textOffset = 5;

  var tuples = <Tuple4<String, int, int, Function>>[];

  // List<Function> get notifiers => tuples.map((e) => e.item4).toList();
  /// viewModel
  final _collectionNavModel = NNCollectionNavNotify();

  @override
  void initState() {
    _items = List.generate(
        imgUrls.length,
        (index) => AttrNavItem(
              icon: imgUrls[index],
              // name: "标题_${index}",
              name: "测试标题啊",
            ));

    tuples = [
      Tuple4("列数 row", 1, 5, _collectionNavModel.changePageRowNum),
      Tuple4("行数 column", 1, 5, _collectionNavModel.changePageColumnNum),
      Tuple4("划动方式", 0, 2, _collectionNavModel.changeScrollTypeIndex),
      // Tuple4("行数", 1, 2, ValueNotifier(2)),
    ];

    // TODO: implement initState
    super.initState();
  }

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
      body: ListView(children: [
        Column(
          children: [
            ..._buildHeader(),
            Container(
              margin: EdgeInsets.all(12),
              child: _buildAnimatedBuilder(),
            ),
          ],
        )
      ]),
    );
  }

  onPressed() {
    debugPrint("枚举值索引: ${PageViewScrollType.full.index}");
    debugPrint("枚举值字符串: ${PageViewScrollType.drag.toString()}");
    debugPrint("枚举值集合: ${PageViewScrollType.values}");
    debugPrint("int 转枚举: ${0.toPageViewScrollType()}");
    final result = [1, 7, 3, 6, 5, 6]
        .sublist(1)
        .reduce((value, element) => value + element);
    debugPrint("result: $result");

    debugPrint("result: ${[1, 7, 3, 6, 5, 6].sublist(0, 1)}");
    debugPrint("result: ${[1, 7, 3, 6, 5, 6].sublist(1 + 1)}");
  }

  /// 多值变化
  List<Widget> _buildHeader() {
    return tuples
        .map((e) => Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    e.item1,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  NumberStepper(
                    min: e.item2,
                    max: e.item3,
                    step: 1,
                    iconSize: 30,
                    value: e.item3,
                    color: Theme.of(context).primaryColor,
                    readOnly: false,
                    onChanged: (value) {
                      e.item4.call(value);
                    },
                  ),
                ],
              ),
            ))
        .toList();
  }

  /// 多值监听
  Widget _buildAnimatedBuilder() {
    return AnimatedBuilder(
        animation: _collectionNavModel,
        builder: (context, child) {
          debugPrint("AnimatedBuilder");
          return NCollectionNavWidget(
            isDebug: true,
            items: _items,
            onItem: (e) => debugPrint(e.toString()),
            iconSize: 68,
            textGap: 5,
            pageColumnNum: _collectionNavModel.pageColumnNum,
            pageRowNum: _collectionNavModel.pageRowNum,
            scrollType: _collectionNavModel.scrollType,
          );
        });
  }
}

/// ChangeNotifier(不推荐使用,麻烦)
class NNCollectionNavNotify extends ChangeNotifier {
  ///金刚区每页行数
  int pageRowNum = 2;

  ///金刚区每页列数
  int pageColumnNum = 5;

  ///金刚区每页列数
  int scrollTypeIndex = 0;

  PageViewScrollType get scrollType =>
      PageViewScrollType.values[scrollTypeIndex];

  void changePageRowNum(int value) {
    pageRowNum = value;
    notifyListeners();
  }

  void changePageColumnNum(int value) {
    pageColumnNum = value;
    notifyListeners();
  }

  void changeScrollTypeIndex(int value) {
    scrollTypeIndex = value;
    notifyListeners();
  }

  @override
  String toString() {
    return "${runtimeType}_pageRowNum:${pageRowNum}_pageColumnNum:${pageColumnNum}_scrollType:$scrollType";
  }
}
