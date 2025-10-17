//
//  FlexibleSpaceDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2/14/23 6:16 PM.
//  Copyright © 2/14/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/theme/AppThemeService.dart';
import 'package:flutter_templet_project/basicWidget/n_flexible_space_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

class FlexibleSpaceDemo extends StatefulWidget {
  const FlexibleSpaceDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _FlexibleSpaceDemoState createState() => _FlexibleSpaceDemoState();
}

class _FlexibleSpaceDemoState extends State<FlexibleSpaceDemo> {
  @override
  Widget build(BuildContext context) {
    return buildPage();

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "FlexibleSpace",
              style: TextStyle(color: Colors.black),
            ),
            // collapseMode: CollapseMode.pin,
            background: Image.network(
                "https://p3-passport.byteimg.com/img/user-avatar/af5f7ee5f0c449f25fc0b32c050bf100~180x180.awebp",
                fit: BoxFit.cover),
            stretchModes: [
              // StretchMode.fadeTitle,
              // StretchMode.blurBackground,
              StretchMode.zoomBackground
            ],
          ),
        ),
        body: buildBody());
  }

  buildBody() {
    return ListView(
      children: List.generate(20, (i) => i).map((e) {
        return ListTile(
          title: NText("index_$e"),
        );
      }).toList(),
    );
  }

  buildPage() {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    var appBarColor = Theme.of(context).appBarTheme.backgroundColor;
    var appBarTextColor = Theme.of(context).appBarTheme.titleTextStyle?.color;

    final textColor = isDark ? appBarTextColor : Color(0xff262626);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            iconTheme: isDark ? null : IconThemeData(color: textColor),
            titleTextStyle: TextStyle(color: textColor),
            centerTitle: false,
            expandedHeight: 120.0,
            scrolledUnderElevation: 0.5,
            flexibleSpace: NFlexibleSpaceBar(
              centerTitle: false,
              expandedTitleScale: 2,
              titleIconBuilder: (t) => Container(
                color: Colors.green,
                width: 17,
                height: 17,
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  "全部数据",
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ),
              fixedSubtitle: Text(
                "全部数据",
                style: TextStyle(fontSize: 12),
              ),
              //伸展处布局
              titlePadding: const EdgeInsets.only(left: 20, bottom: 10),
              //标题边距
              collapseMode: CollapseMode.parallax,
            ),
            elevation: 0,
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
              IconButton(
                onPressed: () {
                  AppThemeService().toggleTheme();
                },
                icon: Icon(Icons.change_circle_outlined),
              ),
            ],
          ),
          SliverList.separated(
            itemBuilder: (context, int index) {
              return Container(
                height: 70,
                // color: ColorExt.random,
                child: ListTile(
                  title: Text("index_$index"),
                ),
              );
            },
            separatorBuilder: (context, int index) {
              return Divider(
                height: 1,
              );
            },
          )
        ],
      ),
    );
  }
}
