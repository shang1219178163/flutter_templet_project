import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/header.dart';
import 'package:flutter_templet_project/basicWidget/n_cancel_and_confirm_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_toast.dart';
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
                  height: 100.0,
                  width: 100.0,
                ),
              ],
            ),
            ...[Alignment.topCenter,
              Alignment.center,
              Alignment.bottomCenter,
            ].map((e) {
              return ElevatedButton(
                onPressed: () => showToast(text: 'Flutter is awesome!',
                  // barrierDismissible: false,
                  alignment: e,
                ),
                child: Text('Show Toast: ${e.toString().split(".").last}'),
              );
            }).toList(),
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
            ...[Alignment.topCenter,
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
                child: Text('PopupView: ${e}'),
              );
            }).toList(),
            Header.h5(title: "NToast"),
            ...[Alignment.topCenter,
              Alignment.center,
              Alignment.bottomCenter,
            ].map((e) {
              return ElevatedButton(
                onPressed: () => NToast.showToast(
                  context: context,
                  text: 'NToast is awesome!',
                  // barrierDismissible: false,
                  alignment: e,
                ),
                child: Text('Show Toast: ${e.toString().split(".").last}'),
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