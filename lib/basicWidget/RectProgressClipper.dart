

import 'dart:math';
import 'package:flutter/material.dart';

class RectProgressIndicator extends StatelessWidget {

  RectProgressIndicator({
    Key? key,
    required this.width,
    required this.height,
    required this.progressVN,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.child,
  }) : super(key: key);


  final double width;
  final double height;

  final ValueNotifier<double> progressVN;

  final BorderRadius? borderRadius;

  final Widget? child;


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: progressVN,
        child: child,
        builder: (context, value, child){

          debugPrint("value: $value");
          final precent = (value * 100).toInt().toStringAsFixed(0);
          var precentStr = "$precent%";
          if (precent == "0") {
            precentStr = "加载中";
          }

          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: width,
                  height: height,
                  child: child ?? FlutterLogo(),
                ),
                ClipPath(
                  clipper: RectProgressClipper(
                    progress: value,
                  ),
                  child: Container(
                    width: width,
                    height: height,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                Positioned(
                  child: Text(
                    precentStr,
                    style: TextStyle(
                      color: Color(0xffEDFBFF),
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }

}

class RectProgressClipper extends CustomClipper<Path> {
  final double progress;

  RectProgressClipper({this.progress=0});

  @override
  Path getClip(Size size) {
    if(progress == 0){
      return Path();
    }
    var rect = Rect.fromPoints(
      Offset.zero,
      Offset(size.width, size.height * (1 - progress)),
    );

    var path = Path()..addRect(rect);
    return path;
  }

  @override
  bool shouldReclip(covariant RectProgressClipper oldClipper) {
    return progress != oldClipper.progress;
  }
}
