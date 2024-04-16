

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_long_press_menu.dart';

import 'package:flutter_templet_project/basicWidget/n_target_follower.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:tuple/tuple.dart';

class NTargetFollowerDemo extends StatefulWidget {

  NTargetFollowerDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _NTargetFollowerDemoState createState() => _NTargetFollowerDemoState();
}

class _NTargetFollowerDemoState extends State<NTargetFollowerDemo> {

  final _scrollControlller = ScrollController();

  late final items = <Tuple2<String, String>>[
    Tuple2("复制", "icon_copy.png",),
    // Tuple2("引用", "icon_quote.png",),
    Tuple2("撤回", "icon_revoke.png",),

    // Tuple2("复制", "icon_copy.png"),
    // Tuple2("引用", "icon_quote.png"),
    // Tuple2("撤回", "icon_revoke.png"),
    // Tuple2("复制", "icon_copy.png"),
    // Tuple2("引用", "icon_quote.png"),
  ];

  final List<OverlayEntry> entries = [];

  VoidCallback? _onHide;

  @override
  void initState() {
    _scrollControlller.addListener(() {
      _onHide?.call();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _onHide?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody()
    );
  }

  buildBody() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollControlller,
              child: ListView.separated(
                controller: _scrollControlller,
                itemCount: 20,
                itemBuilder: (context, i) {

                  return Container(
                    height: 75,
                    child: ListTile(
                      title: Text("row_$i"*20),
                      trailing: i%3 != 0 ? null : NTargetFollower(
                        targetAnchor: Alignment.topRight,
                        followerAnchor: Alignment.bottomRight,
                        entries: entries,
                        offset: Offset(0, -8),
                        onLongPressEnd: (e){

                        },
                        target: OutlinedButton(
                          onPressed: (){
                            debugPrint("button_$i");
                          },
                          // child: Text("button_$i"*3),
                          child: Text("b_$i"),
                        ),
                        followerBuilder: (context, onHide) {
                          _onHide = onHide;

                          debugPrint("${DateTime.now()} followerBuilder:");
                          return TapRegion(
                            onTapInside: (tap) {
                              debugPrint('On Tap Inside!!');
                            },
                            onTapOutside: (tap) {
                              debugPrint('On Tap Outside!!');
                              onHide();
                            },
                            child: NLongPressMenu(
                              items: items.map((e) => Tuple2(e.item1, e.item2.toAssetImage())).toList(),
                              onItem: (Tuple2<String, AssetImage> t) {
                                onHide();
                                debugPrint("onChanged_$t");
                                ToastUtil.show(t.item1);
                                switch (t.item1) {
                                  case "复制":
                                    {
                                    }
                                    break;
                                  case "引用":
                                    {

                                    }
                                    break;
                                  case "撤回":
                                    {
                                    }
                                    break;
                                  default:
                                    break;
                                }
                              }
                            ),
                          );
                          return buildFollowerDefault(onHide: onHide, index: i);
                        }
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, i) {
                  return Divider(height: 1,);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildFollowerDefault({required VoidCallback onHide, required int index}) {
    return Container(
      // width: 200,
      // height: 100,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      constraints: BoxConstraints(
        maxWidth: 300,
        minWidth: 0,
      ),
      child: Wrap(
        children: List.generate((index/3).toInt() + 1, (i) => i).map((e) {
          return OutlinedButton(
            onPressed: (){
              debugPrint("button_$e");
              if (e == 2) {
                onHide();
              }
            },
            child: Text("button_$e"),
          );
        }).toList(),
      ),
    );
  }

  buildFollower({
    required List<Tuple2<String, String>> items,
    required ValueChanged<Tuple2<String, String>> onChanged,
  }) {
    return Container(
      // width: 200,
      // height: 100,
      padding: EdgeInsets.only(top: 14, right: 20, bottom: 12, left: 20),
      decoration: BoxDecoration(
        color: Color(0xff4d4d4d),
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(4.r)),
      ),
      constraints: BoxConstraints(
        maxWidth: 300,
        minWidth: 0,
      ),
      child: Wrap(
        spacing: 34,
        runSpacing: 16,
        children: items.map((e) {

          final child = NPair(
            direction: Axis.vertical,
            icon: Image(
              image: e.item2.toAssetImage(),
              width: 18,
              height: 18,
              fit: BoxFit.fill,
            ),
            child: NText(e.item1,
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          );

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (){
                onChanged(e);
              },
              child: child,
            ),
          );
        }).toList(),
      ),
    );
  }

  onCopy(String val) {
    debugPrint("${DateTime.now()}: $val");
  }

  onRevoke(String val) {
    debugPrint("${DateTime.now()}: $val");
  }

  onQuote(String val) {
    debugPrint("${DateTime.now()}: $val");
  }
}