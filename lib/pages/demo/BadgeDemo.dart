import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_badge.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

class BadgeDemo extends StatefulWidget {
  BadgeDemo({super.key, this.title});

  final String? title;

  @override
  State<BadgeDemo> createState() => _BadgeDemoState();
}

class _BadgeDemoState extends State<BadgeDemo> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => debugPrint(e),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                NSectionBox(
                  title: "Badge",
                  mainAxisSize: MainAxisSize.min,
                  child: Badge(
                    // offset: Offset(4, -6),
                    backgroundColor: Colors.red,
                    label: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: NText(
                        "99+",
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    child: buildImage(),
                  ),
                ),
                NSectionBox(
                  title: "NBadge",
                  mainAxisSize: MainAxisSize.min,
                  child: NBadge(
                    value: 111,
                    top: -8,
                    child: buildImage(),
                  ),
                ),
                NSectionBox(
                  title: "Banner",
                  mainAxisSize: MainAxisSize.min,
                  child: Banner(
                    message: 'Offer 20% off',
                    location: BannerLocation.topEnd,
                    color: Colors.red,
                    child: buildImage(),
                  ),
                ),
                NSectionBox(
                  title: "RotatedCorner",
                  mainAxisSize: MainAxisSize.min,
                  child: Container(
                    foregroundDecoration: RotatedCornerDecoration.withGradient(
                      badgePosition: BadgePosition.topEnd,
                      // color: Colors.black87,
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue, Colors.lightGreenAccent],
                      ),
                      badgeSize: Size(54, 54),
                      spanBaselineShift: 2,
                      textSpan: TextSpan(
                        children: [
                          TextSpan(
                            text: 'LOREM\n',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                          TextSpan(
                            text: 'IPSUM',
                            style: TextStyle(
                              fontSize: 7,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 5,
                              color: Colors.yellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: buildImage(),
                  ),
                ),
                NSectionBox(
                  title: "buildBadge",
                  mainAxisSize: MainAxisSize.min,
                  child: buildBadge(),
                ),
              ]
                  .map((e) => Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        child: e,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return Container(
      height: 120,
      child: Image.network(
        'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg',
        fit: BoxFit.cover,
      ),
    );
  }

  /// 自定义红色角标
  buildCustomBadge({
    required String badge,
    TextStyle? textStyle,
    double minWidth = 20,
  }) {
    return SizedOverflowBox(
      alignment: Alignment.center,
      size: Size.zero,
      child: UnconstrainedBox(
        child: Container(
          constraints: BoxConstraints(
            minHeight: minWidth,
            minWidth: minWidth,
          ),
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: Colors.red,
            shape: StadiumBorder(),
          ),
          child: Text(
            badge,
            style: textStyle ??
                TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }

  var badge = 9;

  Widget buildBadge() {
    var width = 60.0;
    var height = 60.0;
    // var size = 20.0;

    var badgeStr = badge > 99 ? "$badge+" : "$badge";
    return InkWell(
      onTap: () {
        badge = badge < 999 ? badge * 10 : 9;
        setState(() {});
      },
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.topRight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          image: DecorationImage(
            image: ExtendedNetworkImageProvider(
              AppRes.image.urls[7],
              cache: true,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: buildCustomBadge(badge: badgeStr),
      ),
    );
  }
}
