// import 'package:flutter/cupertino.dart';
// import 'package:flutter/src/painting/colors.dart';

import 'package:color_converter/color_converter.dart';
import 'package:flutter/material.dart';

class ColorConverterDemo extends StatefulWidget {
  const ColorConverterDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ColorConverterDemoState createState() => _ColorConverterDemoState();
}

class _ColorConverterDemoState extends State<ColorConverterDemo> {
  List<Color> get colors {
    // final color = Color.fromRGBO(234, 35, 20, 1);
    const color = Colors.greenAccent;
    return [
      color,
      HSVColor.fromColor(color).toColor(),
      HSLColor.fromColor(color).toColor(),
      ColorExt.fromHex('#8e88e8') ?? Colors.red,
      ColorExt.fromHex('#8e88e8', alpha: 0.66) ?? Colors.red,
      ColorExt.fromHex('#8e88e8', alpha: 0.3) ?? Colors.red,

      // rgbColor.toCmyk(),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            TextButton(
              onPressed: () => test(),
              child: Text(
                'done',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        body: Column(
          children: colors
              .map((e) => Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: e,
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  )))
              .toList(),
        ));
  }

  test() {
    final rgbColor = RGB(r: 234, g: 235, b: 120);
    debugPrint(rgbColor.toString());
    debugPrint(rgbColor.toHex().toString());
    debugPrint(rgbColor.toCmyk().toString());
    debugPrint(rgbColor.toHsb().toString());
    debugPrint(rgbColor.toHsl().toString());
    debugPrint(rgbColor.toLab().toString());
    debugPrint(rgbColor.toXyz().toString());
    debugPrint((rgbColor == CMYK(c: 0, m: 0, y: 49, k: 8)).toString());
  }
}
