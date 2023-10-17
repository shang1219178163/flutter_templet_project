

import 'package:flutter/material.dart';

class AnimatedSizeDemoOne extends StatefulWidget {

  AnimatedSizeDemoOne({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _AnimatedSizeDemoOneState createState() => _AnimatedSizeDemoOneState();
}

class _AnimatedSizeDemoOneState extends State<AnimatedSizeDemoOne> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );


  @override
  void initState() {
    super.initState();

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.horizontal,
      axisAlignment: -1,
      child: const Center(
        child: FlutterLogo(size: 200.0),
      ),
    );
  }

}