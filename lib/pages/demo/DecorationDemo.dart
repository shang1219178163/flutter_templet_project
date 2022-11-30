import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/syn_decoration_widget.dart';
import 'package:flutter_templet_project/basicWidget/syn_decoration_widget_new.dart';
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
    final child = SynDecorationWidgetNew(
      width: 400,
      height: 400,
      opacity: 1,
      blur: 10,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
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
      bgGradient: LinearGradient(
        colors: [Colors.green, Colors.yellow],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      child: ElevatedButton.icon(
        icon: Icon(Icons.send),
        label: Text("ElevatedButton"),
        onPressed: () {
          print('ElevatedButton');
        },
      ),
    );

    return child;
  }

  buildSection3() {
    final child = SynDecorationWidget(
      // width: 400,
      // height: 400,
      opacity: 1.0,
      blur: 1,
      margin: const EdgeInsets.all(50),
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

  // _buildItem() {
  //   return
  // }
}
