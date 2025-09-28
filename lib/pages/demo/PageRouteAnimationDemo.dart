//
//  PageRouteAnimationDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/22 20:12.
//  Copyright © 2025/1/22 shang. All rights reserved.
//

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/Pages/second_page.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/util/Resource.dart';
import 'package:get/get.dart';

class PageRouteAnimationDemo extends StatefulWidget {
  const PageRouteAnimationDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<PageRouteAnimationDemo> createState() => _PageRouteAnimationDemoState();
}

class _PageRouteAnimationDemoState extends State<PageRouteAnimationDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final items = ["Hero路由动画"];

  @override
  void didUpdateWidget(covariant PageRouteAnimationDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final list = Resource.image.urls;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              ...items.map((e) => Text(e)),
            ],
          ),
        ),
        Expanded(
          child: GridView.count(
            padding: EdgeInsets.all(15.0),
            crossAxisCount: 2,
            scrollDirection: Axis.vertical,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 3 / 4,
            children: [
              ...list.map((e) {
                final i = list.indexOf(e);
                return _NOpenContainer<bool>(
                  openBuilder: (BuildContext _, VoidCallback openContainer) {
                    return SecondPage();
                  },
                  closedBuilder: (BuildContext _, VoidCallback openContainer) {
                    return buildCard(
                      onTap: openContainer,
                      url: e,
                      title: 'title $i',
                      subtitle: 'subtitle',
                    );
                  },
                  onClosed: (isMarkedAsDone) {
                    DLog.d("isMarkedAsDone: $isMarkedAsDone");
                    if (isMarkedAsDone ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Marked as done!'),
                      ));
                    }
                  },
                );
              })
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCard({
    required VoidCallback onTap,
    required String url,
    required String title,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GridTile(
        footer: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: Colors.blue),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
              ),
              Text(
                subtitle,
              ),
            ],
          ),
        ),
        child: Container(
          // decoration: BoxDecoration(
          // border: Border.all(color: Colors.blue),
          // ),
          child: NNetworkImage(
            url: url,
            width: 64,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: Colors.black38,
            height: 150,
            child: Center(
              child: Image.asset(
                'assets/images/img_placeholder_doctor.png',
                width: 80,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NOpenContainer<T> extends StatelessWidget {
  const _NOpenContainer({
    super.key,
    required this.openBuilder,
    required this.closedBuilder,
    this.transitionType = ContainerTransitionType.fadeThrough,
    required this.onClosed,
  });

  final OpenContainerBuilder<T> openBuilder;

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<T?> onClosed;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<T>(
      transitionType: transitionType,
      openBuilder: openBuilder,
      onClosed: onClosed,
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}
