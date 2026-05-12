import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/KeyboardAccessoryController.dart';
import 'package:flutter_templet_project/basicWidget/livestream/n_send_gift_button.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor_for_image.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_overlay_dialog.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_overlay_manager_new.dart';
import 'package:flutter_templet_project/basicWidget/text_field/n_input_accessory_view.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/n_screen_manager.dart';

enum SomeItemType { none, itemOne, itemTwo, itemThree }

class MenuAnchorDemo extends StatefulWidget {
  const MenuAnchorDemo({super.key});

  @override
  State<MenuAnchorDemo> createState() => _MenuAnchorDemoState();
}

class _MenuAnchorDemoState extends State<MenuAnchorDemo> with KeyboardHeightChangedMixin {
  final _selectedItemVN = ValueNotifier<SomeItemType>(SomeItemType.none);

  String defaultValue = "-";

  var selectedItem = SomeItemType.itemThree;

  final MenuController controller = MenuController();

  final giftCountVN = ValueNotifier(1);

  final focusNode = FocusNode();
  final textController = TextEditingController();
  final keyboardAccessoryController = KeyboardAccessoryController();

  @override
  final keyboardHeightVN = ValueNotifier(0.0);

  @override
  void dispose() {
    keyboardAccessoryController.hide();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    initData();
  }

  initData() {}

