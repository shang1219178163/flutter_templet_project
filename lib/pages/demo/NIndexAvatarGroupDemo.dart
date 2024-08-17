import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_Index_avatar_group.dart';

class NIndexAvatarGroupDemo extends StatefulWidget {
  NIndexAvatarGroupDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<NIndexAvatarGroupDemo> createState() => _NIndexAvatarGroupDemoState();
}

class _NIndexAvatarGroupDemoState extends State<NIndexAvatarGroupDemo> {
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
    final doctorNum = 10;
    final avatarsMax = doctorNum > 3 ? 3 : doctorNum;

    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Text("层叠头像组件"),
            NIndexAvatarGroup(
              avatars: List.generate(avatarsMax, (index) => "").toList(),
              itemWidth: 50,
              scale: 35 / 50,
            ),
            SizedBox(
              height: 12,
            ),
            NIndexAvatarGroup(
              // avatars: List.generate(avatarsMax, (index) => "").toList(),
              avatars: [
                "https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/beta/Health_APP/20231219/e0a448a8201c47ed8bd46cf1ec6fe1af.jpg",
                "https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/beta/Health_APP/20231219/56415da814454ddcb8ed83608f471619.jpg",
                "https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/beta/Health_APP/20231219/3dc1b7f4e3b94a99bc5de47f3836ec96.jpg"
              ],
              itemWidth: 50,
              scale: 30 / 50,
              isRevered: true,
            ),
          ],
        ),
      ),
    );
  }
}
