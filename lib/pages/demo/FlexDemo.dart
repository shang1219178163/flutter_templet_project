
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/header.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';

class FlexDemo extends StatefulWidget {

  const FlexDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _FlexDemoState createState() => _FlexDemoState();
}

class _FlexDemoState extends State<FlexDemo> {

  ValueNotifier<bool> showTips = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ListView(
          children: [
            NHeader.h4(title: 'Flex.Horizontal',),
            _buildFlexHorizontal(),
            NHeader.h4(title: 'Flex.Vertical',),
            _buildFlexVertical(),
            NHeader.h4(title: '_buildSection',),
            _buildSection(),
            NHeader.h4(title: '_buildSection2',),
            _buildSection2(),
            NHeader.h4(title: '_buildSection3',),
            _buildSection3(),
            NHeader.h4(title: 'tips',),
            buildTipsWidget(showTips: showTips, tips: "这是一个提示信息或者警告⚠️"),
          ]
        ),
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


  /// 问诊倒计时显示器 Widget
  Widget buildTipsWidget({
    double? preferredSizeHeight,
    required ValueNotifier<bool> showTips,
    required String tips,
  }) {
    Widget child = Container(
      height: 44,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 17, right: 7),
      color: Color(0xffEDEDED).withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xffe5e5e5),
            ),
          ),
          Container(
            height: 32,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 17, right: 7),
            decoration: BoxDecoration(
              color: const Color(0xffEBF8F8),
              borderRadius: BorderRadius.circular(18), //边角
            ),
            child: Flexible(
              child: NText(tips,
                fontSize: 13,
                color: primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xffe5e5e5),
            ),
          ),
        ],
      ),
    );

    child = ValueListenableBuilder<bool>(
        valueListenable: showTips,
        child: child,
        builder: (context, value, child) {
          if (!value) {
            preferredSizeHeight = 0;
            return const SizedBox();
          }
          return child!;
        });

    if (preferredSizeHeight != null) {
      child = PreferredSize(
        preferredSize: Size.fromHeight(preferredSizeHeight!),
        child: child,
      );
    }
    return child;
  }
}