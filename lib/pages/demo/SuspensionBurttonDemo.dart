

import 'package:flutter/material.dart';

class SuspensionBurttonDemo extends StatefulWidget {

  SuspensionBurttonDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _SuspensionBurttonDemoState createState() => _SuspensionBurttonDemoState();
}

class _SuspensionBurttonDemoState extends State<SuspensionBurttonDemo> {


  final _topVN = ValueNotifier(0.0);
  final _leftVN = ValueNotifier(0.0);


  late final screenSize = MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

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
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Stack(
          // alignment: Alignment.topLeft,
          // fit: StackFit.expand,
          children: [
            Container(
              color: Color.fromRGBO(
                  93, 91, 90, 1
              ), //Color.fromRGBO(242, 243, 248, 1),
            ),
            buildSuspension(),
          ],
        ),
      ),
    );
  }

  buildSuspension() {
    return AnimatedBuilder(
        animation: Listenable.merge([
          _topVN,
          _leftVN,
        ]),
        builder: (context, child) {

          return Positioned(
              top: _topVN.value,
              left: _leftVN.value,
              child: GestureDetector(
                onTap: () {
                  debugPrint("onTap");
                },
                onPanUpdate: (DragUpdateDetails e) {
                  debugPrint("e.delta:${e.delta.dx},${e.delta.dy}");

                  //用户手指滑动时，更新偏移，重新构建
                  if (_topVN.value < 0 && e.delta.dy < 0) {
                    return;
                  }
                  if (_leftVN.value < 0 && e.delta.dx < 0) {
                    return;
                  }

                  if (_topVN.value > (screenSize.height - 100 - kToolbarHeight) && e.delta.dy > 0) {
                    return;
                  }

                  if (_leftVN.value > (screenSize.width - 100) && e.delta.dx > 0) {
                    return;
                  }
                  _topVN.value += e.delta.dy;
                  _leftVN.value += e.delta.dx;
                  debugPrint("xy:${_leftVN.value},${_topVN.value}");
                },
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                ),
              )
          );
        }
    );
  }
}