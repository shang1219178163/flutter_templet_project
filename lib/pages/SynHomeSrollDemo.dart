import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/syn_horizontal_scroll_widget.dart';
import 'package:flutter_templet_project/extension/buildContext_extension.dart';
import 'package:tuple/tuple.dart';

class SynHomeSrollDemo extends StatefulWidget {

  final String? title;

  SynHomeSrollDemo({ Key? key, this.title}) : super(key: key);


  @override
  _SynHomeSrollDemoState createState() => _SynHomeSrollDemoState();
}

class _SynHomeSrollDemoState extends State<SynHomeSrollDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Container(
          // width: 400,
          child: ListView(
            children: [
              Column(
                children: [
                  // buildSwiper(),
                  buildSwiper(showCount: 2.0),
                  buildSwiper(showCount: 3.0),
                  buildSwiper(showCount: 2.5),
                  buildSwiper(showCount: 1, isSwiper: true),
                ],
              )
            ],
          ),
        )
    );
  }

   buildSwiper({double showCount = 1.0, isSwiper = false}) {
    double paddingRight = showCount == 2.5 ? 0.0 : 12;
    double paddingLeft = isSwiper ? 12 : 0;

    return Container(
      // color: Colors.red,
      decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(
            color: Colors.red,
        ),
      ),
      child: SynHorizontalScrollWidget(
        isSwiper: isSwiper,
        items: items,
        margin: EdgeInsets.all(12),
        height: 147 * 1.2,
        width: screenSize.width,
        bg: AssetImage('images/bg_home_swiper.png'),
        padding: EdgeInsets.only(left: paddingLeft, top: 57, right: paddingRight, bottom: 16, ),
        showCount: showCount,
        onTap: (Tuple4<String, String, String, bool> e) {
          print("onTap:${e}");
        },
      ),
    );
  }

  final items = [
    Tuple4(
      'https://avatar.csdn.net/8/9/A/3_chenlove1.jpg',
      '海尔｜无边界厨房',
      '跳转url',
      true,
    ),
    Tuple4(
      'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
      '海尔｜无边界客厅',
      '跳转url',
      false,
    ),
    Tuple4(
      'https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg',
      '海尔｜无边界厨房',
      '跳转url',
      false,
    ),
    // Tuple4(
    //   'https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg',
    //   '海尔｜无边界其他',
    //    '跳转url',
    //    false
    // ),
  ];

}

