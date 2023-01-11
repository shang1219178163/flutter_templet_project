
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/HorizontalCell.dart';
import 'package:flutter_templet_project/uti/R.dart';



class HorizontalCellDemo extends StatefulWidget {

  HorizontalCellDemo({ Key? key, this.title}) : super(key: key);

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
            HorizontalCell(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.red),
                //   color: Colors.green,
                // ),
                title: _buildText("title"),
                titleRight: _buildText("titleRight"),
                subtitle: _buildText("subtitle"),
                subtitleRight: _buildText("subtitleRight"),
                // titleSpace: Container(
                //   height: 20,
                //   color: Colors.green,
                // ),
                icon: FadeInImage(
                  height: 60,
                  image: NetworkImage(R.image.imgUrls[4]),
                  placeholder: AssetImage("images/img_placeholder.png"),
                ),
                right: Container(
                  width: 60,
                  height: 60,
                  color: Colors.yellow,
                ),
                arrow: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Colors.grey
                  ),
                )
            ),
          ],
        ),
    );
  }

  /// 透明度滑动组件
  _buildSlider() {
    return Row(
      children: [
        Expanded(
          child: StatefulBuilder(
            builder: (context, setState) {
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
            }
          ),
        ),
        ValueListenableBuilder(
            valueListenable: sliderVN,
            builder: (BuildContext context, double value, Widget? child) {
              final result = (value/100).toStringAsFixed(2);
              return TextButton(
                onPressed: () { print(result); },
                child: Text(result),
              );
            }
        ),
      ],
    );
  }

  Text _buildText(String text) {
    return Text(text, style: TextStyle(fontSize: 16));
  }
}