import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_render_box.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_wrap_page_view.dart';
import 'package:flutter_templet_project/util/AppRes.dart';

class WrapDemo extends StatefulWidget {
  final String? title;

  const WrapDemo({Key? key, this.title}) : super(key: key);

  @override
  _WrapDemoState createState() => _WrapDemoState();
}

class _WrapDemoState extends State<WrapDemo> {
  /// 20 种颜色作为分页数据源（4 列 × 2 行 = 每页 8 项 → 共 3 页）
  final List<Color> items = [
    ...Colors.primaries,
    Colors.amberAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NSectionBox(
              title: "NWrapPageView · 20 色 · 每页 8 项（4×2）",
              mainAxisSize: MainAxisSize.min,
              child: buildWrapPageView(),
            ),
            NSectionBox(
              title: "buildWrapBox",
              mainAxisSize: MainAxisSize.min,
              child: Container(
                margin: EdgeInsets.all(12),
                child: buildWrapBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWrapPageView() {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.green,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: NWrapPageView<Color>(
        height: 168,
        items: items,
        crossAxisCount: 4,
        rowCount: 2,
        spacing: 12,
        runSpacing: 12,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            decoration: BoxDecoration(
              color: item,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildWrapBox() {
    final urls = AppRes.image.urls;
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.start,
        children: List.generate(12, (index) {
          return NRenderBox(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NNetworkImage(
                    width: 50,
                    height: 60,
                    url: urls[index % urls.length],
                  ),
                  Text("选项_$index"),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
