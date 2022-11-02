import 'package:flutter/material.dart';

class ModalBarrierDemo extends StatefulWidget {

  final String? title;

  ModalBarrierDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _ModalBarrierDemoState createState() => _ModalBarrierDemoState();
}

class _ModalBarrierDemoState extends State<ModalBarrierDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Center(
          child: Container(
            height: 100,
            width: 100,
            child: ModalBarrier(
              color: Colors.black.withOpacity(.4),
            ),
          ),
        )

    );
  }

}