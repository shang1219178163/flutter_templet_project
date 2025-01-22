import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_avatar_group.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/util/R.dart';

class NAvatarGroupDemo extends StatefulWidget {
  NAvatarGroupDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<NAvatarGroupDemo> createState() => _NAvatarGroupDemoState();
}

class _NAvatarGroupDemoState extends State<NAvatarGroupDemo> {
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("层叠头像组件"),
              NAvatarGroup(
                avatars: List.generate(avatarsMax, (index) => "").toList(),
                itemWidth: 50,
                scale: 35 / 50,
              ),
              buildAvatarGroup(countCb: (count) => 5),
              buildAvatarGroup(),
              Container(
                width: 150,
                child: buildAvatarGroup(),
              ),
            ]
                .map((e) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      child: e,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildAvatarGroup({int Function(int length)? countCb}) {
    var urls = R.image.urls;
    if (countCb != null) {
      urls = urls.sublist(0, countCb(urls.length));
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final scale = (constraints.maxWidth - 50) / urls.length / 50;
        DLog.d("constraints.maxWidth: ${constraints.maxWidth.toStringAsFixed(2)}, scale: $scale");
        return NAvatarGroup(
          avatars: urls,
          itemWidth: 50,
          itemPadding: EdgeInsets.zero,
          scale: scale.clamp(0.01, 0.5),
          isRevered: false,
        );
      },
    );
  }
}
