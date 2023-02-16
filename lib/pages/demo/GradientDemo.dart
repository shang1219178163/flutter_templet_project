import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/section_header.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/alignment_ext.dart';
import 'package:flutter_templet_project/pages/demo/GradientOfRadialDemo.dart';
import 'package:tuple/tuple.dart';

class GradientDemo extends StatefulWidget {
  final String? title;

  GradientDemo({Key? key, this.title}) : super(key: key);

  @override
  _GradientDemoState createState() => _GradientDemoState();
}

class _GradientDemoState extends State<GradientDemo> {
  
  // var blendModes = BlendMode.color;
  // var tileModes = TileMode.clamp;
  
  var blendMode = BlendMode.color;
  var tileMode = TileMode.clamp;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          TextButton(
            onPressed: () {
              showSheetTileMode();
            },
            child: Text("$tileMode", style: TextStyle(color: Colors.white),)
          ),
          TextButton(
            onPressed: () {
              showSheetBlendMode();
            },
            child: Text("$blendMode", style: TextStyle(color: Colors.white),)
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 50),
          child: Row(
            children: [
              _buildDropdownButton(),
            ],
          ),
        )
      ),
      body: _buildBody()
    );
  }
  
  showSheetTileMode() {
    final tileModes = TileMode.values;
    final items = tileModes.map((e) => Text('$e')).toList();

    showSheet(
      items: items,
      onSelect: (BuildContext context, int index) {
        tileMode = tileModes[index];
        print("$index, $tileMode");
        setState(() {});
      },
    );
  }
  showSheetBlendMode() {
    final blendModes = BlendMode.values;

    final items = blendModes.map((e) => Text('$e')).toList();

    showSheet(
      items: items,
      onSelect: (BuildContext context, int index) {
        blendMode = blendModes[index];
        print("$index, $blendMode");
        setState(() {});
      },
    );
  }

  showSheet({
    required List<Widget> items,
    required Function(BuildContext context, int index)? onSelect,
  }) {
    context.showCupertinoSheet(
      title: Text('渲染模式'),
      // message: Text(message, textAlign: TextAlign.start),
      items: items,
      cancel: Text('取消'),
      onSelect: onSelect,
    );
  }


  var _dropValue = AlignmentExt.allCases[0];
  var _radius = 0.5;

  _buildDropdownButton() {
    return DropdownButton<Alignment>(
      value: _dropValue,
      items: AlignmentExt.allCases.map((e) => DropdownMenuItem(
        child: Text(e.toString()),
        value: e,
      ),
      ).toList(),
      onChanged: (Alignment? value) {
        if (value == null) return;
        _dropValue = value;
        _radius = value.radiusOfRadialGradient(
          width: 400,
          height: 100,
        ) ?? 0.5;
        print("_dropValue:${value} scale:${_radius}");
        setState(() {});
      },
    );
  }


  _buildBody() {
    return ListView(children: <Widget>[
      buildTop(),
      SectionHeader.h4(title: 'LinearGradient',),
      _buildBox(
        text: '两种颜色 均分',
        decoration: BoxDecoration(
          color: Colors.red,
          gradient: LinearGradient(
            tileMode: this.tileMode,
            colors: [
              Color(0xFFFFC125),
              Color(0xFFFF7F24)
            ]
          )
        ),
      ),
      _buildBox(
        text: '多种颜色 均分',
        decoration: BoxDecoration(
          gradient: LinearGradient(
            tileMode: this.tileMode,
            colors: [
              Color(0xFFFFC125),
              Color(0xFFFF7F24),
              Color(0xFFFF4040)
            ]
          )
        ),
      ),
      _buildBox(
        text: '两种颜色 1:3',
        decoration: BoxDecoration(
          gradient: LinearGradient(
            tileMode: this.tileMode,
            colors: [
              Color(0xFFFFC125),
              Color(0xFFFF7F24),
              Color(0xFFFF7F24),
              Color(0xFFFF7F24)
            ]
          )
        ),
      ),

      _buildBox(
        text: '两种颜色 垂直均分 topRight',
        decoration: BoxDecoration(
          gradient: LinearGradient(
            tileMode: this.tileMode,
            begin: Alignment.topRight,
            colors: [
              Color(0xFFFFC125),
              Color(0xFFFF7F24)
            ]
          )
        )
      ),

      _buildBox(
        text: '两种颜色 前半部均分 延伸',
        decoration: BoxDecoration(
          gradient: LinearGradient(
            tileMode: this.tileMode,
            begin: Alignment(-1.0, 0.0),
            end: Alignment(0.0, 0.0),
            // tileMode: TileMode.clamp,
            colors: [
              Color(0xFFFFC125),
              Color(0xFFFF7F24)
            ]
          )
        )
      ),

      _buildBox(
        text: '两种颜色 均分 重复 repeated',
        decoration: BoxDecoration(
          gradient: LinearGradient(
            tileMode: this.tileMode,
            begin: Alignment(-1.0, 0.0),
            end: Alignment(0.0, 0.0),
            colors: [
              Color(0xFFFFC125),
              Color(0xFFFF7F24)
            ]
          )
        )
      ),

      _buildBox(
        text: '两种颜色 均分 mirror',
        decoration: BoxDecoration(
          gradient: LinearGradient(
            tileMode: this.tileMode,
            begin: Alignment(-1.0, 0.0),
            end: Alignment(0.0, 0.0),
            // tileMode: TileMode.mirror,
            colors: [
              Color(0xFFFFC125),
              Color(0xFFFF7F24)
            ]
          )
        )
      ),

      _buildBox(
        text: '两种颜色 设置起始位置与终止位置',
        decoration: BoxDecoration(
          gradient: LinearGradient(
            tileMode: this.tileMode,
            begin: Alignment.topLeft,
            end: Alignment(0.5, 0.0),
            // tileMode: TileMode.repeated,
            colors: [
              Color(0xFFFFC125),
              Color(0xFFFF7F24)
            ],
          )
        )
      ),

      _buildBox(
        text: '三种颜色 设置起始位置与终止位置',
        decoration: BoxDecoration(
          gradient: LinearGradient(
            tileMode: this.tileMode,
            // begin: Alignment.topLeft,
            // end: Alignment(0.5, 0.0),
            colors: const <Color>[
              Colors.red, // blue
              Colors.blue,
              Colors.yellow,
            ],
            stops: [0.0, 0.5, 0.8]
          )
        )
      ),
      Divider(),
      SectionHeader.h4(title: 'SweepGradient',),
      _buildBox(
        text: '四色 无 stops, 平均分布',
        decoration: BoxDecoration(
          gradient: SweepGradient(
            tileMode: this.tileMode,
            center: this._dropValue,
            startAngle: 0,
            endAngle: math.pi * 2,
            colors: const <Color>[
              Colors.red, // blue
              Colors.blue,
              Colors.yellow,
              Colors.green
            ],
            // stops: [0.0, 0.5, 0.8, 1]
          ),
        ),
      ),
      _buildBox(
        text: '四色 无 stops, stops: [0.25, 0.5, 0.75, 1]',
        decoration: BoxDecoration(
          gradient: SweepGradient(
            tileMode: this.tileMode,
            center: this._dropValue,
            startAngle: 0,
            endAngle: math.pi * 2,
            colors: const <Color>[
              Colors.red, // blue
              Colors.blue,
              Colors.yellow,
              Colors.green
            ],
            stops: [0.25, 0.5, 0.75, 1]
          ),
        ),
      ),
      _buildBox(
        text: '四色 startAngle: 0, endAngle: math.pi',
        decoration: BoxDecoration(
          gradient: SweepGradient(
            tileMode: this.tileMode,
            center: this._dropValue,
            // center: FractionalOffset.topRight,
            startAngle: 0,
            endAngle: math.pi,
            colors: const <Color>[
              Colors.red, // blue
              Colors.blue,
              Colors.yellow,
              Colors.green
            ],
            stops: [0.25, 0.5, 0.75, 1]
          ),
        ),
      ),
      Divider(),
      SectionHeader.h4(title: 'RadialGradient',),
      _buildBox(
        height: 100,
        text: 'RadialGradient',
        decoration: BoxDecoration(
          gradient: RadialGradient(
            tileMode: this.tileMode,
            // tileMode: TileMode.mirror,
            radius: _radius,
            center: _dropValue,
            colors: [
              Colors.red, // blue
              Colors.blue,
              Colors.yellow,
              Colors.green,
            ],
            stops: [0.1, 0.3, 0.6, 1],
          ),
        ),
      ),
      SectionHeader.h4(title: 'RadialGradient',),
      _buildBox(
        height: 300,
        text: 'RadialGradient',
        decoration: BoxDecoration(
          gradient: RadialGradient(
            tileMode: this.tileMode,
            // tileMode: TileMode.mirror,
            // radius: 0.5,
            // center: Alignment.center,
            colors: [
              Colors.red, // blue
              Colors.blue,
              Colors.yellow,
            ],
            stops: [0.0, 0.5, 0.8],
          ),
        ),
      ),
      Divider(),
      SectionHeader.h4(title: 'ShaderMask - RadialGradient',),
      _buildShaderMask(
        blendMode: BlendMode.color,
        shaderCallback: (Rect bounds) {
          return RadialGradient(
            tileMode: this.tileMode,
            radius: 0.5,
            colors: [Colors.red, Colors.blue],
          ).createShader(bounds);
        },
      ),
      _buildShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (Rect bounds) {
          return RadialGradient(
            tileMode: this.tileMode,
            radius: .6,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.grey.withOpacity(.7),
              Colors.grey.withOpacity(.7)
            ],
            stops: [0, .5, .5, 1],
          ).createShader(bounds);
        },
      ),
    ]);
  }

  Widget _buildBox({
    required String text,
    required Decoration decoration,
    double height: 100,
    double? width,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16.0)),
      margin: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
      decoration: decoration
    );
  }

  _buildShaderMask({
    required BlendMode blendMode,
    required ShaderCallback shaderCallback
  }) {
    return
      ShaderMask(
        shaderCallback: shaderCallback,
        blendMode: blendMode,
        child: Image.asset(
          'images/bg.jpg',
          fit: BoxFit.cover,
          height: 400,
        ),
      );
  }

  buildTop() {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              push(page: GradientOfRadialDemo());
            },
            child: Container(
                padding: EdgeInsets.all(8),
                child: Text("雷达渐进色深入研究",)
            )
        ),
      ],
    );
  }

  push({required Widget page}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return page;
        }
    ));
  }
}
