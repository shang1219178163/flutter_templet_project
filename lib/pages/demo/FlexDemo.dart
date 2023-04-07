
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/header.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';

class FlexDemo extends StatefulWidget {

  const FlexDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _FlexDemoState createState() => _FlexDemoState();
}

class _FlexDemoState extends State<FlexDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: ListView(
        children: [
          Header.h4(title: 'Flex.Horizontal',),
          _buildFlexHorizontal(),
          Header.h4(title: 'Flex.Vertical',),
          _buildFlexVertical(),
          Header.h4(title: '_buildSection',),
          _buildSection(),
          Header.h4(title: '_buildSection2',),
          _buildSection2(),
          Header.h4(title: '_buildSection3',),
          _buildSection3(),
        ]
      )
    );
  }
  
  _buildSection() {
    return Container(
      // color: Colors.greenAccent,
      child: Row(
        children: <Widget>[
          Expanded (
            flex:1,
            child : Column(
              children: <Widget>[
                Text("Hello World")
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                Text("This is a long text this is a long test"*5)
              ],
            ),
          )
        ],
      ),
    );
  }


  _buildFlexHorizontal() {
    return Flex(
      direction: Axis.horizontal,   // this is unique
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      textDirection: TextDirection.rtl,
      children: [ColorExt.random, ColorExt.random, ColorExt.random].map((e) => Container(
        color: e,
        width: 50,
        height: 50,
      )).toList()
    );
  }

  _buildFlexVertical() {
    return Flex(
      direction: Axis.vertical,   // this is unique
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      textDirection: TextDirection.rtl,
      children: [ColorExt.random, ColorExt.random, ColorExt.random].map((e) => Container(
        color: e,
        width: 50,
        height: 50,
      )).toList()
    );
  }
  
  
  _buildSection2() {
    return Column(
      children:[
        Row(
          children:[
            buildExpanded(),
            buildFlexible(),
          ],
        ),
        Row(
          children:[
            buildExpanded(),
            buildExpanded(),
          ],
        ),
        Row(
          children:[
            buildFlexible(),
            SizedBox(width: 18,),
            buildFlexible(),
          ],
        ),
        Row(
          children:[
            buildExpanded(),
            buildFlexible(fit: FlexFit.tight),
          ],
        ),
      ],
    );
  }


  _buildSection3() {
    return Container(
      color: Colors.greenAccent,
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text("Hello World"),
              ElevatedButton(
                onPressed: () => debugPrint("OutlinedButton"),
                child: Text("OutlinedButton")
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.red,
              child: Column(
                children: <Widget>[
                  Text("占满剩余可用空间"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  buildExpanded() {
    return Expanded(
      child: Container(
        color: Colors.greenAccent,
        child: Text("Expanded"),
      ),
    );
  }

  buildFlexible({fit = FlexFit.loose}) {
    return Flexible(
      fit: fit,
      child: Container(
        color: Colors.yellowAccent,
        child: Text("Flexible - ${fit.toString().split(".").last}"),
      ),
    );
  }
}