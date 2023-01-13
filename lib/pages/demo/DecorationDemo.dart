import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/syn_decoration_widget.dart';
import 'package:flutter_templet_project/basicWidget/syn_decoration_widget_one.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';


class DecorationDemo extends StatefulWidget {

  DecorationDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _DecorationDemoState createState() => _DecorationDemoState();
}

class _DecorationDemoState extends State<DecorationDemo> {

  bool isFlag = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          TextButton(
            onPressed: () {
              isFlag = !isFlag;
              setState(() {});
            },
            child: Text('done',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: isFlag ?  buildSection1() : buildSection3(),
    );
  }

  buildSection1() {
    final child = SynDecorationWidget(
      width: 300,
      height: 200,
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
      boxShadow: [
        BoxShadow(
          color: Colors.red.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
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

  buildSection2() {
    final child = SynDecorationWidgetOne(
      width: 300,
      height: 200,
      opacity: 1,
      blur: 20,
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
      boxShadow: [
        BoxShadow(
          color: Colors.red.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
      child: ElevatedButton.icon(
        icon: Icon(Icons.send),
        label: Text("ElevatedButton2"),
        onPressed: () {
          print('ElevatedButton');
        },
      ),
    );
    return child;
  }

  buildSection3() {
    return Opacity(
      opacity: 1,
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
            colors: [Colors.green, Colors.yellow],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          image: DecorationImage(
            image: NetworkImage('https://tenfei02.cfp.cn/creative/vcg/800/new/VCG21409037867.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.red,
            ),
            child: Text('VCG21409037867'),
          ),
        ),
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

}
