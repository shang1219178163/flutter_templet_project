import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_templet_project/basicWidget/SynHomeNavWidget.dart';
import 'package:flutter_templet_project/extension/buildContext_extension.dart';
import 'package:flutter_templet_project/vendor/flutter_swiper_demo.dart';

class SynHomeNavDemo extends StatefulWidget {

  final String? title;

  SynHomeNavDemo({ Key? key, this.title}) : super(key: key);


  @override
  _SynHomeNavDemoState createState() => _SynHomeNavDemoState();
}

class _SynHomeNavDemoState extends State<SynHomeNavDemo> {


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
    return ListView(
      children: [
        Column(
          children: [
            _buildNav(),
            Divider(),
            _buildSwiper(),
          ],
        ),
      ],
    );
  }

  _buildNav() {
    return Container(
      // height: 200,
      // width: 400,
      constraints: BoxConstraints(
        maxHeight: 200,
      ),
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(0),
      child: SynHomeNavWidget(
        width: screenSize.width - 24,
        // height: 500,
      ),
    );
  }

  _buildSwiper() {
    return Container(
      color: Colors.lightBlue,
      // padding: EdgeInsets.all(0),
      // margin: EdgeInsets.all(0),
      constraints: BoxConstraints.tightFor(
        height: 200,
      ),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return _buildNav();
          return CustomSwiperItem(
            url: images[index],
            color: index.isEven ? Colors.green : Colors.yellow,
          );
        },
        indicatorLayout: PageIndicatorLayout.COLOR,
        autoplay: true,
        loop: true,
        itemCount: images.length,
        pagination: new SwiperPagination(),
        // control: new SwiperControl(color: Colors.transparent),
        // itemWidth: screenSize.width * 0.5,
        // viewportFraction: 0.6,
      ),
    );
  }

}

final List<String> images = [
  "https://cdn.pixabay.com/photo/2016/09/04/08/13/harbour-crane-1643476_1280.jpg",
  "https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg",
  "https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg",
  'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
  'https://pic.616pic.com/bg_w1180/00/07/20/2gfqq0N3qX.jpg!/fw/1120',
];
