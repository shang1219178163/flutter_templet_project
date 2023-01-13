import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/syn_decoration_widget.dart';
import 'package:flutter_templet_project/basicWidget/syn_decoration_widget.dart';
import 'package:flutter_templet_project/basicWidget/syn_horizontal_scroll_widget.dart';
import 'package:flutter_templet_project/extension/buildContext_ext.dart';
import 'package:tuple/tuple.dart';

class SynHomeSrollDemo extends StatefulWidget {

  final String? title;

  SynHomeSrollDemo({ Key? key, this.title}) : super(key: key);


  @override
  _SynHomeSrollDemoState createState() => _SynHomeSrollDemoState();
}

class _SynHomeSrollDemoState extends State<SynHomeSrollDemo> {


  bool isList = true;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          IconButton(
            onPressed: () {
              isList = !isList;
              setState(() {});
            },
            icon: Icon(Icons.all_inclusive),
          ),
        ],
      ),
      body: isList ? _buildBodyList() : _buildBody(),
    );
  }

  _buildBody() {
    return buildDecoration(
        child: buildHorizontalScrollWidget(showCount: 2.0)
    );
  }

  _buildBodyList() {
    return CustomScrollView(
      slivers: [
        SizedBox(height: 16),
        HorizontalScrollWidget(items: items, showCount: 1, isSwiper: true),
        SizedBox(height: 16),

        buildDecoration(
            child: HorizontalScrollWidget(items: items, showCount: 1,),
        ),
        // buildSwiper(),
        buildDecoration(
            child: buildHorizontalScrollWidget(showCount: 2.0)
        ),
        buildHorizontalScrollWidget(showCount: 3.0, color: Colors.green),
        buildHorizontalScrollWidget(showCount: 2.5),
        buildHorizontalScrollWidget(showCount: 1, isSwiper: true),

      ].map((e) => SliverToBoxAdapter(
        child: e,
      )).toList(),
    );
  }

  buildHorizontalScrollWidget({double showCount = 1.0, bool isSwiper = false, Color? color}) {
    double paddingRight = showCount == 2.5 ? 0.0 : 12;
    double paddingLeft = isSwiper ? 12 : 0;

    return SynHorizontalScrollWidget(
      isSwiper: isSwiper,
      items: items,
      margin: EdgeInsets.all(12),
      height: 147 * 1.2,
      width: screenSize.width,
      bg: AssetImage('images/bg_horizontal_scroll.png'),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          // spreadRadius: 3,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
      padding: EdgeInsets.only(left: paddingLeft, top: 57, right: paddingRight, bottom: 16, ),
      showCount: showCount,
      onTap: (Tuple4<String, String, String, bool> e) {
        print("onTap:${e}");
      },
    );
  }

  /// 外观设置
  buildDecoration({required Widget child, hasShell: true}) {
    if (!hasShell) {
      return child;
    }

    return SynDecorationWidget(
      width: 400,
      height: 150,
      opacity: 1.0,
      blur: 5,
      // margin: const EdgeInsets.all(50),
      padding: const EdgeInsets.all(10),
      topLeftRadius: 15,
      topRightRadius: 15,
      bottomLeftRadius: 15,
      bottomRightRadius: 15,
      // topLeftRadius: 0,
      // topRightRadius: 25,
      // bottomLeftRadius: 45,
      // bottomRightRadius: 85,
      bgUrl: 'https://tenfei02.cfp.cn/creative/vcg/800/new/VCG21409037867.jpg',
      // bgChild: FadeInImage.assetNetwork(
      //   placeholder: 'images/img_placeholder.png',
      //   image: 'https://tenfei02.cfp.cn/creative/vcg/800/new/VCG21409037867.jpg',
      //   fit: BoxFit.fill,
      //   width: 400,
      //   height: 400,
      // ),
      // bgColor: Colors.transparent,
      // bgGradient: LinearGradient(
      //   colors: [Colors.green, Colors.yellow],
      //   begin: Alignment.topCenter,
      //   end: Alignment.bottomCenter,
      // ),
      boxShadow: [
        BoxShadow(
          color: Colors.red.withOpacity(0.5),
          // spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
      child: child,
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

