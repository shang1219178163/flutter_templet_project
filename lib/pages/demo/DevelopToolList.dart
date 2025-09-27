import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

/// 开发工具列表
class DevelopToolList extends StatefulWidget {
  DevelopToolList({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _DevelopToolListState createState() => _DevelopToolListState();
}

class _DevelopToolListState extends State<DevelopToolList> {
  final _scrollController = ScrollController();

  final items = <Tuple2<String, String>>[
    Tuple2("系统图标", APPRouter.systemIconsPage),
    Tuple2("系统颜色", APPRouter.systemColorPage),
    Tuple2("字符串转换", APPRouter.stringTransformPage),
    Tuple2("json转model", APPRouter.jsonToDartPage),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("开发辅助工具"),
        // actions: ['done',].map((e) => TextButton(
        //   child: Text(e,
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   onPressed: () => debugPrint(e),)
        // ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16,
          ),
          // alignment: Alignment.center,
          decoration: BoxDecoration(
              // color: Colors.green,
              // border: Border.all(color: Colors.blue),
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: LayoutBuilder(builder: (context, constraints) {
                  final spacing = 8.0;
                  final runSpacing = 8.0;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: runSpacing,
                    // alignment: WrapAlignment.start,
                    children: items
                        .map((e) => OutlinedButton(
                              onPressed: () {
                                debugPrint(e.item2);
                                Get.toNamed(e.item2);
                              },
                              child: NText(e.item1),
                            ))
                        .toList(),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
