import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/slide_transition_builder.dart';
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
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

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
              onPressed: () => context.showToast('Flutter is awesome!'*5,
                  isDismiss: true,
                  alignment: Alignment.topCenter,
              ),
              child: const Text('Show Toast topCenter'),
            ),
            ElevatedButton(
              onPressed: () => context.showToast('Flutter is awesome!',
                  isDismiss: false,
                  alignment: Alignment.center,
              ),
              child: const Text('Show Toast center'),
            ),
            ElevatedButton(
              onPressed: () => context.showToast('Flutter is awesome!',
                  isDismiss: false,
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
                  showPopupView(
                    alignment: e,
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

  showPopupView({Alignment alignment = Alignment.bottomCenter}) {
    showEntry(child: Material(
      color: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: (){
          hideEntry();
        },
        child: SlideTransitionBuilder(
          alignment: alignment,
          hasFade: false,
          // child: FlutterLogo(),
        ),
      ),
    ));
  }
}



//
class ToastWidget extends StatefulWidget {
  ToastWidget({
    Key? key,
    required this.text,
    this.alignment = Alignment.center,
    this.margin = const EdgeInsets.only(left: 16, right: 16, top: 56, bottom: 56,),
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12,),
    this.builder,
    this.duration = const Duration(milliseconds: 2000),
    this.transitionDuration = const Duration(milliseconds: 250),
  }) : super(key: key);

  final String text;
  final Alignment alignment;
  final EdgeInsets margin;
  final EdgeInsets padding;

  final StatefulWidgetBuilder? builder;

  final Duration duration;
  final Duration transitionDuration;

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget> with SingleTickerProviderStateMixin {
  late final AnimationController opacity;

  @override
  void initState() {
    super.initState();
    opacity = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
    )..forward();

    // final startFadeOutAt = widget.duration - widget.transitionDuration;
    // print('startFadeOutAt: $startFadeOutAt');
    // Future.delayed(startFadeOutAt, opacity.reverse);
  }

  @override
  void dispose() {
    opacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: Align(
        alignment: widget.alignment,
        child: widget.builder?.call(context, setState) ?? _buildDefaultContainer(widget.text,
            margin: widget.margin,
            padding: widget.padding
        ),
      ),
    );
  }

  //默认样式
  _buildDefaultContainer(String text, {
    EdgeInsets margin = const EdgeInsets.all(16),
    EdgeInsets padding = const EdgeInsets.all(12)
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.65),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: margin,
      padding: padding,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

extension ToastExtension on BuildContext {

  showToastNew(
    String text, {
      Alignment alignment = Alignment.center,
      Duration duration = const Duration(milliseconds: 2000),
      Duration transitionDuration = const Duration(milliseconds: 250),
      bool isDismiss = true,
    }) {

    // Create an OverlayEntry with your custom widget
    final entry = OverlayEntry(
      builder: (_) => ToastWidget(
        text: text,
        alignment: alignment,
        transitionDuration: transitionDuration,
        duration: duration,
      ),
    );
    // then insert it to the overlay
    // this will show the toast widget on the screen
    final overlayState = Overlay.of(this);
    overlayState.insert(entry);
    // overlayState?.rearrange([entry]);
    // 3 secs later remove the toast from the stack
    // and this one will remove the toast from the screen
    if (isDismiss) {
      Future.delayed(duration, entry.remove);
    }
  }

  showToast(
    String text, {
      Alignment alignment = Alignment.center,
      Duration duration = const Duration(milliseconds: 2000),
      Duration transitionDuration = const Duration(milliseconds: 250),
      bool isDismiss = true,
    }) {

    // Create an OverlayEntry with your custom widget
    final entry = OverlayEntry(
      builder: (_) => ToastWidget(
        text: text,
        alignment: alignment,
        transitionDuration: transitionDuration,
        duration: duration,
      ),
    );
    // then insert it to the overlay
    // this will show the toast widget on the screen
    final overlayState = Overlay.of(this);
    overlayState.insert(entry);
    // overlayState?.rearrange([entry]);
    // 3 secs later remove the toast from the stack
    // and this one will remove the toast from the screen
    if (isDismiss) {
      Future.delayed(duration, entry.remove);
    }
  }
}


