import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/custom_swiper.dart';
import 'package:flutter_templet_project/util/AppRes.dart';

class CustomSwipperDemo extends StatefulWidget {

  const CustomSwipperDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _CustomSwipperDemoState createState() => _CustomSwipperDemoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _CustomSwipperDemoState extends State<CustomSwipperDemo> {
  final List<String> images = AppRes.image.urls;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Column(
          children: <Widget>[
            buildCustomeBanner(),
          ],
        ));
  }

  Widget buildCustomeBanner() {
    return CustomSwipper(
      images: images,
      onTap: (index) {
        debugPrint('CustomBanner 当前 page 为 $index');
      },
      // itemBuilder: (BuildContext context, int index) {
      //
      // },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<String>('images', images));
  }
}
