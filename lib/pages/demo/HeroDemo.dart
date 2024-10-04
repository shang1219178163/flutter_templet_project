import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/R.dart';

class HeroDemo extends StatefulWidget {
  HeroDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<HeroDemo> createState() => _HeroDemoState();
}

class _HeroDemoState extends State<HeroDemo> {
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

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            buildHeroImage(),
          ],
        ),
      ),
    );
  }

  Widget buildHeroImage() {
    final heroTag = "avatar";

    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            double spacing = 8;
            double runSpacing = 8;

            final rowCount = 4;
            final itemWidth =
                ((constraints.maxWidth - spacing * (rowCount - 1)) / rowCount)
                    .truncateToDouble();

            return Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              children: R.image.urls.map((e) {
                final child = NNetworkImage(
                  url: e,
                );

                return InkWell(
                  onTap: () {
                    goDetailPage(heroTag: heroTag, child: child);
                  },
                  child: Hero(
                    tag: heroTag, //唯一标记，前后两个路由页Hero的tag必须相同
                    child: SizedBox(
                      width: itemWidth,
                      height: itemWidth,
                      child: child,
                    ),
                  ),
                );
              }).toList(),
            );
          }),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text("点击"),
          )
        ],
      ),
    );
  }

  goDetailPage({
    required String heroTag,
    required Widget child,
  }) {
    //打开B路由
    pushPage(
      page: HeroAnimationDetailPage(
        heroTag: heroTag,
        onTap: () {
          Navigator.of(context).pop();
        },
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
    this.onTap,
    required this.child,
  });

  final String heroTag;
  final VoidCallback? onTap;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("详情页"),
        leading: SizedBox(),
      ),
      body: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          child: Hero(
            tag: heroTag, //唯一标记，前后两个路由页Hero的tag必须相同
            child: child,
          ),
        ),
      ),
    );
  }
}
