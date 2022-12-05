import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/SectionHeader.dart';

class GradientDemo extends StatefulWidget {
  final String? title;

  GradientDemo({Key? key, this.title}) : super(key: key);

  @override
  _GradientDemoState createState() => _GradientDemoState();
}

class _GradientDemoState extends State<GradientDemo> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildBody()
    );
  }

  _buildBody() {
    return ListView(children: <Widget>[
      SectionHeader.h2(title: 'LinearGradient',),
      _buildBox(
        text: '两种颜色 均分',
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFFFFC125), Color(0xFFFF7F24)]
            )
        ),
      ),
      _buildBox(
          text: '多种颜色 均分',
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFFFC125), Color(0xFFFF7F24), Color(0xFFFF4040)]
              )
          ),
      ),
      _buildBox(
          text: '两种颜色 1:3',
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFFFC125), Color(0xFFFF7F24), Color(0xFFFF7F24), Color(0xFFFF7F24)]
              )
          ),
      ),

      _buildBox(
          text: '两种颜色 垂直均分',
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  colors: [Color(0xFFFFC125), Color(0xFFFF7F24)]
              )
          )
      ),

      _buildBox(
          text: '两种颜色 前半部均分 延伸',
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment(-1.0, 0.0),
                  end: Alignment(0.0, 0.0),
                  tileMode: TileMode.clamp,
                  colors: [Color(0xFFFFC125), Color(0xFFFF7F24)]
              )
          )
      ),

      _buildBox(
          text: '两种颜色 均分 重复',
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment(-1.0, 0.0),
                  end: Alignment(0.0, 0.0),
                  tileMode: TileMode.repeated,
                  colors: [Color(0xFFFFC125), Color(0xFFFF7F24)]
              )
          )
      ),

      _buildBox(
          text: '两种颜色 均分 镜面反射',
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment(-1.0, 0.0),
                  end: Alignment(0.0, 0.0),
                  tileMode: TileMode.mirror,
                  colors: [Color(0xFFFFC125), Color(0xFFFF7F24)]
              )
          )
      ),

      _buildBox(
          text: '两种颜色 设置起始位置与终止位置',
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.5, 0.0),
                  tileMode: TileMode.repeated,
                  colors: [Color(0xFFFFC125), Color(0xFFFF7F24)]
              )
          )
      ),
      Divider(),
      SectionHeader.h2(title: 'SweepGradient',),
      _buildBox(
          text: '两种颜色 设置起始位置与终止位置',
          decoration: BoxDecoration(
            gradient: SweepGradient(
                center: AlignmentDirectional(1, -1),
                startAngle: 1.7,
                endAngle: 3,
                colors: const <Color>[
                  Color(0xFF148535),
                  Color(0xFF148535),
                  Color(0XFF0D6630),
                  Color(0XFF0D6630),
                  Color(0xFF148535),
                  Color(0xFF148535),
                ],
                stops: const <double>[0.0,0.3,0.3,0.7,0.7,1.0]
            ),
          ),
      ),
      _buildBox(
        text: '两种颜色 设置起始位置与终止位置',
        decoration: BoxDecoration(
          gradient: SweepGradient(
            center: FractionalOffset.topRight,
            startAngle: 2,
            endAngle: 5,
            colors: const <Color>[
              // Colors.red, // blue
              // Colors.blue,
              // Colors.yellow,
              Color(0xffBE965A),
              Color(0xffD4BB86),
            ],
            stops: const <double>[0.0, 0.5],
          ),
        ),
      ),
    ]);
  }

  Widget _buildBox({
    required String text,
    required Decoration decoration,
  }) {
    return Container(
        height: 360.0,
        alignment: Alignment.center,
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16.0)),
        margin: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
        decoration: decoration);
  }
}
