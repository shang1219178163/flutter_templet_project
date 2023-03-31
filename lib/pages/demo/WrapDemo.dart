import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/section_header.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';

class WrapDemo extends StatefulWidget {

  final String? title;

  const WrapDemo({ Key? key, this.title}) : super(key: key);


  @override
  _WrapDemoState createState() => _WrapDemoState();
}

class _WrapDemoState extends State<WrapDemo> {


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
    return Column(
      children: [
        SectionHeader(title: 'Axis.horizontal'),
        Container(
          // height: 200,
          // width: 400,
          constraints: BoxConstraints(
            maxHeight: 200,
          ),
          margin: EdgeInsets.all(12),
          child: WrapWidget(
            width: screenSize.width - 24,
            direction: Axis.horizontal,
            // height: 500,
          ),
        ),
        
        Divider(),
        SectionHeader(title: 'Axis.vertical'),
        Container(
          // height: 200,
          // width: 400,
          constraints: BoxConstraints(
            maxHeight: 200,
          ),
          margin: EdgeInsets.all(12),
          child: WrapWidget(
            width: screenSize.width - 24,
            direction: Axis.vertical,
            // height: 500,
          ),
        ),
      ]
    );
  }

}

class WrapWidget extends StatelessWidget {

  const WrapWidget({
    Key? key,
    this.title,
    this.width = double.infinity,
    this.height = double.infinity,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.spacing = 22,
    this.runSpacing = 12,
    this.direction = Axis.horizontal,
    this.rowCount = 5,
  }) : super(key: key);


  final String? title;
  final double width;
  final double height;

  final EdgeInsets padding;
  final EdgeInsets margin;

  final double spacing;
  final double runSpacing;
  final Axis direction;

  final int rowCount;

  itemWidth() {
    var contentWidth = width - padding.left - padding.right - margin.left - margin.right;
    var w = (contentWidth - (rowCount - 1) * spacing)/rowCount;
    return w;
  }

  @override
  Widget build(BuildContext context) {
    return _buildSwiperItem();
  }

  _buildSwiperItem() {
    return ColoredBox(
      color: Colors.lightGreen,
      child: Wrap(
        direction: direction,
        spacing: direction == Axis.horizontal ? spacing : runSpacing,
        // 主轴(水平)方向间距
        runSpacing: direction == Axis.horizontal ? runSpacing : spacing,
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

  Widget _buildItemNew({Color? color}) {
    return GestureDetector(
      onTap: () => debugPrint(color.toString()),
      child: Container(
        width: itemWidth(),
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
    alignment = Alignment.centerLeft,
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

}

final List<String> images = [
  "https://cdn.pixabay.com/photo/2016/09/04/08/13/harbour-crane-1643476_1280.jpg",
  "https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg",
  "https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg",
  'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
  'https://pic.616pic.com/bg_w1180/00/07/20/2gfqq0N3qX.jpg!/fw/1120',
];