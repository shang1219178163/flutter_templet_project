import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/CircleSectorProgressIndicator.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';

class ProgressClipperDemo extends StatefulWidget {
  ProgressClipperDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<ProgressClipperDemo> createState() => _ProgressClipperDemoState();
}

class _ProgressClipperDemoState extends State<ProgressClipperDemo> {
  final _scrollController = ScrollController();

  final progressVN = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: onPressed,
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  // buildProgress(),
                  GestureDetector(
                    onTap: onPressed,
                    child: CircleSectorProgressIndicator(
                      width: 100,
                      height: 120,
                      progressVN: progressVN,
                      child: ValueListenableBuilder(
                        valueListenable: progressVN,
                        builder: (context, value, child) {
                          if (value == 1.0) {
                            return Image(
                              image: "assets/images/bg_mk11.jpg".toAssetImage(),
                              width: 16,
                              height: 16,
                              fit: BoxFit.fill,
                            );
                          }

                          return Image(
                            image: "assets/images/bg_mk11.jpg".toAssetImage(),
                            width: 16,
                            height: 16,
                            fit: BoxFit.fill,
                          );
                          return FlutterLogo();
                        },
                      ),
                    ),
                  ),
                  RotatingCircularProgress(),
                  buildPrentProgressIndicator(percent: 0.77),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onPressed() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      final tmp = progressVN.value + 0.1;
      if (tmp >= 0.99) {
        progressVN.value = 0.0;
        timer.cancel();
      } else {
        progressVN.value = tmp;
      }
    });
  }

  Widget buildProgress({double width = 120, double height = 160}) {
    return ValueListenableBuilder(
      valueListenable: progressVN,
      builder: (context, value, child) {
        debugPrint("value: $value");
        final precent = (value * 100).toInt().toStringAsFixed(0);
        final precentStr = "$precent%";

        return Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/bg.png',
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
            ClipPath(
              clipper: CircleSectorProgressClipper(
                progress: value,
              ),
              child: Container(
                width: width,
                height: height,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            Positioned(
              child: Text(
                precentStr,
                style: TextStyle(color: Color(0xffEDFBFF), fontSize: 24),
              ),
            )
          ],
        );
      },
    );
  }

  Widget buildPrentProgressIndicator({
    required double percent,
    double size = 50,
    double strokeWidth = 4,
    Color color = AppColor.cancelColor,
    Color backgroundColor = AppColor.bgColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform(
            transform: Matrix4.rotationY(pi),
            alignment: Alignment.center,
            child: SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                color: color,
                value: percent,
                strokeWidth: strokeWidth,
                backgroundColor: backgroundColor,
                strokeCap: StrokeCap.square,
              ),
            ),
          ),
          Text(
            "${(percent * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}

class RotatingCircularProgress extends StatefulWidget {
  const RotatingCircularProgress({super.key});

  @override
  State<RotatingCircularProgress> createState() => _RotatingCircularProgressState();
}

class _RotatingCircularProgressState extends State<RotatingCircularProgress> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blue),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = NCircularProgress(
            percent: 0.77,
            strokeWidth: 12,
          );
          return progress;

          return Transform.rotate(
            angle: _controller.value * 2 * pi, // Rotate whole indicator
            child: progress,
          );
        },
      ),
    );
  }
}

class NCircularProgress extends StatelessWidget {
  const NCircularProgress({
    super.key,
    this.strokeWidth = 10,
    this.percent = 1,
    this.child,
  });

  final double strokeWidth;

  /// 0- 1
  final double percent;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final val = (percent.clamp(0, 1) * 100).toStringAsFixed(1);
    final percentStr = "$val%\n完成率";

    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: NCircularProgressPainter(
            percent: percent,
            strokeWidth: strokeWidth,
          ),
        ),
        Positioned(
          top: strokeWidth,
          right: strokeWidth,
          left: strokeWidth,
          bottom: strokeWidth,
          child: Container(
            alignment: Alignment.center,
            // decoration: BoxDecoration(
            //   color: Colors.transparent,
            //   border: Border.all(color: Colors.blue),
            // ),
            child: child ??
                Text(
                  percentStr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}

class NCircularProgressPainter extends CustomPainter {
  NCircularProgressPainter({
    this.strokeWidth = 10,
    this.gradient = const SweepGradient(
      startAngle: 0.2,
      // endAngle: 1.8 * pi + 0.2,
      endAngle: 2 * pi,
      colors: [
        Colors.yellow,
        Colors.red,
      ],
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp,
    ),
    this.percent = 1,
  });

  final SweepGradient gradient;
  final double strokeWidth;

  /// 0- 1
  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    // final strokeWidth = 10.0;
    final radius = (min(size.width, size.height) - strokeWidth) / 2;

    // const startAngle = 0.2; //-pi / 2; // Start from top
    // const sweepAngle = pi * 1.7 + 0.2; //1.8 * pi; // ¾ circle

    // Gradient from green (start) to white (end)
    // final gradient = SweepGradient(
    //   startAngle: startAngle,
    //   endAngle: sweepAngle,
    //   colors: [
    //     Colors.white, // End White
    //     Colors.green, // Start Green
    //   ],
    //   stops: const [0.0, 1.0], // Smooth transition
    //   tileMode: TileMode.clamp, // Avoids unwanted repetition
    // );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      gradient.startAngle,
      // (gradient.endAngle - gradient.startAngle) * percent,
      pi * 2 * percent,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
