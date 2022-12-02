import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/syn_home_swiper_widget.dart';
import 'package:flutter_templet_project/extension/buildContext_extension.dart';

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
        body: ListView(
          children: [
            buildSwiper(),
            buildSwiper(showCount: 2.0),
            buildSwiper(showCount: 3.0),
            buildSwiper(showCount: 2.5),
          ],
        )
    );
  }

   buildSwiper({double showCount = 1.0}) {
    double paddingRight = showCount == 2.5 ? 0.0 : 12;
    return SynHomeSwiperWidget(
      margin: EdgeInsets.all(12),
      height: 147 * 1.2,
      // width: 300,
      width: screenSize.width,
      bg: AssetImage('images/bg_home_swiper.png'),
      padding: EdgeInsets.only(top: 57, right: paddingRight, bottom: 16, left: 0, ),
      showCount: showCount,
    );
  }


}