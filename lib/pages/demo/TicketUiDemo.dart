//
//  TicketUiDemo.dart
//  flutter_templet_project
//
//  Created by shang on 1/19/23 5:03 PM.
//  Copyright © 1/19/23 shang. All rights reserved.
//



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/TicketUI.dart';


import 'package:flutter/material.dart';

class TicketUiDemo extends StatefulWidget {

  TicketUiDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TicketUiDemoState createState() => _TicketUiDemoState();
}

class _TicketUiDemoState extends State<TicketUiDemo> {

  int _count = 6;
  double _spacing = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$this"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => print("done"),),
        ).toList(),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView.separated(
              itemCount: _count,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: _spacing);
              },
              itemBuilder: (_, index) {
                var margin = EdgeInsets.symmetric(horizontal: _spacing);
                if (index == 0) {
                  margin = margin.copyWith(top: _spacing,);
                } else if (index == _count - 1) {
                  margin = margin.copyWith(bottom: _spacing,);
                }

                return Container(
                  height: 190,
                  margin: margin,
                  width: constraints.maxWidth,
                  child: CustomPaint(
                    painter: TicketPainter(
                      borderColor: Colors.black.withOpacity(0.5),
                      borderStrokeWidth: 1,
                      bgColor: Colors.blue.withOpacity(0.5),
                      cornerRadius: 15,
                      cutoutRadius: 15,
                    ),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          // color: Colors.green.withOpacity(0.7),
                          child: Column(
                            children: [
                              _buildHeadder(),
                              const SizedBox(height: 16),
                              _buildBodyRow1(),
                              _buildBodyRow2(),
                              const Spacer(),
                              _buildFooter(),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                );
              },
            );
          }
        ),
      ),
    );
  }

  // 分割虚线
  Widget _dashLine() {
    return Container(
      height: 3,
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: DashLine(
        color: Colors.white,
        dashHeight: 4,
        dashWidth: 6,
      ),
    );
  }

  _buildHeadder({
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

  _buildBodyRow1({
    String leftTitle = "May 30, 2022",
    String midTitle = "",
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
                    child: _dashLine(),
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


  _buildBodyRow2({
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


  _buildFooter({
    String leftTitle = "Indigo",
    String midTitle = "",
    String rightTitle = "Cheapest",
  }) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
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
                color: Colors.black.withOpacity(0.2),
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
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
      }
    );
  }

}