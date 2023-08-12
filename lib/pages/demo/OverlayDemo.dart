import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_cancel_and_confirm_bar.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/overlay_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class OverlayDemo extends StatefulWidget {

  final String? title;

  const OverlayDemo({ Key? key, this.title}) : super(key: key);

  
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
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Image.asset(
                  "icon_skipping.gif".toPath(),
                  height: 200.0,
                  width: 100.0,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                var script = Platform.script.toString();
                debugPrint("script: $script");
                // final dir = Directory(path)

              },
              child: const Text('Show Toast topCenter'),
            ),
            ElevatedButton(
              onPressed: () => showToast(text: 'Flutter is awesome!',
                  barrierDismissible: false,
                  alignment: Alignment.center,
              ),
              child: const Text('Show Toast center'),
            ),
            ElevatedButton(
              onPressed: () => showToast(text: 'Flutter is awesome!',
                barrierDismissible: false,
                  alignment: Alignment.bottomCenter,
              ),
              child: const Text('Show Toast bottomCenter'),
            ),
            ElevatedButton(
              onPressed: () {
                overlayEntry ??= OverlayEntry(
                  builder: (context) {
                    return buildEntryContent(
                      onTap: (){
                        overlayEntry?.remove();
                      }
                    );
                });
                overlayState.insert(overlayEntry!);
              },
              child: const Text('overlayState'),
            ),
            ElevatedButton(
              onPressed: () {
                showEntry(
                  child: buildEntryContent(
                    onTap: (){
                      debugPrint("onTap");
                      hideEntry();
                    }
                  ),
                );
              },
              child: const Text('showEntry'),
            ),
            ElevatedButton(
              onPressed: () {
                showToast();
              },
              child: const Text('OverlayExt'),
            ),
            ...[Alignment.topCenter,
            Alignment.bottomCenter,
            Alignment.centerLeft,
            Alignment.centerRight,
            Alignment.center,
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
                            FlutterLogo(size: 200,),
                            NCancelAndConfirmBar(
                              onCancel: (){
                              },
                              onConfirm: (){
                                onHide();
                              }
                            ),
                          ],
                        ),
                      );
                    }
                  );
                },
                child: Text('PopupView ${e}'),
              );
            }).toList(),
          ],
        ),
    );
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