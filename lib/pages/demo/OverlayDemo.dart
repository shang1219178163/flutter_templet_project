import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_cancel_and_confirm_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_overlay.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/overlay_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/pages/demo/OverlayDemoOne.dart';
import 'package:flutter_templet_project/util/tool_util.dart';
import 'package:get/get.dart';

class OverlayDemo extends StatefulWidget {
  final String? title;

  const OverlayDemo({Key? key, this.title}) : super(key: key);

  @override
  _OverlayDemoState createState() => _OverlayDemoState();
}

class _OverlayDemoState extends State<OverlayDemo> {
  OverlayState get overlayState => Overlay.of(context);
  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: onPressed,
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Image.asset(
                  "icon_skipping.gif".toPath(),
                  height: 100.0,
                  width: 100.0,
                ),
              ],
            ),
            ...[
              Alignment.topCenter,
              Alignment.center,
              Alignment.bottomCenter,
            ].map((e) {
              return ElevatedButton(
                onPressed: () => showToast(
                  'Flutter is awesome!',
                  // barrierDismissible: false,
                  alignment: e,
                ),
                child: Text('Show Toast: ${e.toString().split(".").last}'),
              );
            }).toList(),
            ElevatedButton(
              onPressed: () {
                overlayEntry ??= OverlayEntry(builder: (context) {
                  return buildEntryContent(onTap: () {
                    overlayEntry?.remove();
                  });
                });
                overlayState.insert(overlayEntry!);
              },
              child: const Text('overlayState'),
            ),
            ElevatedButton(
              onPressed: () {
                showEntry(
                  child: buildEntryContent(onTap: () {
                    debugPrint("onTap");
                    hideEntry();
                  }),
                );
              },
              child: const Text('showEntry'),
            ),
            ...[
              Alignment.topCenter,
              Alignment.centerLeft,
              Alignment.centerRight,
              Alignment.center,
              Alignment.bottomCenter,
              Alignment.bottomLeft,
            ].map((e) {
              return ElevatedButton(
                onPressed: () {
                  presentModalView(
                      alignment: e,
                      barrierDismissible: false,
                      builder: (context, onHide) {
                        return Container(
                          height: 300,
                          width: 300,
                          color: Colors.yellow,
                          child: Column(
                            children: [
                              FlutterLogo(
                                size: 200,
                              ),
                              NCancelAndConfirmBar(
                                  onCancel: () {},
                                  onConfirm: () {
                                    onHide();
                                  }),
                            ],
                          ),
                        );
                      });
                },
                child: Text('PopupView: $e'),
              );
            }).toList(),
            NSectionBox(
              title: "NToast",
              child: Column(
                children: [
                  Alignment.topCenter,
                  Alignment.center,
                  Alignment.bottomCenter,
                ].map((e) {
                  return ElevatedButton(
                    onPressed: () => NOverlay.showToast(
                      context,
                      message: 'NToast is awesome!',
                      onDismiss: () {
                        debugPrint("onDismiss: ${DateTime.now()}");
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.white,
                            ),
                          ),
                          NText(
                            'NToast is awesome!',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      // barrierDismissible: false,
                      alignment: e,
                    ),
                    child: Text('Show Toast: ${e.toString().split(".").last}'),
                  );
                }).toList(),
              ),
            ),
            NSectionBox(
              title: "Loadding",
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => NOverlay.showToast(
                      context,
                      message: 'NToast is awesome!',
                      onDismiss: () {
                        debugPrint("onDismiss: ${DateTime.now()}");
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.white,
                            ),
                          ),
                          NText(
                            'NToast is awesome!',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      // barrierDismissible: false,
                      alignment: Alignment.center,
                    ),
                    child: Text('Show NToast'),
                  ),
                  ElevatedButton(
                    onPressed: () => NOverlay.showLoading(
                      context,
                      message: 'NToast is awesome!',
                    ),
                    child: Text('Show Loadding'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onPressed() {
    final context = ToolUtil.navigatorKey.currentState!.context;
    final context1 = ToolUtil.navigatorKey.currentState!.overlay!.context;
    debugPrint("context: ${context == context1}");

    Get.to(() => OverlayDemoOne());
  }

  Widget buildEntryContent({
    VoidCallback? onTap,
  }) {
    return Positioned(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.black.withOpacity(0.1),
          child: Center(
            child: Image(
              image: "icon_skipping.gif".toAssetImage(),
              width: 200,
              height: 100,
            ),
          ),
        ),
      ),
    );
  }
}
