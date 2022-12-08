import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_templet_project/vendor/flutter_swiper_demo.dart';


class SynCollectionNavWidgetNew extends StatelessWidget {


  SynCollectionNavWidgetNew({
  	Key? key,
  	this.title,
    this.width = double.infinity,
    this.height = double.infinity,
    this.itemImgWidth = 48,
    this.itemImgHeight = 48,

    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.spacing = 22,
    this.runSpacing = 16,
    this.direction = Axis.horizontal,
    this.rowCount = 5,
  }) : super(key: key);


  final String? title;
  final double width;
  final double height;
  double itemImgWidth;
  double itemImgHeight;

  final EdgeInsets padding;
  final EdgeInsets margin;

  final double spacing;
  final double runSpacing;
  final Axis direction;

  final int rowCount;

  @override
  Widget build(BuildContext context) {
    // return _buildSwiper();

    print("this.width:${this.width}");
    return _buildBody();
  }

  _buildSwiper() {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return CustomSwiperItem(
          url: images[index],
          color: index.isEven ? Colors.green : Colors.yellow,
        );
      },
      indicatorLayout: PageIndicatorLayout.COLOR,
      autoplay: true,
      itemCount: images.length,
      pagination: new SwiperPagination(),
      // control: new SwiperControl(color: Colors.transparent),
      // itemWidth: screenSize.width * 0.5,
      // viewportFraction: 0.6,
    );
  }

  _buildBody() {
    return ColoredBox(
      color: Colors.lightGreen,
      child: Wrap(
        direction: this.direction,
        spacing: this.direction == Axis.horizontal ? this.spacing : this.runSpacing,
        // 主轴(水平)方向间距
        runSpacing: this.direction == Axis.horizontal ? this.runSpacing : this.spacing,
        // 纵轴（垂直）方向间距
        alignment: WrapAlignment.start,
        //沿主轴方向居中
        runAlignment: WrapAlignment.start,
        // children: images.map((e) => _buildItem(url: e, text: "装修灵感啊", onPressed: (){
        //   print(e);
        // })).toList(),
        children: Colors.primaries.take(10).map((e) => _buildItemNew(color: e)
        ).toList(),
      ),
    );
  }


  // _buildBody() {
  //   return ColoredBox(
  //     color: Colors.lightGreen,
  //     child: Wrap(
  //       direction: this.direction,
  //       spacing: this.direction == Axis.horizontal ? this.spacing : this.runSpacing,
  //       // 主轴(水平)方向间距
  //       runSpacing: this.direction == Axis.horizontal ? this.runSpacing : this.spacing,
  //       // 纵轴（垂直）方向间距
  //       alignment: WrapAlignment.start,
  //       //沿主轴方向居中
  //       runAlignment: WrapAlignment.start,
  //       // children: images.map((e) => _buildItem(url: e, text: "装修灵感啊", onPressed: (){
  //       //   print(e);
  //       // })).toList(),
  //       children: Colors.primaries.take(10).map((e) => _buildItemNew(color: e)
  //       ).toList(),
  //     ),
  //   );
  // }

  Widget _buildItemNew({Color? color}) {
    return GestureDetector(
      onTap: () => print(color),
      child: Container(
        width: this.itemImgWidth,
        height: 70,
        color: color,
        child: Column(
          children: [
            FittedBox(
              child: FadeInImage.assetNetwork(
                placeholder: 'images/img_placeholder.png',
                image: 'https://pic.616pic.com/bg_w1180/00/07/20/2gfqq0N3qX.jpg!/fw/1120',
                fit: BoxFit.fill,
                width: 44,
                height: 44,
              ),
            ),
            SizedBox(height: 6,),
            _buildText(text: '免费设计免'),
          ],
        ),
      ),
    );
  }

  _buildText({
    text = '-',
    maxLines = 1,
    style = const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'PingFangSC-Regular,PingFang SC',
      color: Color(0xFF333333),
    ),
    padding = const EdgeInsets.all(0),
    alignment = Alignment.center,
  }) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: FittedBox(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            style: style,
          ),
        ),
      ),
    );
  }

  // _buildBodySwiper() {
  //   return Container(
  //     width: this.width,
  //     height: this.height,
  //     padding: this.padding,
  //     margin: this.margin,
  //     decoration: BoxDecoration(
  //       color: Colors.green,
  //       // border: Border.all(width: 3, color: Colors.red),
  //       // borderRadius:const BorderRadius.all(Radius.circular(8)),
  //       image: this.bg == null ? null : DecorationImage(
  //           image: this.bg!,
  //           fit: BoxFit.fill
  //       ), //设置图片
  //     ),
  //     child: _buildItemNew(),
  //   );
  // }
}




final List<String> images = [
  "https://cdn.pixabay.com/photo/2016/09/04/08/13/harbour-crane-1643476_1280.jpg",
  "https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg",
  "https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg",
  'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
  'https://pic.616pic.com/bg_w1180/00/07/20/2gfqq0N3qX.jpg!/fw/1120',
];