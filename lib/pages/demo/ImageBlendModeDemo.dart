import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/painting_ext.dart';


class ImageBlendModeDemo extends StatefulWidget {

  final String? title;

  ImageBlendModeDemo({ Key? key, this.title}) : super(key: key);


  @override
  _ImageBlendModeDemoState createState() => _ImageBlendModeDemoState();
}

class _ImageBlendModeDemoState extends State<ImageBlendModeDemo> {

  final blendModes = BlendModeExt.allCases;

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