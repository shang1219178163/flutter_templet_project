import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/horizontal_cell.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/AppRes.dart';

class HorizontalCellDemo extends StatefulWidget {
  const HorizontalCellDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _HorizontalCellDemoState createState() => _HorizontalCellDemoState();
}

class _HorizontalCellDemoState extends State<HorizontalCellDemo> {
  var sliderVN = ValueNotifier(100.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$this"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: <Widget>[
          _buildSlider(),
          _buildCell(),
        ],
      ),
    );
  }

  /// 透明度滑动组件
  _buildSlider() {
    return Row(
      children: [
        Expanded(
          child: StatefulBuilder(builder: (context, setState) {
            return Slider(
              inactiveColor: Color(0xffC0C0C0),
              activeColor: Color(0xff21BA45),
              divisions: 100,
              //label: 'Admitida',
              value: sliderVN.value,
              min: 0.0,
              max: 100.0,
              onChanged: (double value) {
                sliderVN.value = value;
                setState(() {});
              },
            );
          }),
        ),
        ValueListenableBuilder(
            valueListenable: sliderVN,
            builder: (BuildContext context, double value, Widget? child) {
              final result = (value / 100).toStringAsFixed(2);
              return TextButton(
                onPressed: () {
                  debugPrint(result);
                },
                child: Text(result),
              );
            }),
      ],
    );
  }

  Text _buildText(String text) {
    return Text(text, style: TextStyle(fontSize: 16));
  }

  _buildCell() {
    return HorizontalCell(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          color: Colors.green,
        ),
        title: _buildText("title"),
        titleRight: _buildText("titleRight"),
        subtitle: _buildText("subtitle"),
        subtitleRight: _buildText("subtitleRight"),
        // titleSpace: Spacer(),
        // titleSpace: Container(
        //   height: 20,
        //   color: Colors.green,
        // ),
        // useIntrinsicHeight: false,
        left: FadeInImage(
          height: 60,
          image: NetworkImage(AppRes.image.urls[4]),
          placeholder: "img_placeholder.png".toAssetImage(),
        ),
        // mid: Container(
        //   width: 60,
        //   height: 60,
        //   color: Colors.blue,
        // ),
        right: Container(
          width: 60,
          height: 120,
          color: Colors.yellow,
        ),
        arrow: Container(
          // color: Colors.green,
          // padding: EdgeInsets.all(8),
          child: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
        ));
  }
}
