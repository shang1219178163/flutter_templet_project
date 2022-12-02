import 'package:flutter/material.dart';


class ImageBlendModeDemo extends StatefulWidget {

  final String? title;

  ImageBlendModeDemo({ Key? key, this.title}) : super(key: key);


  @override
  _ImageBlendModeDemoState createState() => _ImageBlendModeDemoState();
}

class _ImageBlendModeDemoState extends State<ImageBlendModeDemo> {

  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            IconButton(
              onPressed: (){
                flag = !flag;
                setState(() {});
              },
              icon: Icon(Icons.change_circle_outlined)
            )
          ],
        ),
        body: _buildBody(),
    );
  }

  _buildBody() {
    var name = flag ? 'images/img_update.png' : 'images/flutter_logo.png';
    return Container(
      // color: Colors.black,
      padding: EdgeInsets.all(8),
      child: Wrap(
        children: blendModes.map((e) => Container(
          child: Column(
            children: [
              Image.asset(name,
                color: Colors.grey,
                width: 80.0,
                colorBlendMode: e
              ),
              Text("${e}".split('.')[1]),
            ],
          ),
        )
        ).toList(),
      ),
    );
  }
}


final blendModes = [
  BlendMode.clear,
  BlendMode.src,
  BlendMode.dst,
  BlendMode.srcOver,
  BlendMode.dstOver,
  BlendMode.srcIn,
  BlendMode.dstIn,
  BlendMode.srcOut,
  BlendMode.dstOut,
  BlendMode.srcATop,
  BlendMode.dstATop,
  BlendMode.xor,
  BlendMode.plus,
  BlendMode.modulate,
  BlendMode.screen,
  BlendMode.overlay,
  BlendMode.darken,
  BlendMode.lighten,
  BlendMode.colorDodge,
  BlendMode.colorBurn,
  BlendMode.hardLight,
  BlendMode.softLight,
  BlendMode.difference,
  BlendMode.exclusion,
  BlendMode.multiply,
  BlendMode.hue,
  BlendMode.saturation,
  BlendMode.color,
  BlendMode.luminosity,
];

//
// enum BlendMode {
//   clear,
//   src,
//   dst,
//   srcOver,
//   dstOver,
//   srcIn,
//   dstIn,
//   srcOut,
//   dstOut,
//   srcATop,
//   dstATop,
//   xor,
//   plus,
//   modulate,
//   screen,
//   overlay,
//   darken,
//   lighten,
//   colorDodge,
//   colorBurn,
//   hardLight,
//   softLight,
//   difference,
//   exclusion,
//   multiply,
//   hue,
//   saturation,
//   color,
//   luminosity,
// }