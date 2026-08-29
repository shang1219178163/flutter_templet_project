import 'package:flutter/material.dart';

class ModalBarrierDemo extends StatefulWidget {

  const ModalBarrierDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _ModalBarrierDemoState createState() => _ModalBarrierDemoState();
}

class _ModalBarrierDemoState extends State<ModalBarrierDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Center(
          child: Container(
            // height: 100,
            // width: 100,
            // child: ModalBarrier(
            //   color: Colors.black.withValues(alpha: .4),
            // ),
            child: buildModalBarrier(),
          ),
        ));
  }

  Widget buildModalBarrier() {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: Opacity(
            opacity: 0.3,
            child: const ModalBarrier(dismissible: false, color: Colors.grey),
          ),
        ),
        Center(
          child: Container(
            child: Text('Hello'),
          ),
        ),
      ],
    );
  }
}
