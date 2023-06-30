

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_suspension.dart';

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

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
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
      ),
    );
  }

  buildBody() {
    return NSuspension(
      padding: EdgeInsets.only(left: 20, top: 30, right: 40, bottom: 50),
      childSize: Size(80, 80),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(8.w)),
        ),
      ),
      bgChild: Container(
        color: Colors.black.withOpacity(0.1), //Color.fromRGBO(242, 243, 248, 1),
      ),
    );

    return Stack(
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