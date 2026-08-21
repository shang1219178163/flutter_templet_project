import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/theme/AppThemeService.dart';

class ImageBlendModeDemo extends StatefulWidget {

  const ImageBlendModeDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _ImageBlendModeDemoState createState() => _ImageBlendModeDemoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _ImageBlendModeDemoState extends State<ImageBlendModeDemo> {
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          IconButton(
              onPressed: () {
                flag = !flag;
                setState(() {});
              },
              icon: Icon(Icons.change_circle_outlined))
        ],
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppThemeService().toggleTheme();
        },
        child: Icon(Icons.change_circle_outlined),
      ),
    );
  }

  Widget buildBody({
    int rowCount = 4,
    double spacing = 8,
    double runSpacing = 8,
  }) {
    var name = flag ? 'img_update.png' : 'img_flutter_3_10.png';

    // name = "img_sound_overlay_bg_recording.png";
    return Container(
      // color: Colors.black,
      padding: EdgeInsets.all(8),
      child: LayoutBuilder(builder: (context, constraints) {
        final itemWidth = ((constraints.maxWidth - spacing * (rowCount - 1)) / rowCount).truncateToDouble();

        return ListView(
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              children: BlendMode.values
                  .map((e) => Container(
                        child: Container(
                          // color: Colors.red,
                          width: itemWidth,
                          // height: itemWidth,
                          // decoration: BoxDecoration(
                          //   image: DecorationImage(
                          //     image: AssetImage(name.toPath()),
                          //     fit: BoxFit.scaleDown,
                          //     colorFilter: ColorFilter.mode(Colors.red, e),
                          //   ),
                          // ),
                          child: Column(
                            children: [
                              Image.asset(
                                name.toPath(),
                                color: Colors.grey,
                                colorBlendMode: e,
                              ),
                              FittedBox(
                                fit: BoxFit.none,
                                child: Text("$e".split('.')[1]),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        );
      }),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('flag', flag));
  }
}
