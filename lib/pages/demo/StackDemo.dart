import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/StackPopup/StackPopup.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_slide_stack.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';

class StackDemo extends StatefulWidget {
  final String? title;

  const StackDemo({Key? key, this.title}) : super(key: key);

  @override
  _StackDemoState createState() => _StackDemoState();
}

class _StackDemoState extends State<StackDemo> with SingleTickerProviderStateMixin {
  var items = AlignmentExt.allCases.map((e) => e.toString().split(".").last).toList();
  late final tabController = TabController(initialIndex: 3, length: items.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: items.map((e) => Tab(text: e)).toList(),
          onTap: (v) {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildSection(),
            buildSection1(),
            ElevatedButton(
              onPressed: () {
                final popupController = StackPopupController();
                popupController.show(
                  context: context,
                  from: Alignment.centerRight,
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                  ),
                  builder: (BuildContext context) {
                    final items = List.generate(10, (i) => i);
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      child: ListView.separated(
                        itemBuilder: (context, i) {
                          return ListTile(
                            onTap: () {
                              popupController.dismiss();
                            },
                            title: Text("item_$i"),
                          );
                        },
                        separatorBuilder: (context, i) {
                          return Divider();
                        },
                        itemCount: items.length,
                      ),
                    );
                  },
                );
              },
              child: Text("StackPopupController"),
            ),
            buildSection2(),
          ],
        ),
      ),
    );
  }

  buildSection() {
    return NSectionBox(
      title: "buildSection",
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            padding: EdgeInsets.all(10),
            color: Colors.green,
            child: Container(
              color: Colors.yellow,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            // bottom: 80,
            // left: 80,
            child: Container(
              // decoration: BoxDecoration(
              //   color: Colors.red,
              //   borderRadius: BorderRadius.circular(10),
              // ),
              child: Material(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
                child: Text('99+'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildSection1() {
    return NSectionBox(
      title: "buildSection1",
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 150, height: 150, color: Colors.yellow),
              Container(width: 150, height: 28, color: Colors.transparent),
            ],
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: FloatingActionButton(
              onPressed: () {
                debugPrint('FAB tapped!');
              },
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.add),
            ),
          ),
        ],
      ).toColoredBox(),
    );
  }

  Widget buildSection2() {
    return NSectionBox(
      title: "NSlideStack",
      child: NSlideStack(
        // fromRight: false,
        drawerWidth: 150,
        drawerBuilder: (onToggle) => buildListView(onTap: onToggle),
        childBuilder: (onToggle) => Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          child: Center(
            child: ElevatedButton(
              onPressed: onToggle,
              child: Text("AnimatedPositioned"),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListView({VoidCallback? onTap}) {
    final items = List.generate(10, (i) => i);
    return Container(
      decoration: BoxDecoration(
        color: Colors.yellow,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: ListView.separated(
          itemBuilder: (context, i) {
            return ListTile(
              dense: true,
              onTap: () {
                onTap?.call();
                DLog.d("选项_$i");
              },
              title: Text("选项_$i"),
            );
          },
          separatorBuilder: (context, i) {
            return Divider();
          },
          itemCount: items.length,
        ),
      ),
    );
  }
}
