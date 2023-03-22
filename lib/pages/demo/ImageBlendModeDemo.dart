import 'package:flutter/material.dart';


class ImageBlendModeDemo extends StatefulWidget {

  final String? title;

  ImageBlendModeDemo({ Key? key, this.title}) : super(key: key);


  @override
  _ImageBlendModeDemoState createState() => _ImageBlendModeDemoState();
}

class _ImageBlendModeDemoState extends State<ImageBlendModeDemo> {

  final blendModes = BlendMode.values;

  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          IconButton(
            onPressed: (){
              flag = !flag;
              setState(() {});
            },
            icon: Icon(Icons.change_circle_outlined)
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  _buildBody({
    int rowCount = 5,
    double spacing = 8,
    double runSpacing = 8,
  }) {
    var name = flag ? 'images/img_update.png' : 'images/flutter_logo.png';
    return Container(
      // color: Colors.black,
      padding: EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = ((constraints.maxWidth - spacing * (rowCount - 1)) / rowCount).truncateToDouble();

          return ListView(
            children: [
              Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                children: blendModes.map((e) => Container(
                  child: Container(
                    // color: Colors.red,
                    width: itemWidth,
                    child: Column(
                      children: [
                        Image.asset(
                          name,
                          color: Colors.grey,
                          colorBlendMode: e,
                        ),
                        FittedBox(
                          fit: BoxFit.none,
                          child: Text("${e}".split('.')[1]),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ],
          );
        }
      ),
    );
  }

}
