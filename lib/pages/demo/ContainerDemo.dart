import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';

class ContainerDemo extends StatefulWidget {

  final String? title;

  ContainerDemo({ Key? key, this.title}) : super(key: key);

  @override
  _ContainerDemoState createState() => _ContainerDemoState();
}

class _ContainerDemoState extends State<ContainerDemo> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            TextButton(
              onPressed: () {
                print('TextButton');
                setState(() {});
              },
              child: Text('done',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: buildBodyColumn(
          children: [
            buildSection(),
            // Container(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage('images/img_update.png'),
            //       repeat: ImageRepeat.repeat,
            //       alignment: Alignment.topLeft,
            //     )
            //   ),
            //   child: Container(
            //     constraints: BoxConstraints.expand(),
            //     child: OutlinedButton(
            //       onPressed: () { print("ImageRepeat.repeat"); },
            //       child: Text('ImageRepeat.repeat',
            //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  // image: AssetImage('images/img_update.png'),
                  image: "img_update".toPngAssetImage(),
                  repeat: ImageRepeat.repeat,
                  alignment: Alignment.topLeft,
                )
              ),
              transform: Matrix4.rotationZ(.2),
              alignment: Alignment.centerRight, //卡片内文字居中
              child: Text(
                //卡片文字
                "5.20", style: TextStyle(color: Colors.red, fontSize: 40.0),
              ),
            ),

            // Container(
            //   color: Colors.green,
            //   child: Text('Container'),
            // ),
            // Container(
            //   constraints: BoxConstraints.expand(),
            //   color: Colors.yellow,
            //   child: Text('Container1'),
            // ),

          ],
        )
    );
  }

  buildBodyColumn({
    List<Widget> children = const <Widget>[],
  }) {
    return Column(
      children: children.map((e) => Builder(
        builder: (context) {
          return Expanded(child: e,);
        }
      )).toList(),
    );
  }

  buildBodyCustom({
    List<Widget> children = const <Widget>[],
  }) {
    return CustomScrollView(
      slivers: children.map((e) => SliverToBoxAdapter(child: e,)).toList(),
    );
  }


  buildSection() {
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
        foregroundDecoration: BoxDecoration(
          color: Colors.yellow,
          border: Border.all(color: Colors.green, width: 5),
          borderRadius: BorderRadius.all(Radius.circular(400)),
          image: DecorationImage(
            image: NetworkImage('https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg'),
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
}