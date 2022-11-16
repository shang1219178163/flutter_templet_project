import 'dart:math' as math;
import 'package:flutter/material.dart';

class BuilderDemo extends StatefulWidget {

  final String? title;

  BuilderDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _BuilderDemoState createState() => _BuilderDemoState();
}

class _BuilderDemoState extends State<BuilderDemo> with TickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildBody(),
    );
  }

  _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
    );
  }

  _buildBox(String title) {
    return Container(
      width: 150.0,
      height: 50.0,
      color: Colors.green,
      child: Center(
        child: Text(title),
      ),
    );
  }

  _buildBody() {
    return Column(
      children: [
        _buildSectionTitle('AnimatedBuilder'),
        AnimatedBuilder(
          animation: _controller,
          child: _buildBox('AnimatedBuilder'),
          builder: (BuildContext context, Widget? child) {
            return Transform.rotate(
              angle: _controller.value * 2.0 * math.pi,
              child: child,
            );
          },
        ),

        Divider(),
        _buildSectionTitle('Builder/约等于 StatelessWidget'),
        Builder(builder: (BuildContext context) {
          return _buildBox('Builder');
        }),

        Divider(),
        _buildSectionTitle('StatefulBuilder/约等于 StatefulWidget'),
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return _buildBox('StatefulBuilder');
        }),
      ],
    );
  }
}