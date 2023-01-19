import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/section_header.dart';
import 'package:flutter_templet_project/extension/alignment_ext.dart';
import 'package:tuple/tuple.dart';


class GradientOfRadialDemo extends StatefulWidget {

  GradientOfRadialDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _GradientOfRadialDemoState createState() => _GradientOfRadialDemoState();
}

class _GradientOfRadialDemoState extends State<GradientOfRadialDemo> {

  var maxWidth = double.infinity;
  var maxHeight = double.infinity;

  /// 是否是贪婪模式
  var isGreed = true;
  /// 是否使用对角线做半径
  bool isDiagonal = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          bottom: buildAppBottom(),
        ),
        body: Container(
          // height: 300,
          child: buildRadial(),
        ),
        // body: ListView(
        //   children: [
        //     SectionHeader.h4(title: 'RadialGradient',),
        //     buildRadial(),
        //   ],
        // )
    );
  }

  buildAppBottom() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDropdownButton(),
          _buildButton(
            text: "isGreed: ${isGreed.toString()}",
            onPressed: () {
              this.isGreed = !this.isGreed;
              setState(() {});
            },
          ),
          _buildButton(
            text: "isDiagonal: ${isDiagonal.toString()}",
            onPressed: () {
              this.isDiagonal = !this.isDiagonal;
              setState(() {});
            },
          ),
        ],
      )
    );
  }

  var _dropValue = AlignmentExt.allCases[0];
  var _radius = 0.5;

  _buildDropdownButton() {
    return DropdownButton<Alignment>(
      value: _dropValue,
      items: AlignmentExt.allCases.map((e) => DropdownMenuItem(
        child: Text(e.toString().split('.')[1]),
        value: e,
      ),
      ).toList(),
      onChanged: (Alignment? value) {
        if (value == null) return;
        _dropValue = value;
        setState(() {});
      },
    );
  }

  _buildButton({
    required String text,
    required VoidCallback onPressed
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Center(
          child: Text(text,
            style: TextStyle(color: Colors.white),
          )
      ),
    );
  }

  Widget _buildBox({
    required String text,
    required Decoration decoration,
    double height: 100,
    double? width,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        this.maxWidth = constraints.maxWidth;
        this.maxHeight = constraints.maxHeight;
        return Container(
          // width: width,
          // height: height,
          margin: const EdgeInsets.all(8.0),
          decoration: decoration,
          alignment: Alignment.center,
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16.0)),
        );
      }
    );
  }

  buildRadial() {
    var tuples = <Tuple2<Color, double>>[
      Tuple2(Colors.red, 0.1),
      Tuple2(Colors.blue, 0.3),
      Tuple2(Colors.yellow, 0.5),
      Tuple2(Colors.green, 1),
    ];

    _radius = _dropValue.radiusOfRadialGradient(
      width: this.maxWidth,
      height: this.maxHeight,
      isGreed: this.isGreed,
      isDiagonal: this.isDiagonal
    ) ?? 0.5;
    print("_dropValue:${_dropValue} _radius:${_radius} maxWidth:${maxWidth} maxHeight:${maxHeight}");
    return _buildBox(
      height: 100,
      text: 'RadialGradient',
      decoration: BoxDecoration(
        border: Border.all(),
        gradient: RadialGradient(
          // tileMode: this.tileMode,
          // tileMode: TileMode.mirror,
          radius: _radius,
          tileMode: TileMode.decal,
          center: _dropValue,
          // focal: Alignment.bottomCenter,
          colors: tuples.map((e) => e.item1).toList(),
          stops: tuples.map((e) => e.item2).toList(),
        ),
      ),
    );
  }

}