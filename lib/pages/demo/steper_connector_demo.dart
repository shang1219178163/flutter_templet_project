//
//  SteperConnectorDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/16/21 1:49 PM.
//  Copyright © 12/16/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/steper_connector.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';
import 'package:timelines/timelines.dart';

class SteperConnectorDemo extends StatefulWidget {
  final String? title;

  SteperConnectorDemo({Key? key, this.title}) : super(key: key);

  @override
  _SteperConnectorDemoState createState() => _SteperConnectorDemoState();
}

class _SteperConnectorDemoState extends State<SteperConnectorDemo> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: _buildBody(),
      //   body: _buildBodyColumn(),
    );
  }

  _buildBody() {
    return ListView(
      children: [


        TimelineTile(
          oppositeContents: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('opposite\ncontents'),
          ),
          contents: Card(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Text('contents'*10),
            ),
          ),
          node: TimelineNode(
            indicator: DotIndicator(),
            startConnector: SolidLineConnector(),
            endConnector: SolidLineConnector(),
          ),
        ),


        Container(
          color: Colors.green,
          child: NNTimelineTile(
            direction: Axis.vertical,
            oppositeContents: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('opposite\ncontents'),
            ),
            contents: Card(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Text('contents'*10),
              ),
            ),
            node: TimelineNode(
              indicator: DotIndicator(),
              startConnector: SolidLineConnector(),
              endConnector: SolidLineConnector(),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.yellow,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('12月9日\n10: 53'),
                  ),
                ),

                _buildNode(
                  startConnector: Container(
                    color: Colors.green,
                    width: 5,
                    // height: 60,
                  ),
                  endConnector: Container(
                    color: Colors.green,
                    width: 5,
                    // height: 60,
                  ),
                ),

                _buildVerticalRight(),
              ]
            ),
          ],
        ),
      ]
    );
  }



  _buildBodyColumn() {
    return Column(
        children: [
      Container(
        color: Colors.yellow,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('12月9日\n10: 53'),
        ),
      ),
      _buildNode(
        direction: Axis.horizontal,
        startConnector: Container(
          color: Colors.green,
          height: 5,
        ),
        endConnector: Container(
          color: Colors.green,
          height: 5,
        ),
      ),
      _buildVerticalRight(),
    ]);
  }

  _buildBodyRow() {
    return Row(
        children: [
          Container(
            color: Colors.yellow,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('12月9日\n10: 53'),
            ),
          ),
          _buildNode(
            direction: Axis.vertical,
            startConnector: Container(
              color: Colors.green,
              width: 5,
              height: double.infinity,
            ),
            endConnector: Container(
              color: Colors.green,
              width: 5,
              height: double.infinity,
            ),
          ),
          _buildVerticalRight(),
        ]);
  }

  _buildHorizontal() {
    return Row(children: [
      SteperConnector(
        direction: Axis.vertical,
        space: 5,
        child: Container(
          color: Colors.red,
          height: 50,
        ),
      ),
      Container(
        color: Colors.green,
        width: 50,
        height: 59,
      ),
      SteperConnector(
        direction: Axis.vertical,
        space: 5,
        child: Container(
          color: Colors.red,
          width: 50,
          height: 59,
        ),
      ),
    ]);
  }

  _buildNode({
    Axis direction = Axis.vertical,
    Widget? startConnector,
    Widget? endConnector}){

    final indicator = Container(
      color: Colors.green,
      width: 30,
      height: 30,
    );

    final kFlexMultiplier = 1000;
    final indicatorFlex = 0.5;

    Widget line = indicator;
    final lineItems = [
      if (indicatorFlex > 0)
        Flexible(
          flex: (indicatorFlex * kFlexMultiplier).toInt(),
          child: startConnector ?? Container(),
        ),
      indicator,
      if (indicatorFlex < 1)
        Flexible(
          flex: ((1 - indicatorFlex) * kFlexMultiplier).toInt(),
          child: endConnector ?? Container(),
        ),
    ];

    switch (direction) {
      case Axis.vertical:
        line = Column(
          mainAxisSize: MainAxisSize.min,
          children: lineItems,
        );
        break;
      case Axis.horizontal:
        line = Row(
          mainAxisSize: MainAxisSize.min,
          children: lineItems,
        );
        break;
    }
    return line;
  }

  _buildVertical() {
    return Column(
      children: [
        Center(
          child: Container(
            color: Colors.red,
            width: 5,
            height: 25
          ),
        ),
        // SteperConnector(
        //   direction: Axis.horizontal,
        //   space: 5,
        //   child: Container(
        //     color: Colors.red,
        //     width: 5,
        //   ),
        // ),
        Container(
          color: Colors.green,
          width: 30,
          height: 30,
        ),
        SteperConnector(
          direction: Axis.horizontal,
          space: 5,
          child: Container(
            color: Colors.red,
            width: 5,
            // height: 59,
          ),
        ),
      ],
    );
  }

  _buildVerticalRight() {
    return Expanded(
      child: Card(
        // color: Colors.yellow,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('${model.title}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${DateTime.now()}'),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      // minimumSize: Size.zero,
                      // padding: EdgeInsets.all(8),
                      shape: StadiumBorder(
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                    onPressed: () {
                      ddlog("onPressed");
                    },
                    child: Text('查看'),
                  ),
                ],
              ),
              Text('【青岛即墨】日日顺小哥: 【常盼盼】 【13698658853】 正在为您派件，感澍您的耐心e待'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 60,
                    width: 100,
                    // color: Colors.green,
                    child: Image.asset("images/img_404.png"),
                  ),
                  Container(
                    height: 60,
                    width: 100,
                    // color: Colors.green,
                    child: Image.asset("images/img_404.png"),
                  ),
                  TextButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.all(5),
                    ),
                    onPressed: () {
                      ddlog("onPressed");
                    },
                    child: Text(
                      '更多',
                      style: TextStyle(
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
