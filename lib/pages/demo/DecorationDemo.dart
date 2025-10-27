import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_box.dart';
import 'package:flutter_templet_project/util/AppRes.dart';

class DecorationDemo extends StatefulWidget {
  const DecorationDemo({Key? key, this.title}) : super(key: key);

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
            child: Text(
              'done',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: isFlag ? buildSection1() : buildSection3(),
    );
  }

  buildSection1() {
    final child = NBox(
      width: 300,
      height: 200,
      opacity: 1,
      blur: 10,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      borderRadius: BorderRadius.all(Radius.circular(15)),
      bgUrl: AppRes.image.urls[0],
      // bgChild: FadeInImage(
      //   placeholder: 'img_placeholder.png'.toAssetImage(),
      //   image: NetworkImage(R.image.urls[0]),
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
      boxShadows: [
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
          debugPrint('ElevatedButton');
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
            image: NetworkImage(AppRes.image.urls.first),
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
    var url = AppRes.image.urls.first;
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/img_placeholder.png',
      image: url,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }
}
