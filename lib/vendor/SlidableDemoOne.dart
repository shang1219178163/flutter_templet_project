import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_templet_project/basicWidget/n_slidable_delete_cell.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';

class SlidableDemoOne extends StatefulWidget {
  SlidableDemoOne({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SlidableDemoOneState createState() => _SlidableDemoOneState();
}

class _SlidableDemoOneState extends State<SlidableDemoOne> {
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
      body: ListView.separated(
        itemCount: 9,
        itemBuilder: (context, int index) {
          final content = Container(
            height: 70,
            child: ListTile(
              title: Text("item_$index"),
            ),
          );

          if (index % 2 == 0) {
            return buildSlidable(
              disableVoice: false,
              disableRemove: false,
              isBan: false,
              onVoiceBan: () async {
                debugPrint("onVoiceBan");
              },
              onVoice: () async {
                debugPrint("onVoice");
              },
              onDelete: () async {
                debugPrint("onRemove");
              },
              child: content,
              indexValue: index,
            );
          }

          return NSlidableDeleteCell(
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              extentRatio: 0.4,
              children: [
                SlidableAction(
                  onPressed: (ctx) {
                    debugPrint("onPin");
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.push_pin,
                  label: '置顶',
                ),
                SlidableAction(
                  onPressed: (ctx) {
                    debugPrint("onDelete");
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: '删除',
                ),
              ],
            ),
            child: content,
          );
        },
        separatorBuilder: (context, int index) {
          return Divider(
            height: 1,
            color: Color(0xffe4e4e4),
          );
        },
      ),
    );
  }

  buildSlidable({
    required bool isBan,
    bool disableVoice = false,
    bool disableRemove = false,
    required VoidCallback? onVoiceBan,
    required VoidCallback? onVoice,
    required VoidCallback? onDelete,
    required Widget child,
    required int indexValue,
  }) {
    return Slidable(
      // controller: controller,
      key: ValueKey(indexValue),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.4,
        children: [
          Expanded(
            child: buildSlideAction(
              disable: disableVoice,
              title: isBan ? "取消禁言" : "禁言",
              imagePath: isBan ? "icon_member_voice.png" : "icon_member_voice_disable.png",
              bgColors: [
                const Color(0xff27BDCE),
                const Color(0xff2BCDAE),
              ],
              onTap: isBan ? onVoice : onVoiceBan,
            ),
          ),
          VerticalDivider(width: 1, color: Colors.white),
          Expanded(
            child: buildSlideAction(
              disable: disableRemove,
              title: "移出",
              imagePath: "icon_member_remove.png",
              bgColors: [
                const Color(0xffFF584C),
                const Color(0xffFFB07F),
              ],
              onTap: onDelete,
            ),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget buildSlideAction({
    required String title,
    required String imagePath,
    required List<Color> bgColors,
    List<Color> disbaleBgcolors = const [
      Color(0xff8999A9),
      Color(0xff5D6D7E),
    ],
    bool disable = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: disable ? null : onTap,
      child: Container(
        // width: 78,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: disable ? disbaleBgcolors : bgColors,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: imagePath.toAssetImage(),
              width: 24,
              height: 24,
            ),
            const SizedBox(
              height: 6,
            ),
            NText(
              title,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
