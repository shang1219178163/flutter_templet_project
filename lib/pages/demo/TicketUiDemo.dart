//
//  TicketUiDemo.dart
//  flutter_templet_project
//
//  Created by shang on 1/19/23 5:03 PM.
//  Copyright © 1/19/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_dash_line.dart';
import 'package:flutter_templet_project/basicWidget/n_ticket_divider_painter.dart';

class TicketUiDemo extends StatefulWidget {
  const TicketUiDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TicketUiDemoState createState() => _TicketUiDemoState();
}

class _TicketUiDemoState extends State<TicketUiDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black.withValues(alpha: 0.1),
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Container(
                width: 300,
                height: 200,
                color: Colors.black.withValues(alpha: 0.1),
                child: CustomPaint(
                  painter: NTicketDividerPainter(
                    // borderColor: Colors.black.withValues(alpha: 0.5),
                    borderColor: Colors.red,
                    borderStrokeWidth: 1,
                    bgColor: Colors.transparent,
                    cutoutRadius: 15,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // 分割虚线
  Widget dashLine() {
    return Container(
      height: 3,
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: NDashLine(
        color: Colors.white,
        step: 6,
      ),
    );
  }

  Widget buildHeadder({
    String leftTitle = "DEA-HYD",
    String midTitle = "BH07",
    String rightTitle = "\$140",
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          midTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          rightTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget buildBodyRow1({
    String leftTitle = "May 30, 2022",
    String rightTitle = "May 30, 2022",
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftTitle,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 4, 0, 4),
          child: Icon(
            Icons.circle_outlined,
            size: 18,
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: dashLine(),
                  // child: CustomPaint(
                  //   painter: HorizontalDottedLinePainter(),
                  //   size: const Size(double.infinity, 1),
                  // ),
                ),
              ),
              const Center(
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.airplanemode_on_rounded,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 4, 8, 4),
          child: Icon(
            Icons.circle_outlined,
            size: 18,
          ),
        ),
        Text(
          rightTitle,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget buildBodyRow2({
    String leftTitle = "10:40AM",
    String midTitle = "1h 30m",
    String rightTitle = "12:50AM",
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          midTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          rightTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget buildFooter({
    String leftTitle = "Indigo",
    String midTitle = "",
    String rightTitle = "Cheapest",
  }) {
    return StatefulBuilder(builder: (context, setState) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            midTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withValues(alpha: 0.2),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              child: Text(
                rightTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
