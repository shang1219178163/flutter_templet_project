import 'package:flutter/material.dart';

class ModalBarrierDemo extends StatefulWidget {
  final String? title;

  const ModalBarrierDemo({Key? key, this.title}) : super(key: key);

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
            //   color: Colors.black.withOpacity(.4),
            // ),
            child: _buildModalBarrier(),
          ),
        ));
  }

  Widget _buildModalBarrier() {
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
