import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/KeyboardAccessoryController.dart';
import 'package:flutter_templet_project/basicWidget/livestream/n_send_gift_button.dart';
import 'package:flutter_templet_project/basicWidget/n_boder_text.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor_for_image.dart';
import 'package:flutter_templet_project/basicWidget/overlay/n_overlay_dialog.dart';
import 'package:flutter_templet_project/basicWidget/text_field/n_input_accessory_view.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/screen_manager.dart';
import 'package:flutter_templet_project/util/tool_util.dart';

enum SomeItemType { none, itemOne, itemTwo, itemThree }

class MenuAnchorDemo extends StatefulWidget {
  const MenuAnchorDemo({super.key});

  @override
  State<MenuAnchorDemo> createState() => _MenuAnchorDemoState();
}

class _MenuAnchorDemoState extends State<MenuAnchorDemo> {
  final _selectedItemVN = ValueNotifier<SomeItemType>(SomeItemType.none);

  String defaultValue = "-";

  var selectedItem = SomeItemType.itemThree;

  final MenuController controller = MenuController();

  final giftCountVN = ValueNotifier(1);

  final focusNode = FocusNode();
  final textController = TextEditingController();
  final keyboardAccessoryController = KeyboardAccessoryController();

  @override
  void dispose() {
    keyboardAccessoryController.hide();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // initData();
  }

  initData() {
    focusNode.addListener(() {
      DLog.d(["focusNode.hasFocus", focusNode.hasFocus]);
      if (focusNode.hasFocus) {
        DLog.d("viewInsets: ${View.of(context).viewInsets}");

        showInputAccessoryView();
      } else {
        // keyboardAccessoryController.hide();
      }
    });
  }

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
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {
          //         focusNode.requestFocus();
          //         // showInputAccessoryView();
          //       },
          //       child: Text("唤起键盘"),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {
          //         focusNode.unfocus();
          //       },
          //       child: Text("收起键盘"),
          //     ),
          //   ],
          // ),
          TextField(
            readOnly: true,
            focusNode: focusNode,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 11),
              hintText: '点击唤起InputAccessoryView',
            ),
            onTap: () {
              NInputAccessoryView.show(
                context: context,
                focusNode: focusNode,
                controller: textController,
                keyboardType: TextInputType.number,
                hintText: "请输入礼物数量",
                maxLength: 3,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              );
            },
          ),

          ValueListenableBuilder(
            valueListenable: _selectedItemVN,
            builder: (context, value, child) {
              return Text(value.name ?? defaultValue);
            },
          ),

          // buildMenuAnchor<SomeItemType>(
          //   values: SomeItemType.values,
          //   initialItem: SomeItemType.itemThree,
          //   cbName: (e) => e.name,
          //   onChanged: (SomeItemType e) {
          //     debugPrint(e.name);
          //     _selectedItemVN.value = e;
          //   },
          // ),

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

          Spacer(),
          NSendGiftButton(
            textController: textController,
            onGiftCountCustom: () async {
              DLog.d("onGiftCountCustom");

              NInputAccessoryView.show(
                context: context,
                focusNode: focusNode,
                controller: textController,
                keyboardType: TextInputType.number,
                hintText: "请输入礼物数量",
                maxLength: 3,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              );
            },
            onDropHide: () {
              // NInputAccessoryView.dismiss();
            },
            onSendChanged: (v) {
              NOverlayDialog.toast(context, message: "赠送$v个礼物");
            },
          )
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

  Widget buildGift({VoidCallback? onMore}) {
    return NSendGiftButton(
      textController: textController,
      onGiftCountCustom: () {
        DLog.d("onGiftCountCustom");
      },
      onSendChanged: (v) {
        DLog.d("onSendChanged $v");
      },
    );
  }
}
