//
//  ButtonStyleDemo.dart
//  flutter_templet_project
//
//  Created by shang on 1/19/23 2:37 PM.
//  Copyright © 1/19/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/button/AppButton.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/AppThemeService.dart';

class ButtonStyleDemo extends StatefulWidget {
  const ButtonStyleDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ButtonStyleDemoState createState() => _ButtonStyleDemoState();
}

class _ButtonStyleDemoState extends State<ButtonStyleDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          IconButton(
            icon: Icon(AppThemeService().isDark ? Icons.light_mode : Icons.dark_mode),
            color: Colors.white,
            onPressed: () {
              AppThemeService().toggleTheme();
            },
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final buttonStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: Size(40, 18),
      // foregroundColor: Colors.blue,
      // backgroundColor: Colors.white,
      disabledForegroundColor: Colors.grey,
      textStyle: const TextStyle(
        fontSize: 14,
        // fontWeight: FontWeight.w600,
      ),
      shape: StadiumBorder(),
      side: const BorderSide(color: Colors.blue, width: 1),
    );

    final themeData = Theme.of(context);
    final elevatedButtonThemeStyle = themeData.elevatedButtonTheme.style;
    final filledButtonThemeStyle = themeData.filledButtonTheme.style;
    final outlinedButtonThemeStyle = themeData.outlinedButtonTheme.style;
    final textButtonThemeStyle = themeData.textButtonTheme.style;
    final primary = themeData.colorScheme.primary;
    final onPrimary = themeData.colorScheme.onPrimary;

    return SingleChildScrollView(
      child: Column(
        children: [
          buildButtonWidgetState(),
          NSectionBox(
            title: "Button",
            child: buildSystemButton(
              onPressed: () {
                DLog.d("buildSystemButton");
              },
            ),
          ),
          NSectionBox(
            title: "Button - disable",
            child: buildSystemButton(onPressed: null),
          ),

          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //   child: Wrap(
          //     spacing: 8,
          //     runSpacing: 8,
          //     children: [
          //       OutlinedButton(
          //         style: OutlinedButton.styleFrom(
          //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //           minimumSize: Size(40, 18),
          //         ),
          //         onPressed: null,
          //         child: Text("Outlined"),
          //       ),
          //       OutlinedButton(
          //         style: buttonStyle,
          //         onPressed: () {
          //           DLog.d("Outlined");
          //         },
          //         child: Text("Outlined"),
          //       ),
          //       OutlinedButton(
          //         style: buttonStyle.copyWith(
          //           foregroundColor: WidgetStateProperty.all(Colors.white),
          //           backgroundColor: WidgetStateProperty.all(Colors.blue),
          //         ),
          //         onPressed: null,
          //         child: Text("Elevated"),
          //       ),
          //       OutlinedButton(
          //         style: buttonStyle.copyWith(
          //           foregroundColor: WidgetStateProperty.all(Colors.blue),
          //           backgroundColor: WidgetStateProperty.all(Colors.blue.withOpacity(0.1)),
          //           side: WidgetStateProperty.all(
          //             BorderSide(color: Colors.transparent, width: 1),
          //           ),
          //         ),
          //         onPressed: null,
          //         child: Text("Tonal"),
          //       ),
          //       OutlinedButton(
          //         style: buttonStyle.copyWith(
          //           side: WidgetStateProperty.all(
          //             BorderSide(color: Colors.transparent, width: 1),
          //           ),
          //         ),
          //         onPressed: () {
          //           DLog.d("Text");
          //         },
          //         child: Text("Text"),
          //       ),
          //     ],
          //   ),
          // ),
          NSectionBox(
            title: "primary/onPrimary",
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...[
                  ("primary", primary),
                  ("onPrimary", onPrimary),
                  ("grey.shade300", Colors.grey.shade300),
                  ("grey.shade600", Colors.grey.shade600),
                  ("Color(0xFF1F1F1F)", Color(0xFF1F1F1F)),
                  ("Color(0xFF6D6D6D)", Color(0xFF6D6D6D)),
                ].map((e) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: e.$2,
                      // border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                    child: Text(
                      e.$1.toString().split(".").last,
                      // style: TextStyle(color: color),
                    ),
                  );
                })
              ],
            ),
          ),
          Divider(),
          NSectionBox(
            title: "AppButton",
            child: buildAppButton(
              onPressed: () {
                DLog.d("buildSystemButton");
              },
            ),
          ),
          NSectionBox(
            title: "AppButton - disable",
            child: buildAppButton(onPressed: null),
          ),
          NSectionBox(
            title: "AppButtonNew",
            child: buildAppButtonNew(
              onPressed: () {
                DLog.d("AppButtonNew");
              },
            ),
          ),
          NSectionBox(
            title: "AppButtonNew - disable",
            child: buildAppButtonNew(onPressed: null),
          ),
        ],
      ),
    );
  }

  Widget buildButtonWidgetState() {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          debugPrint("states:$states");
          if (states.contains(WidgetState.pressed)) {
            return Colors.pink;
          }
          return Colors.black87;
        }),
      ),
      child: Text(
        'state Color',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget buildButtonTheme({required ButtonStyle? buttonStyle}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ...WidgetState.values.map((e) {
            final bgColor = buttonStyle?.backgroundColor?.resolve({e});
            final color = buttonStyle?.foregroundColor?.resolve({e});

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: bgColor,
                // border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: Text(
                e.name.split(".").last,
                style: TextStyle(color: color),
              ),
            );
          })
        ],
      ),
    );
  }

  Widget buildSystemButton({required VoidCallback? onPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          OutlinedButton(
            onPressed: onPressed,
            child: Text("Outlined"),
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: Text("Elevated"),
          ),
          FilledButton.tonal(
            onPressed: onPressed,
            child: Text("tonal"),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text("Text"),
          ),
        ],
      ),
    );
  }

  Widget buildAppButton({required VoidCallback? onPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          AppButton(
            type: AppButtonType.outlined,
            onPressed: onPressed,
            child: Text("Outlined"),
          ),
          AppButton(
            type: AppButtonType.filled,
            onPressed: onPressed,
            child: Text("Filled"),
          ),
          AppButton(
            type: AppButtonType.filledTonal,
            onPressed: onPressed,
            child: Text("Tonal"),
          ),
          AppButton(
            type: AppButtonType.text,
            onPressed: onPressed,
            child: Text("Text"),
          ),
        ],
      ),
    );
  }

  Widget buildAppButtonNew({required VoidCallback? onPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          AppButton(
            type: AppButtonType.outlined,
            onPressed: onPressed,
            child: Text("Outlined"),
          ),
          AppButton(
            type: AppButtonType.filled,
            onPressed: onPressed,
            child: Text("Filled"),
          ),
          AppButton(
            type: AppButtonType.filledTonal,
            onPressed: onPressed,
            child: Text("Tonal"),
          ),
          AppButton(
            type: AppButtonType.text,
            onPressed: onPressed,
            child: Text("Text"),
          ),
        ],
      ),
    );
  }
}
