import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/custom_swiper.dart';

class CustomSwipperDemo extends StatefulWidget {

  final String? title;

  CustomSwipperDemo({ Key? key, this.title}) : super(key: key);


  @override
  _CustomSwipperDemoState createState() => _CustomSwipperDemoState();
}

class _CustomSwipperDemoState extends State<CustomSwipperDemo> {

  final List<String> images = [
    "https://cdn.pixabay.com/photo/2016/09/04/08/13/harbour-crane-1643476_1280.jpg",
    "https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg",
    "https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg",
    'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
    'https://pic.616pic.com/bg_w1180/00/07/20/2gfqq0N3qX.jpg!/fw/1120',
  ];


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Column(
          children: <Widget>[
            _buildCustomeBanner(),
          ],
        )
    );
  }

  _buildCustomeBanner() {

    return CustomSwipper(
        images: images,
        onTap: (int index) {
          print('CustomBanner 当前 page 为 ${index}');
        },
        // itemBuilder: (BuildContext context, int index) {
        //
        // },
    );
  }
}