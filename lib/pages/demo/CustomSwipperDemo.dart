import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/custom_swiper.dart';
import 'package:flutter_templet_project/util/R.dart';

class CustomSwipperDemo extends StatefulWidget {
  final String? title;

  const CustomSwipperDemo({Key? key, this.title}) : super(key: key);

  @override
  _CustomSwipperDemoState createState() => _CustomSwipperDemoState();
}

class _CustomSwipperDemoState extends State<CustomSwipperDemo> {
  final List<String> images = Resource.image.urls;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Column(
          children: <Widget>[
            _buildCustomeBanner(),
          ],
        ));
  }

  _buildCustomeBanner() {
    return CustomSwipper(
      images: images,
      onTap: (int index) {
        debugPrint('CustomBanner 当前 page 为 $index');
      },
      // itemBuilder: (BuildContext context, int index) {
      //
      // },
    );
  }
}
