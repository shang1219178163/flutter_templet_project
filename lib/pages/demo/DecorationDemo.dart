import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/syn_decoration_widget.dart';
import 'package:flutter_templet_project/extension/buildContext_extension.dart';


class DecorationDemo extends StatefulWidget {

  DecorationDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _DecorationDemoState createState() => _DecorationDemoState();
}

class _DecorationDemoState extends State<DecorationDemo> {

  var isFrist = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          TextButton(
            onPressed: () {
              isFrist = !isFrist;
              setState(() {});
            },
            child: Text(isFrist ? 'style1' : 'style2',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: isFrist ? buildSection1() : buildSection3(),
    );
  }

  buildSection1() {
    final child = buildSection5(
      child: ElevatedButton.icon(
        icon: Icon(Icons.send),
        label: Text("ElevatedButton"),
        onPressed: () {
          print('ElevatedButton');
        },
      ),
      bgChild: Center(
        child: Container(
          width: 200,
          height: 200,
          color: Colors.lightGreen,
        ),
      ),
    );

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Text('0' * 10000),
        Center(
          child: child,
        ),
      ],
    );
  }

  buildSection2() {
    final child = buildSection5(
      blur: 1,
      child: ElevatedButton.icon(
        icon: Icon(Icons.send),
        label: Text("ElevatedButton"),
        onPressed: () {
          print('ElevatedButton');
        },
      ),
      bgChild: Center(
        child: Container(
          width: 200,
          height: 200,
          color: Colors.lightBlueAccent,
        ),
      ),
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        Text('L' * 10000),
        child,
      ],
    );
  }

  buildSection3() {
    final child = SynDecorationWidget(
      // width: 400,
      // height: 400,
      opacity: 1.0,
      blur: 1,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(0),
      topLeftRadius: 0,
      topRightRadius: 25,
      bottomLeftRadius: 45,
      bottomRightRadius: 85,
      bgUrl: 'https://tenfei02.cfp.cn/creative/vcg/800/new/VCG21409037867.jpg',
      // bgChild: FadeInImage.assetNetwork(
      //   placeholder: 'images/img_placeholder.png',
      //   image: 'https://tenfei02.cfp.cn/creative/vcg/800/new/VCG21409037867.jpg',
      //   fit: BoxFit.fill,
      //   width: 400,
      //   height: 400,
      // ),
      bgColor: Colors.yellow,
      // bgGradient: LinearGradient(
      //   colors: [Colors.green, Colors.yellow],
      //   begin: Alignment.topCenter,
      //   end: Alignment.bottomCenter,
      // ),
      child: ElevatedButton.icon(
        icon: Icon(Icons.send),
        label: Text("ElevatedButton"),
        onPressed: () {
          print('ElevatedButton');
        },
      ),
    );

    return Container(
      width: 400,
      height: 400,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Text('L' * 10000),
          child,
        ],
      ),
    );
  }

  buildBorderRadius({
    double topLeftRadius = 5,
    double topRightRadius = 25,
    double bottomLeftRadius = 45,
    double bottomRightRadius = 85,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeftRadius),
      topRight: Radius.circular(topRightRadius),
      bottomLeft: Radius.circular(bottomLeftRadius),
      bottomRight: Radius.circular(bottomRightRadius),
    );
  }

  buildBoxDecoration({
    BoxBorder borderSide = const Border.fromBorderSide(BorderSide(color: Colors.red, width: 2)),
    required BorderRadius borderRadius,
  }) {
    return BoxDecoration(
      border: borderSide,
      borderRadius: borderRadius
    );
  }

  buildImage({
    double width = 200,
    double height = 200,
  }) {
    var url  = 'https://tenfei02.cfp.cn/creative/vcg/800/new/VCG211409104387-QDB.jpg';
    url  = 'https://tenfei02.cfp.cn/creative/vcg/800/new/VCG21409037867.jpg';
    return FadeInImage.assetNetwork(
      placeholder: 'images/img_placeholder.png',
      image: url,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }

  buildSection5({
    double opacity = 1.0,
    double blur = 0,
    EdgeInsetsGeometry margin = const EdgeInsets.all(0),
    EdgeInsetsGeometry padding = const EdgeInsets.all(0),
    double topLeftRadius = 0,
    double topRightRadius = 25,
    double bottomLeftRadius = 45,
    double bottomRightRadius = 85,
    required Widget bgChild,
    required Widget child,
  }) {

    final borderRadius = buildBorderRadius(
      topLeftRadius: topLeftRadius,
      topRightRadius: topRightRadius,
      bottomLeftRadius: bottomLeftRadius,
      bottomRightRadius: bottomRightRadius,
    );

    final decoration = buildBoxDecoration(borderRadius: borderRadius);

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Opacity(
          opacity: opacity,
          child: Container(
            margin: margin,
            padding: padding,
            decoration: decoration,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: borderRadius,
                  child: bgChild,
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildSection6({
    double opacity = 1.0,
    double blur = 0,
    EdgeInsetsGeometry margin = const EdgeInsets.all(0),
    EdgeInsetsGeometry padding = const EdgeInsets.all(0),
    double topLeftRadius = 0,
    double topRightRadius = 25,
    double bottomLeftRadius = 45,
    double bottomRightRadius = 85,
    String? bgUrl,
    Widget? bgChild,
    required Widget child,
  }) {
    return SynDecorationWidget(
      opacity: opacity,
      blur: blur,
      margin: margin,
      padding: padding,
      topLeftRadius: topLeftRadius,
      topRightRadius: topRightRadius,
      bottomLeftRadius: bottomLeftRadius,
      bottomRightRadius: bottomRightRadius,
      bgUrl: bgUrl,
      bgChild: bgChild,
      child: child,
    );
  }

  // _buildItem() {
  //   return
  // }

}
