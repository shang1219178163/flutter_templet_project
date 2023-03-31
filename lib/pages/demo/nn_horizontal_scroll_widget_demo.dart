import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/nn_horizontal_scroll_widget.dart';
import 'package:flutter_templet_project/uti/R.dart';


class NNHorizontalScrollWidgetDemo extends StatefulWidget {

  const NNHorizontalScrollWidgetDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _NNHorizontalScrollWidgetDemoState createState() => _NNHorizontalScrollWidgetDemoState();
}

class _NNHorizontalScrollWidgetDemoState extends State<NNHorizontalScrollWidgetDemo> {
  List<String> imgUrls = R.image.urls;

  var _items = <AttrCarouseItem>[];

  @override
  void initState() {
    // TODO: implement initState
    _items = List.generate(imgUrls.length, (index) => AttrCarouseItem(
        icon: imgUrls[index],
        title: "标题_$index"
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => debugPrint(e.toString()),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              _buildAnimatedBuilder(),
            ],
          )
        ]
      ),
    );
  }
  /// 多值监听
  Widget _buildAnimatedBuilder() {
    return NNHorizontalScrollWidget(
      items: _items,
    );
  }

}



