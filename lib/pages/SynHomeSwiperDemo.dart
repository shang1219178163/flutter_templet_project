import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/syn_home_swiper_widget.dart';

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
        body: buildSwiper()
    );
  }

   buildSwiper() {
    return SynHomeSwiperWidget();
  }

}