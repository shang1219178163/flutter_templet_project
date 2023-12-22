import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NSectionHeader.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/alignment_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/mixin/bottom_sheet_mixin.dart';
import 'package:flutter_templet_project/pages/demo/GradientOfRadialDemo.dart';
import 'package:tuple/tuple.dart';

class GradientDemo extends StatefulWidget {
  final String? title;

  const GradientDemo({Key? key, this.title}) : super(key: key);

  @override
  _GradientDemoState createState() => _GradientDemoState();
}

class _GradientDemoState extends State<GradientDemo> with BottomSheetMixin {
  
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
    const tileModes = TileMode.values;
    final items = tileModes.map((e) => Text('$e')).toList();

    showSheet(
      items: items,
      onSelected: (int index) {
        tileMode = tileModes[index];
        debugPrint("$index, $tileMode");
        setState(() {});
      },
    );
  }
  showSheetBlendMode() {
    const blendModes = BlendMode.values;

    final items = blendModes.map((e) => Text('$e')).toList();

    showSheet(
      items: items,
      onSelected: (int index) {
        blendMode = blendModes[index];
        debugPrint("$index, $blendMode");
        setState(() {});
      },
    );
  }

  showSheet({
    required List<Widget> items,
    required ValueChanged<int>? onSelected,
  }) {
    presentCupertinoActionSheet(
      context: context,
      title: Text('渲染模式'),
      // message: Text(message, textAlign: TextAlign.start),
      items: items,
      cancel: Text('取消'),
      onSelected: onSelected,
    );
  }


  var _dropValue = AlignmentExt.allCases[0];
  var _radius = 0.5;

  _buildDropdownButton() {
    return DropdownButton<Alignment>(
      value: _dropValue,
      items: AlignmentExt.allCases.map((e) => DropdownMenuItem(
        value: e,
        child: Text(e.toString()),
      ),
      ).toList(),
      onChanged: (Alignment? value) {
        if (value == null) return;
        _dropValue = value;
        _radius = value.radiusOfRadialGradient(
          width: 400,
          height: 100,
        ) ?? 0.5;
        debugPrint("_dropValue:$value scale:$_radius");
        setState(() {});
      },
    );
  }


  _buildBody() {
    return ListView(children: <Widget>[
      buildTop(),
      NHeader.h4(title: 'LinearGradient',),
      _buildBox(
        text: '两种颜色 均分',
        decoration: BoxDecoration(
          color: Colors.red,
          gradient: LinearGradient(
            tileMode: tileMode,
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
            tileMode: tileMode,
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
            tileMode: tileMode,
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
            tileMode: tileMode,
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
            tileMode: tileMode,
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
            tileMode: tileMode,
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
            tileMode: tileMode,
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
            tileMode: tileMode,
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
            tileMode: tileMode,
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
      NHeader.h4(title: 'SweepGradient',),
      _buildBox(
        text: '四色 无 stops, 平均分布',
        decoration: BoxDecoration(
          gradient: SweepGradient(
            tileMode: tileMode,
            center: _dropValue,
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
            tileMode: tileMode,
            center: _dropValue,
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
            tileMode: tileMode,
            center: _dropValue,
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
      NHeader.h4(title: 'RadialGradient',),
      _buildBox(
        height: 100,
        text: 'RadialGradient',
        decoration: BoxDecoration(
          gradient: RadialGradient(
            tileMode: tileMode,
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
      NHeader.h4(title: 'RadialGradient',),
      _buildBox(
        height: 300,
        text: 'RadialGradient',
        decoration: BoxDecoration(
          gradient: RadialGradient(
            tileMode: tileMode,
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
      NHeader.h4(title: 'ShaderMask - RadialGradient',),
      _buildShaderMask(
        blendMode: BlendMode.color,
        shaderCallback: (Rect bounds) {
          return RadialGradient(
            tileMode: tileMode,
            radius: 0.5,
            colors: [Colors.red, Colors.blue],
          ).createShader(bounds);
        },
      ),
      _buildShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (Rect bounds) {
          return RadialGradient(
            tileMode: tileMode,
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
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildGradientText(
          const Offset(0, 40),
          const Offset(150, 40),
          <Color>[
            Colors.red,
            Colors.yellow,
          ])
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildGradientText(
            const Offset(0, 40),
            const Offset(40, 100),
            <Color>[
            Colors.red,
            Colors.yellow,
          ])
        ),
    ]);
  }

  Widget _buildBox({
    required String text,
    required Decoration decoration,
    double height = 60,
    double? width,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
      decoration: decoration,
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16.0)),
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
        child: Image(
          image: 'bg_jiguang.png'.toAssetImage(),
          fit: BoxFit.cover,
          height: 300,
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

  buildGradientText(
    Offset from,
    Offset to,
    List<Color> colors, [
    List<double>? colorStops,
    TileMode tileMode = TileMode.clamp,
  ]
  ) {
    return Text(
      '如果设置的比较多可以封装组件widget，根据组件context获取位置大小;'*16,
      maxLines: 13,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: TextStyle(
          fontSize: 16,
          foreground: Paint()
            ..shader = ui.Gradient.linear(
                from,
                to,
                colors,
                colorStops,
                tileMode,
                )
      ),
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
