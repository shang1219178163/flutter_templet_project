import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_sliding_segmented_control/en_sliding_segmented_control.dart';
import 'package:flutter_templet_project/basicWidget/enhance/en_sliding_segmented_control/n_sliding_segmented_control.dart';
import 'package:flutter_templet_project/basicWidget/n_chrome_segment.dart';
import 'package:flutter_templet_project/basicWidget/n_line_segment_view.dart';
import 'package:flutter_templet_project/basicWidget/n_list_view_segment_control.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

class SegmentedControlDemo extends StatefulWidget {
  SegmentedControlDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SegmentedControlDemoState createState() => _SegmentedControlDemoState();
}

class _SegmentedControlDemoState extends State<SegmentedControlDemo> {
  int groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        bottom: buildPreferredSize(),
      ),
      body: buildListView(),
    );
  }

  PreferredSizeWidget buildPreferredSize() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 48),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 24),
            Expanded(
              child: CupertinoSegmentedControl(
                children: const <int, Widget>{
                  0: Padding(padding: EdgeInsets.all(8.0), child: Text('Midnight', style: TextStyle(fontSize: 15))),
                  1: Padding(padding: EdgeInsets.all(8.0), child: Text('Viridian', style: TextStyle(fontSize: 15))),
                  2: Padding(padding: EdgeInsets.all(8.0), child: Text('Cerulean', style: TextStyle(fontSize: 15)))
                },
                groupValue: groupValue,
                onValueChanged: (value) {
                  DLog.d(value.runtimeType);
                  DLog.d(value.toString());
                  setState(() {
                    groupValue = int.parse("$value");
                  });
                },
                borderColor: Colors.white,

                //   selectedColor: Colors.redAccent,
                // unselectedColor: Colors.green,
              ),
            ),
            SizedBox(width: 24)
          ],
        ),
      ),
    );
  }

  Widget buildListView() {
    return ListView(
      children: [
        SizedBox(height: 15),
        buildSegmentedControl(),

        SizedBox(height: 15),
        buildSlidingSegmentedControl(),

        SizedBox(height: 15),
        buildSlidingSegmentedControl2(),

        SizedBox(height: 15),
        buildSlidingSegmentedControlNew(),

        SizedBox(height: 15),
        buildSegmentedControlNew(
          radius: Radius.circular(24),
          padding: EdgeInsets.all(4),
          onChanged: (int index) {
            DLog.d("index: $index");
          },
        ),

        NSectionBox(
          title: "NSlidingSegmentedControl",
          crossAxisAlignment: CrossAxisAlignment.stretch,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.green,
              // border: Border.all(color: Colors.blue),
              // borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: NSlidingSegmentedControl(
              items: <({String title, String icon})>[
                (
                  title: "医生",
                  icon: "icon_segmented_control_doctor_gray.png",
                ),
                (
                  title: "健管师",
                  icon: "icon_segmented_control_carer_gray.png",
                ),
              ],
              selectedIndex: 1,
              onChanged: (int index) {
                DLog.d("onChanged: $index");
              },
              itemBuilder: (({String icon, String title}) e, bool isSelecetd) {
                final color = isSelecetd ? Colors.white : Color(0xff737373);
                final icon = isSelecetd ? e.icon : e.icon;

                return Container(
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    // border: Border.all(color: Colors.blue),
                    // borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Image(
                            image: icon.toAssetImage(),
                            width: 12,
                            height: 14,
                            color: color,
                          ),
                        ),
                      if (e.title.isNotEmpty)
                        Flexible(
                          child: Text(
                            e.title,
                            style: TextStyle(
                              fontSize: 14,
                              color: color,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        NSectionBox(
          title: "NChromeSegment",
          crossAxisAlignment: CrossAxisAlignment.stretch,
          child: buildChromeSegment(),
        ),

        SizedBox(height: 15),
        buildSlidingSegmentedControl3(),

        SizedBox(height: 15),
        buildLineSegmentControl(null, lineColor: Theme.of(context).primaryColor),

        SizedBox(height: 15),
        buildLineSegmentControl(Colors.transparent, lineColor: Theme.of(context).primaryColor),

        SizedBox(height: 15),
        buildLineSegmentControl(Colors.black87, lineColor: Colors.white),

        SizedBox(height: 15),
        buildLineSegmentControl(Colors.white, lineColor: Colors.transparent),

        SizedBox(height: 15),
        buildListViewHorizontal(),

        SizedBox(height: 15),
        buildListViewHorizontal1(),

        // Switch(value: value, onChanged: onChanged)
      ],
    );
  }

  final Map<int, Widget> children = <int, Widget>{
    0: Container(
      padding: EdgeInsets.all(8),
      child: Text("Item 1", style: TextStyle(fontSize: 15, color: Colors.black)),
    ),
    1: Container(
      padding: EdgeInsets.all(8),
      child: Text("Item 2", style: TextStyle(fontSize: 15, color: Colors.black)),
    ),
    2: Container(
      padding: EdgeInsets.all(8),
      child: Text("Item 3", style: TextStyle(fontSize: 15, color: Colors.black)),
    ),
  };

  Widget buildSegmentedControl() {
    return CupertinoSegmentedControl<int>(
      children: children,
      onValueChanged: (int newValue) {
        setState(() {
          groupValue = newValue;
        });
        DLog.d(groupValue);
      },
      groupValue: groupValue,
      // borderColor: Colors.white,
    );
  }

  Widget buildSlidingSegmentedControl() {
    const children = <int, Widget>{
      0: Text(
        "Item 1",
        style: TextStyle(fontSize: 15),
      ),
      1: Text(
        "Item 2",
        style: TextStyle(fontSize: 15),
      ),
      2: Text(
        "Item 3",
        style: TextStyle(fontSize: 15),
      ),
    };

    return CupertinoSlidingSegmentedControl(
      groupValue: groupValue,
      children: children,
      onValueChanged: (i) {
        setState(() {
          groupValue = int.parse("$i");
        });
        DLog.d(groupValue);
      },
      backgroundColor: Colors.transparent,
      thumbColor: Colors.transparent,
    );
  }

  Widget buildSlidingSegmentedControlNew() {
    final items = <({
      String title,
      IconData icon,
    })>[
      (
        title: "选项 1",
        icon: Icons.ac_unit,
      ),
      (
        title: "选项 2",
        icon: Icons.abc,
      ),
      (
        title: "选项 3",
        icon: Icons.access_alarm,
      ),
    ];

    var current = items[0];

    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Container(
        // height: 56,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green,
          // border: Border.all(color: Colors.blue),
          // borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        child: ENCupertinoSlidingSegmentedControl<
            ({
              String title,
              IconData icon,
            })>(
          groupValue: current,
          // children: children,
          children: Map<
              ({
                String title,
                IconData icon,
              }),
              Widget>.fromIterable(
            items,
            key: (v) => v,
            value: (val) {
              final e = val as ({
                String title,
                IconData icon,
              });

              final isSelecetd = current == val;
              final color = isSelecetd ? Colors.white : Colors.black54;
              final icon = isSelecetd ? e.icon : e.icon;

              return Container(
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        icon,
                        color: color,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        e.title,
                        style: TextStyle(
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          onValueChanged: (val) {
            if (val == null) {
              return;
            }
            current = val;
            setState(() {});
            DLog.d(current);
          },
          backgroundColor: Color(0xfff3F3F3),
          thumbColor: context.primaryColor,
          radius: Radius.circular(16),
          padding: EdgeInsets.all(2),
        ),
      );
    });
  }

  Widget buildSegmentedControlNew({
    Color? textColor,
    Color? thumbTextColor,
    Color? backgroundColor,
    Color? thumbColor,
    Radius? radius,
    EdgeInsets? padding,
    required ValueChanged<int> onChanged,
  }) {
    final items = <({
      String title,
      String icon,
    })>[
      (
        title: "医生",
        icon: "icon_segmented_control_doctor_gray.png",
      ),
      (
        title: "健管师",
        icon: "icon_segmented_control_carer_gray.png",
      ),
    ];

    var current = items[0];

    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Container(
        // height: 56,
        padding: EdgeInsets.symmetric(horizontal: 48, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.green,
          // border: Border.all(color: Colors.blue),
          // borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        child: ENCupertinoSlidingSegmentedControl<
            ({
              String title,
              String icon,
            })>(
          groupValue: current,
          // children: children,
          children: Map<
              ({
                String title,
                String icon,
              }),
              Widget>.fromIterable(
            items,
            key: (v) => v,
            value: (val) {
              final e = val as ({
                String title,
                String icon,
              });

              final isSelecetd = current == val;

              final color = isSelecetd ? (thumbTextColor ?? Colors.white) : (textColor ?? Color(0xff737373));
              final icon = isSelecetd ? e.icon : e.icon;

              return Container(
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  // border: Border.all(color: Colors.blue),
                  // borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Image(
                          image: icon.toAssetImage(),
                          width: 12,
                          height: 14,
                          color: color,
                        ),
                      ),
                    if (e.title.isNotEmpty)
                      Flexible(
                        child: Text(
                          e.title,
                          style: TextStyle(
                            fontSize: 14,
                            color: color,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          onValueChanged: (val) {
            if (val == null) {
              return;
            }
            current = val;
            onChanged(items.indexOf(val));
            setState(() {});
          },
          backgroundColor: backgroundColor ?? Color(0xfff3F3F3),
          thumbColor: thumbColor ?? context.primaryColor,
          radius: radius ?? Radius.circular(16),
          padding: padding ?? EdgeInsets.all(2),
        ),
      );
    });
  }

  Widget buildSlidingSegmentedControl2() {
    const children = <int, Widget>{
      0: Text(
        "Item 1",
        style: TextStyle(fontSize: 15),
      ),
      1: Text(
        "Item 2",
        style: TextStyle(fontSize: 15),
      ),
      2: Text(
        "Item 3",
        style: TextStyle(fontSize: 15),
      ),
    };

    return CupertinoSlidingSegmentedControl(
      groupValue: groupValue,
      children: children,
      onValueChanged: (i) {
        setState(() {
          groupValue = int.parse("$i");
        });
        DLog.d(groupValue);
      },
      thumbColor: Colors.orangeAccent,
      // backgroundColor: Colors.transparent,
    );
  }

  Widget buildSlidingSegmentedControl3() {
    const children = <int, Widget>{
      0: Text(
        "Item 1",
        style: TextStyle(fontSize: 15),
      ),
      1: Text(
        "Item 2",
        style: TextStyle(fontSize: 15),
      ),
      2: Text(
        "Item 3",
        style: TextStyle(fontSize: 15),
      ),
    };

    return CupertinoSlidingSegmentedControl(
      groupValue: groupValue,
      children: children,
      onValueChanged: (i) {
        setState(() {
          groupValue = int.parse("$i");
        });
        DLog.d(groupValue);
      },
      // thumbColor: Colors.orangeAccent,
      backgroundColor: Colors.transparent,
    );
  }

  Widget buildLineSegmentControl(Color? backgroundColor, {required Color lineColor}) {
    const children = <int, Widget>{
      0: Text(
        "Item 111",
        style: TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
      1: Text(
        "Item 222",
        style: TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
      2: Text(
        "Item 333",
        style: TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
    };

    if (backgroundColor != null) {
      return NLineSegmentView(
        groupValue: groupValue,
        children: children,
        backgroundColor: backgroundColor,
        lineColor: lineColor,
        onValueChanged: (i) {
          setState(() {
            groupValue = int.parse("$i");
          });
          DLog.d(groupValue);
        },
      );
    }
    return NLineSegmentView(
      groupValue: groupValue,
      children: children,
      // backgroundColor: backgroundColor,
      lineColor: lineColor,
      // lineHeight: 5,
      // lineWidth: 50,
      onValueChanged: (i) {
        setState(() {
          groupValue = int.parse("$i");
        });
        DLog.d(groupValue);
      },
    );
  }

  late final ScrollController _scrollController = ScrollController();

  ///设置单个宽度
  Widget buildListViewHorizontal() {
    var items = List.generate(8, (index) => "item_$index");
    var itemWiths = <double>[60, 70, 80, 90, 100, 110, 120, 130];

    return NListViewSegmentControl(
        items: items,
        // itemWidths: itemWiths,
        selectedIndex: 0,
        onValueChanged: (index) {
          DLog.d(index);
        });
  }

  ///默认宽度
  Widget buildListViewHorizontal1() {
    var items = List.generate(4, (index) => "item_$index");

    return NListViewSegmentControl(
        items: items,
        selectedIndex: 0,
        itemBgColor: Colors.transparent,
        itemSelectedBgColor: Colors.transparent,
        itemWidth: 70,
        itemRadius: 0,
        itemSelectedTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        onValueChanged: (index) {
          DLog.d(index);
        });
  }

  Widget buildChromeSegment() {
    return NChromeSegment(
      items: const [
        (
          title: Text(
            "院内治疗",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: fontColor737373,
              // fontStyle: FontStyle.italic,
            ),
          ),
          count: 99,
        ),
        (
          title: Text(
            "居家治疗",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: fontColor737373,
              // fontStyle: FontStyle.italic,
            ),
          ),
          count: 1,
        ),
        (
          title: Text(
            "机构治疗",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: fontColor737373,
              // fontStyle: FontStyle.italic,
            ),
          ),
          count: 50,
        ),
        // (
        //   title: Text(
        //     "其他治疗",
        //     style: TextStyle(
        //       fontSize: 14,
        //       fontWeight: FontWeight.bold,
        //       color: fontColor737373,
        //       // fontStyle: FontStyle.italic,
        //     ),
        //   ),
        //   count: 50,
        // ),
      ],
      currentIndex: 1,
      onChanged: (index) {
        DLog.d("index $index");
      },
      // selectedBgColor: Colors.red,
      // bgColor: Colors.blue,
    );
  }
}
