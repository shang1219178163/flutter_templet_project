import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_context_menu.dart';
import 'package:flutter_templet_project/basicWidget/n_context_menu_region.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class ContextMenuDemo extends StatefulWidget {
  ContextMenuDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ContextMenuDemoState createState() => _ContextMenuDemoState();
}

class _ContextMenuDemoState extends State<ContextMenuDemo> {
  static const String route = 'anywhere';
  static const String title = 'Context Menu Anywhere Example';
  static const String subtitle = 'A context menu outside of a text field';

  final _materialController = TextEditingController(
    text: 'TextField shows the default menu still.',
  );
  final _cupertinoController = TextEditingController(
    text: 'CupertinoTextField shows the default menu still.',
  );
  final _editableController = TextEditingController(
    text: 'EditableText has no default menu, so it shows the custom one.',
  );

  late final contextItems = <({String title, VoidCallback event})>[
    (title: "按钮1", event: onContextItem),
    (title: "按钮2", event: onContextItem),
    (title: "按钮3", event: onContextItem),
    (title: "分享", event: onContextItem),
    (title: "搜索", event: onContextItem),
    (title: "自定义按钮", event: onContextItem),
  ];

  void onContextItem() {
    DLog.d("onContextItem");
  }

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: <Widget>[],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            NContextMenuRegion(
              contextMenuBuilder: (context, primaryAnchor, [secondaryAnchor]) {
                return AdaptiveTextSelectionToolbar.buttonItems(
                  anchors: TextSelectionToolbarAnchors(
                    primaryAnchor: primaryAnchor,
                    secondaryAnchor: secondaryAnchor as Offset?,
                  ),
                  buttonItems: <ContextMenuButtonItem>[
                    ...contextItems.map((e) => ContextMenuButtonItem(
                          onPressed: () {
                            ContextMenuController.removeAny();
                            // Navigator.of(context).pop();
                            e.event();
                          },
                          label: e.title,
                        )),
                  ],
                );
              },
              child: const Text(
                'Right click anywhere outside of a field to show a custom menu.',
              ),
            ),
            CupertinoTextField(controller: _cupertinoController),
            TextField(controller: _materialController),
            Container(
              color: Colors.white,
              child: SelectionArea(
                // focusNode: ,
                child: EditableText(
                  controller: _editableController,
                  focusNode: FocusNode(),
                  style: Typography.material2021().black.displayMedium!,
                  cursorColor: Colors.blue,
                  backgroundCursorColor: Colors.white,
                ),
              ),
            ),
            NContextMenu(
              items: const ['保存', '分享', '编辑'],
              onItem: (val) {
                debugPrint(val);
              },
              child: Image.asset(
                'assets/images/404.png',
                height: 200,
              ),
            ),
            SelectionArea(
              contextMenuBuilder: (BuildContext context, SelectableRegionState selectableRegionState) {
                return AdaptiveTextSelectionToolbar.buttonItems(
                  anchors: selectableRegionState.contextMenuAnchors,
                  buttonItems: <ContextMenuButtonItem>[
                    ...contextItems.map((e) => ContextMenuButtonItem(
                          onPressed: () {
                            ContextMenuController.removeAny();
                            // Navigator.of(context).pop();
                            e.event();
                          },
                          label: e.title,
                        )),
                  ],
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      'Flutter 3.3 中的 SelectionArea 功能。它补全了 Selection 异常问题，使用简单，默认实现常见功能且针对不同平台有差异化。可通过继承 TextSelectionControls 自定义，Handle 颜色默认来自 TextSelectionTheme 和 Theme。'),
                ],
              ),
            ),
          ]
              .map((e) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16),
                    child: e,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
