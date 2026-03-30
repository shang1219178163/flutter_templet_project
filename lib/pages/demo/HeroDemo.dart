import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/util/AppRes.dart';

class HeroDemo extends StatefulWidget {
  HeroDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<HeroDemo> createState() => _HeroDemoState();
}

class _HeroDemoState extends State<HeroDemo> {
  final scrollController = ScrollController();

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

  buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeroImage(),
          ],
        ),
      ),
    );
  }

  Widget buildHeroImage() {
    final urls = AppRes.image.urls.sublist(0, 10);
    return Container(
      // alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      child: Column(
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) {
              var spacing = 8.0;
              var runSpacing = 8.0;

              final rowCount = 2;
              final itemWidth = ((constraints.maxWidth - spacing * (rowCount - 1)) / rowCount).truncateToDouble();

              return Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                children: urls.map((e) {
                  final name = e.split("/").last;
                  final heroTag = name;

                  final child = Container(
                    width: itemWidth,
                    height: itemWidth * 1.5,
                    child: NPair(
                      direction: Axis.vertical,
                      isReverse: true,
                      icon: Text(name),
                      child: NNetworkImage(
                        url: e,
                        width: itemWidth,
                        height: itemWidth * 1.5,
                      ),
                    ),
                  );

                  return InkWell(
                    onTap: () {
                      onDetailPage(heroTag: heroTag, child: child);
                    },
                    child: Hero(
                      tag: heroTag, //唯一标记，前后两个路由页Hero的tag必须相同
                      child: child,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  onDetailPage({
    required String heroTag,
    required Widget child,
  }) {
    pushPage(
      page: HeroAnimationDetailPage(
        heroTag: heroTag,
        child: child,
      ),
    );
  }

  pushPage({
    required Widget page,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(opacity: animation, child: page);
        },
      ),
    );
  }
}

class HeroAnimationDetailPage extends StatelessWidget {
  const HeroAnimationDetailPage({
    super.key,
    required this.heroTag,
    required this.child,
  });

  final String heroTag;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag, //唯一标记，前后两个路由页Hero的tag必须相同
      child: Scaffold(
        appBar: AppBar(
          title: const Text("详情页"),
          // leading: SizedBox(),
        ),
        body: Container(
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
