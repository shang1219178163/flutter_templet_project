import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/drop_menu/drop_menu.dart';
import 'package:flutter_templet_project/basicWidget/drop_menu/overlay_toast.dart';
import 'package:flutter_templet_project/basicWidget/n_cancel_and_confirm_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_overlay.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_overlay_dialog.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/pages/demo/OverlayDemoOne.dart';
import 'package:flutter_templet_project/util/tool_util.dart';

class OverlayDemo extends StatefulWidget {
  final String? title;

  const OverlayDemo({Key? key, this.title}) : super(key: key);

  @override
  _OverlayDemoState createState() => _OverlayDemoState();
}

class _OverlayDemoState extends State<OverlayDemo> {
  OverlayState get overlayState => Overlay.of(context);
  OverlayEntry? overlayEntry;

  List<String> menus = ['直播间', '专家'];
  late final currentMenu = ValueNotifier(menus.first);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "icon_skipping.gif".toPath(),
                  height: 100.0,
                  width: 100.0,
                ),
                buildDropButton(),
                SizedBox(),
              ],
            ),
            NSectionBox(
              title: "NToast",
              child: Column(
                children: [
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
                    child: Text('Toast: ${e.toString().split(".").last}'),
                  );
                }).toList(),
              ),
            ),
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
                                },
                              ),
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
                              Icons.info_outline,
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
                    onPressed: () {
                      NOverlay.showToast(
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
                                Icons.info_outline,
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
                      );
                    },
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
            NSectionBox(
              title: "OverlayToast",
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      OverlayToast.instance.show(
                        context,
                        autoDismiss: true,
                        child: buildToastContent(
                          message: "OverlayToast",
                          onTap: () {
                            OverlayToast.instance.dismiss();
                          },
                        ),
                      );
                    },
                    child: Text('OverlayToast'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget buildDropButton() {
    return GestureDetector(
      onTap: () {
        DropMenu.instance.showFollower(
          context: context,
          items: menus,
          onSelected: (i) {
            DLog.d([i, menus[i]]);
            currentMenu.value = menus[i];
          },
        );
      },
      child: DropMenu.instance.buildTarget(
        child: Container(
          width: 70,
          height: 38,
          decoration: BoxDecoration(
            color: Color(0xFFF5F8F9),
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [Color(0xFFFE44554), Color(0xFFF6040FF)],
                    ).createShader(bounds);
                  },
                  child: Row(
                    children: [
                      ValueListenableBuilder(
                          valueListenable: currentMenu,
                          builder: (context, value, child) {
                            return Text(
                              value,
                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                            );
                          }),
                    ],
                  ),
                ),
                Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildToastContent({
    required String message,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
              ),
              NText(
                message,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ],
          ),
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
