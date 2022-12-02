import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/syn_home_swiper_widget.dart';
import 'package:flutter_templet_project/extension/buildContext_extension.dart';
import 'package:tuple/tuple.dart';

class SynHomeSwiperDemo extends StatefulWidget {

  final String? title;

  SynHomeSwiperDemo({ Key? key, this.title}) : super(key: key);


  @override
  _SynHomeSwiperDemoState createState() => _SynHomeSwiperDemoState();
}

class _SynHomeSwiperDemoState extends State<SynHomeSwiperDemo> {


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
              // buildSwiper(),
              buildSwiper(showCount: 2.0),
              buildSwiper(showCount: 3.0),
              buildSwiper(showCount: 2.5),
            ],
          ),
        )
    );
  }

   buildSwiper({double showCount = 1.0}) {
    double paddingRight = showCount == 2.5 ? 0.0 : 12;
    return Container(
      // color: Colors.red,
      decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(
            color: Colors.red,
        ),
      ),
      child: SynHomeSwiperWidget(
        items: items,
        margin: EdgeInsets.all(12),
        height: 147 * 1.2,
        width: screenSize.width,
        bg: AssetImage('images/bg_home_swiper.png'),
        padding: EdgeInsets.only(top: 57, right: paddingRight, bottom: 16, left: 0, ),
        showCount: showCount,
      ),
    );
  }

  final items = [
    Tuple3(
      'https://avatar.csdn.net/8/9/A/3_chenlove1.jpg',
      '海尔｜无边界厨房',
      '',
    ),
    Tuple3(
      'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
      '海尔｜无边界客厅',
      '',
    ),
    Tuple3(
      'https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg',
      '海尔｜无边界卧室',
      '',
    ),
    Tuple3(
      'https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg',
      '海尔｜无边界其他',
      '',
    ),
  ];

}

