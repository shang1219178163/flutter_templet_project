import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/SectionHeader.dart';
import 'package:flutter_templet_project/extension/color_extension.dart';

class FlexDemo extends StatefulWidget {

  FlexDemo({ Key? key, this.title}) : super(key: key);

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
          SectionHeader.h4(title: 'Flex.Horizontal',),
          _buildFlexHorizontal(),
          SectionHeader.h4(title: 'Flex.Vertical',),
          _buildFlexVertical(),
          _buildSection(),
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
            flex :2,
            child: Column(
              children: <Widget>[
                Text("This is a long text this is a long test this is This is a long text this is a long test this is This is a long text this is a long test this is This is a long text this is a long test this is This is a long text this is a long test this is This is a long text this is a long test this is ")
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
}