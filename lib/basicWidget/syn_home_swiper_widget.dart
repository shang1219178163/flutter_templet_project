import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class SynHomeSwiperWidget extends StatelessWidget {

  final String? title;
  final double? width;
  final double? height;

  const SynHomeSwiperWidget({
  	Key? key,
  	this.title,
    this.width = double.infinity,
    this.height = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBoxDecoration({
    ImageProvider<Object>? image,
    Color? color,
    Border? border,
    BorderRadiusGeometry? borderRadius = const BorderRadius.all(Radius.circular(5)),
  }) {
    return BoxDecoration(
      color: color,
      border: border ?? Border.all(width: 0, color: Colors.transparent),
      borderRadius: borderRadius,
      image: image == null ? null : DecorationImage(
        image: image,
        fit: BoxFit.fill
      ), //设置图片
    );
  }

  _buildBody() {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
      width: double.infinity,
      height: 147*1.2,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(width: 3, color: Colors.red),
        // borderRadius:const BorderRadius.all(Radius.circular(6)),
        image: DecorationImage(
          image: AssetImage('images/bg_home_swiper.png'),
          fit: BoxFit.fill
        ), //设置图片
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 47, right: 0, bottom: 16, left: 0, ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _buildChildren(),
        ),
      )
    );
  }

  _buildChildren() {
    final items = [
      Tuple3(
        150.0,
        'https://avatar.csdn.net/8/9/A/3_chenlove1.jpg',
        '海尔｜无边界厨房',
      ),
      Tuple3(
        150.0,
        'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
        '海尔｜无边界客厅',
      ),
      Tuple3(
        150.0,
        'https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg',
        '海尔｜无边界卧室',
      ),
      Tuple3(
        150.0,
        'https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg',
        '海尔｜无边界其他',
      ),
    ];

    return items.map((e) {
      double width = e.item1;
      final url = e.item2;
      final text = e.item3;

      int index = items.indexOf(e);
      var padding = index == items.length - 1 ? EdgeInsets.only(left: 8, right: 8)
          : EdgeInsets.only(left: 8, right: 0);
      // padding = EdgeInsets.all(0);

      return Padding(
        padding: padding,
        child: _buildItem1(
          text: text,
          padding: EdgeInsets.only(left: 6, bottom: 4),
          bgBuilder: () {
            return FadeInImage.assetNetwork(
              placeholder: 'images/img_placeholder.png',
              image: url,
              fit: BoxFit.fill,
              width: width,
              height: double.infinity
            );
          },
        ),
      );
    }).toList();
  }


  _buildText({
    text = '-',
    maxLines = 1,
    style = const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      fontFamily: 'PingFangSC-Regular,PingFang SC',
      color: Color(0xFFFFFFFF),
    ),
    padding = const EdgeInsets.all(0),
    alignment = Alignment.centerLeft,
  }) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
          style: style,
        ),
      ),
    );
  }


  _buildItem1({
    text = '',
    padding = const EdgeInsets.all(0),
    required Widget Function() bgBuilder,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            bgBuilder(),
            // FadeInImage.assetNetwork(
            //   placeholder: 'images/img_placeholder.png',
            //   image: 'https://avatar.csdn.net/8/9/A/3_chenlove1.jpg',
            //   fit: BoxFit.fill,
            //   width: 100,
            // ),

            _buildText(
              alignment: Alignment.bottomLeft,
              padding: padding,
              text: text,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                fontFamily: 'PingFangSC-Regular,PingFang SC',
                color: Color(0xFFFFFFFF),
              ),
            )
          ],
        ),
        SizedBox(
          width: 24,
          height: 24,
          child: Image.asset('images/icon_play.png',),
        ),
      ],
    );
  }

  // _buildItem({
  //   double width = 200,
  //   EdgeInsetsGeometry margin = const EdgeInsets.only(left: 8, right: 8),
  //   String text = '-',
  //   ImageProvider? bg,
  // }) {
  //   return Stack(
  //     alignment: Alignment.center,
  //     children: [
  //       Container(
  //         margin: margin,
  //         width: width,
  //         decoration: _buildBoxDecoration(
  //           // image: AssetImage('images/img_placeholder.png'),
  //           // image: NetworkImage('..'),
  //           image: bg,
  //         ),
  //         child: _buildText(
  //           alignment: Alignment.bottomLeft,
  //           padding: EdgeInsets.only(left: 6, bottom: 4),
  //           text: text,
  //           maxLines: 1,
  //           style: TextStyle(
  //             fontSize: 12.0,
  //             fontWeight: FontWeight.w400,
  //             fontFamily: 'PingFangSC-Regular,PingFang SC',
  //             color: Color(0xFFFFFFFF),
  //           ),
  //         ),
  //       ),
  //       SizedBox(
  //         width: 24,
  //         height: 24,
  //         child: Image.asset('images/icon_play.png',),
  //       ),
  //     ],
  //   );
  // }


}