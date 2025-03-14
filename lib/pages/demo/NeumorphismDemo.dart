import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/neumorphism_button.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class NeumorphismDemo extends StatefulWidget {
  const NeumorphismDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _NeumorphismDemoState createState() => _NeumorphismDemoState();
}

class _NeumorphismDemoState extends State<NeumorphismDemo> {
  final icons = [
    Icon(
      Icons.skip_previous,
      color: ColorExt.random,
    ),
    Icon(
      Icons.play_arrow,
      color: ColorExt.random,
    ),
    Icon(
      Icons.skip_next,
      color: ColorExt.random,
    ),
    Icon(
      Icons.shuffle_rounded,
      color: ColorExt.random,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Center(
        child: SizedBox(
            // width: 450,
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Neumorphism',
              style: TextStyle(
                  fontSize: 22, letterSpacing: 5, fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: icons
                  .map((e) => NeumorphismButton.icon(
                        onClick: () => debugPrint('${e.icon}'),
                        child: Icon(e.icon ?? Icons.check, color: Colors.blue),
                      ))
                  .toList(),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBtn(),
                NeumorphismButton.icon(
                  borderRadius: 12,
                  onClick: () => debugPrint('bookmark'),
                  child: Icon(Icons.bookmark, color: Color(0XFF5081ff)),
                ),
                NeumorphismButton.icon(
                  borderRadius: 12,
                  onClick: () => debugPrint('favorite'),
                  child: Icon(Icons.favorite, color: Color(0XFFec7cda)),
                ),
              ],
            ),
            const Divider(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: icons
                  .map((e) => NeumorphismButton(
                        width: 50,
                        height: 50,
                        onClick: () => debugPrint('${e.icon}'),
                        child: e,
                      ))
                  .toList(),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NeumorphismButton(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  onClick: () => debugPrint('Share'),
                  // borderRadius: 12,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.share,
                          color: ColorExt.random,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text("Share"),
                      ]),
                ),
                NeumorphismButton(
                  height: 50,
                  width: 50,
                  borderRadius: 12,
                  onClick: () => debugPrint('bookmark'),
                  child: Icon(Icons.bookmark, color: Colors.blue),
                ),
                NeumorphismButton(
                  height: 50,
                  width: 50,
                  borderRadius: 12,
                  onClick: () => debugPrint('NeumorphismButton'),
                  child: Icon(Icons.favorite, color: Colors.red),
                ),
              ],
            ),
            const Divider(
              height: 50,
            ),
          ],
        )),
      ),
    );
  }

  _buildBtn() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E5EC),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(Icons.share),
            SizedBox(
              width: 12,
            ),
            Text("Share")
          ]),
    ).toNeumorphism(
        bottomShadowColor: const Color(0xFFA3B1C6),
        topShadowColor: Colors.white);
  }
}