  void showInputAccessoryView() {
    keyboardAccessoryController.show(
      context,
      NInputAccessoryView(
        focusNode: focusNode,
        controller: textController,
        onConfirm: (v) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: AppBar(title: Text('$widget')),
      body: buildBody(),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  Widget buildFloatingActionButton() {
    final values = [
      "icon_heart_border.png",
      "icon_heart_half.png",
      "icon_heart.png",
    ];

    return NMenuAnchorForImage(
      values: values,
      initialItem: values[1],
      onChanged: (e) {
        debugPrint(e.toString());
      },
    );
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12).copyWith(bottom: 34),
      decoration: BoxDecoration(
        // color: Colors.green,
        border: Border.all(color: Colors.blue),
        // borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListenableBuilder(
            listenable: Listenable.merge([
              focusNode,
              keyboardHeightVN,
            ]),
            builder: (context, Widget? child) {
              final isHide = keyboardHeightVN.value == 0.0;
              return Container(
                decoration: BoxDecoration(
                  color: isHide ? Colors.white : ColorExt.random,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text([
                      'MediaQuery.of(context).viewInsets.bottom',
                      MediaQuery.of(context).viewInsets.bottom.toStringAsFixed(1),
                    ].join(": ")),
                    Text([
                      'View.of(context).viewInsets.bottom',
                      View.of(context).viewInsets.bottom.toStringAsFixed(1),
                    ].join(": ")),
                    Text([
                      'NScreenManager.viewInsets.bottom',
                      (NScreenManager.viewInsets.bottom / 3.0).toStringAsFixed(1),
                    ].join(": ")),
                    Text([
                      'keyboardHeightVN.value',
                      keyboardHeightVN.value,
                    ].join(": ")),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 10),
          TextField(
            // readOnly: true,
            focusNode: focusNode,
            controller: textController,
            minLines: 1,
            maxLines: 3,
            inputFormatters: [
              // FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 11),
              hintText: '点击唤起InputAccessoryView',
            ),
            onTap: () async {
              showInputAccessory();
            },
            onTapOutside: (e) {
              focusNode.unfocus();
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              showInputAccessory();
            },
            child: Text("拉起键盘"),
          ),

          SizedBox(height: 10),
          Row(
            children: [
              NMenuAnchor<SomeItemType>(
                values: SomeItemType.values,
                initialItem: SomeItemType.itemThree,
                cbName: (e) => e?.name ?? "请选择",
                equal: (a, b) => a == b,
                onChanged: (SomeItemType e) {
                  debugPrint(e.name);
                  _selectedItemVN.value = e;
                },
                itemBuilder: (e, isSeleced) {
                  return Container(
                    width: 100,
                    height: 45,
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: ColorExt.random,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                    child: ListTile(
                      dense: true,
                      // leading: FlutterLogo(size: 24),
                      title: Text(e.name),
                    ),
                  );
                },
              ),
              SizedBox(width: 10),
              ValueListenableBuilder(
                valueListenable: _selectedItemVN,
                builder: (context, value, child) {
                  return Text(value.name ?? defaultValue);
                },
              ),
            ],
          ),

          Spacer(),
          buildGiftButton(),
          // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget buildMenuAnchor<E>({
    required List<E> values,
    required E initialItem,
    required String Function(E e) cbName,
    required ValueChanged<E> onChanged,
    Widget Function(MenuController controller, E? selectedItem)? itemBuilder,
  }) {
    var selectedItem = initialItem;

    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return MenuAnchor(
        alignmentOffset: Offset(0, 0),
        builder: (context, MenuController controller, Widget? child) {
          return itemBuilder?.call(controller, selectedItem) ??
              OutlinedButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(cbName(selectedItem)),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              );
        },
        menuChildren: values.map((e) {
          return MenuItemButton(
            onPressed: () {
              selectedItem = e;
              setState(() {});
              onChanged.call(e);
            },
            child: Text(cbName(e)),
          );
        }).toList(),
      );
    });
  }

  Widget buildGiftButton() {
    return NSendGiftButton(
      textController: textController,
      onGiftCountCustom: () async {
        focusNode.requestFocus();
        await Future.delayed(Duration(milliseconds: 100));
        // DLog.d("onGiftCountCustom, ${keyboardHeightVN.value}");
        showInputAccessory();
      },
      onDropHide: () {
        // NInputAccessoryView.dismiss();
      },
      onSendChanged: (v) {
        NOverlayDialog.toast(context, message: "赠送$v个礼物");
      },
    );
  }

  void showInputAccessory() {
    return NInputAccessoryView.show(
      context: context,
      focusNode: focusNode,
      controller: textController,
      // keyboardVN: keyboardHeightVN,
      keyboardType: TextInputType.number,
      hintText: "请输入",
      // maxLength: 3,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
    // show(
    //   context: context,
    //   focusNode: focusNode,
    //   controller: textController,
    //   keyboardVN: keyboardHeightVN,
    //   keyboardType: TextInputType.number,
    //   hintText: "请输入礼物数量",
    //   maxLength: 3,
    //   inputFormatters: [
    //     FilteringTextInputFormatter.digitsOnly,
    //   ],
    // );
  }

  // 展示礼物辅助视图
  void show({
    required BuildContext context,
    FocusNode? focusNode,
    required TextEditingController controller,
    ValueNotifier<double>? keyboardVN,
    TextInputType? keyboardType,
    String? hintText = "请输入",
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
    int? maxLength,
    double? keyboardHeight,
  }) {
    // focusNode?.requestFocus();
    if (keyboardVN == null) {
      NOverlayManagerNew.show(
        context,
        autoDismiss: false,
        builder: (c) {
          var bottom = keyboardHeight ?? MediaQuery.of(c).viewInsets.bottom;
          DLog.d("bottom: $bottom");

          return Positioned(
            left: 0,
            right: 0,
            bottom: bottom,
            child: NInputAccessoryView(
              focusNode: focusNode,
              controller: controller,
              keyboardType: keyboardType,
              hintText: hintText,
              maxLines: maxLines,
              maxLength: maxLength,
              inputFormatters: inputFormatters,
              onConfirm: (v) {
                NInputAccessoryView.dismiss();
              },
            ),
          );
        },
      );
      return;
    }
    NOverlayManagerNew.show(
      context,
      autoDismiss: false,
      builder: (c) {
        var bottom = keyboardHeight ?? MediaQuery.of(c).viewInsets.bottom;
        DLog.d("bottom: $bottom");

        return ValueListenableBuilder(
          valueListenable: keyboardVN,
          child: NInputAccessoryView(
            focusNode: focusNode,
            controller: controller,
            keyboardType: keyboardType,
            hintText: hintText,
            maxLines: maxLines,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            onConfirm: (v) {
              NInputAccessoryView.dismiss();
            },
          ),
          builder: (context, value, child) {
            return AnimatedPositioned(
              duration: Duration(milliseconds: 100),
              left: 0,
              right: 0,
              bottom: max(keyboardVN.value, bottom),
              child: child!,
            );
          },
        );
      },
    );
  }
}
