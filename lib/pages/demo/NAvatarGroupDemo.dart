import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_avatar_group.dart';
import 'package:flutter_templet_project/basicWidget/n_remind_group.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/dlog.dart';

class NAvatarGroupDemo extends StatefulWidget {
  NAvatarGroupDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<NAvatarGroupDemo> createState() => _NAvatarGroupDemoState();
}

class _NAvatarGroupDemoState extends State<NAvatarGroupDemo> {
  final _scrollController = ScrollController();

  late final screenSize = MediaQuery.of(context).size;

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
                avatars: AppRes.image.urls.sublist(0, 9),
                itemWidth: 50,
                scale: 35 / 50,
              ),

              buildRemindBox(),
              //   buildAvatarGroup(countCb: (count) => 5),
              //   buildAvatarGroup(),
              //   Container(
              //     width: 150,
              //     child: buildAvatarGroup(),
              //   ),
              //   Row(
              //     children: [
              //       buildGroupAvatar(urls: AppRes.image.urls.sublist(0, 4)),
              //       SizedBox(width: 16),
              //       buildGroupAvatar(urls: []),
              //     ],
              //   ),
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
    var urls = AppRes.image.urls;
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

  /// 聊天群组头像
  Widget buildGroupAvatar({required List<String> urls, int max = 9, AssetImage? placeholder}) {
    final width = 124.0;
    final height = 124.0;
    final rowCount = 3;
    final spacing = 1.0;
    final itemWidth = ((width - spacing * (rowCount - 1) * rowCount) / rowCount).truncateToDouble();
    final itemHeight = ((height - spacing * (rowCount - 1) * rowCount) / rowCount).truncateToDouble();
    final avatars = urls.sublist(0, urls.length.clamp(0, max));

    var content = urls.isEmpty
        ? Image(
            image: placeholder ?? AssetImage("assets/images/img_placeholder_patient.png"),
          )
        : Wrap(
            spacing: spacing,
            runSpacing: spacing,
            alignment: WrapAlignment.center,
            children: [
              // ...avatars.map((e) => NNetworkImage(
              //       url: e,
              //       width: itemWidth,
              //       height: itemHeight,
              //       fit: BoxFit.fill,
              //       radius: 0,
              //     )),
              ...avatars.map((e) => CachedNetworkImage(
                    imageUrl: e,
                    width: itemWidth,
                    height: itemHeight,
                    fit: BoxFit.fill,
                  )),
            ],
          );

    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blue, width: spacing),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: content,
    );
  }

  var isFirst = true;

  Widget buildRemindBox() {
    final list = <String>[
      " 2004年大楼开幕时，法国蜘蛛人亚伦·罗伯特就曾受邀攀爬，但回看那次营销，处处透着那个年代的保守与谨慎。",
      "当时台北阴雨绵绵，罗伯特被要求必须绑上绳索，在风雨中磨蹭了四个小时才登顶，是场安全第一的表演秀。",
      "而2026年的这一次，霍诺德则是以绝对孤独、无任何保护措施的方式，完成了人类史上首次对这座垂直城市的徒手挑战。",
      "对于霍诺德而言，台北101甚至算不上他职业生涯中最难的挑战，这位2017年徒手攀爬美国优胜美地国家公园900米酋长岩的奇人，早已习惯了与死神贴身共舞。",
      "但对101大楼来说，这更像是一场对抗遗忘的豪赌，地面指挥中心里，有一个女人的呼吸频率恐怕要比攀爬者本人还要快。",
      "她就是贾永婕，这位台北101董事长经历的是另一场职场徒手攀爬，2024年9月上任不满一个月时，她就拍板“这件事一定要做”，为此面临极大的内部反对声浪与外界各路质疑。",
      "关于这场豪赌，贾永婕心里很清楚，如果霍诺德在全球镜头前发生意外，她不仅会丢掉董事长宝座，更可能面临毁灭性舆论风暴。",
      "但她依然霸气地对外表示：若最坏情况真的发生，“就是我来扛”。哪怕被骂到翻、最后必须滚蛋，也要拼这一次。",
      "91分30秒后，霍诺德安全落地，贾永婕在指挥中心长舒一口气，随后在IG发文：成功！我要退休了！",
      " 她赌赢了。",
    ];
    return NRemindGroup(
      items: list,
      itemCb: (e) => e,
      isFirst: isFirst,
      maxWidth: screenSize.width - 32 * 2,
      onChanged: (value) {
        DLog.d(value);
      },
    );
  }
}
