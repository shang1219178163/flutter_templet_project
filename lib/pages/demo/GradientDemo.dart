import 'package:flutter/material.dart';

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
      )
    ]);
  }

  Widget _buildBox({
    required String text,
    required Decoration decoration,
  }) {
    return Container(
        height: 60.0,
        alignment: Alignment.center,
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16.0)),
        margin: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
        decoration: decoration);
  }
}
