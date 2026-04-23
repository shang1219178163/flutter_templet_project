import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/KeyboardAccessoryController.dart';

import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor_for_image.dart';
import 'package:flutter_templet_project/basicWidget/n_target_follower.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/generated/assets.dart';

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

    focusNode.addListener(() {
      DLog.d(["focusNode.hasFocus", focusNode.hasFocus]);
      if (focusNode.hasFocus) {
        keyboardAccessoryController.show(
          context,
          buildToolbar(
            focusNode: focusNode,
            controller: textController,
            onChanged: (v) {
              DLog.d(v);
            },
          ),
        );
      } else {
        keyboardAccessoryController.hide();
      }
    });
  }

  Widget buildText({
    required FocusNode? focusNode,
    TextEditingController? controller,
    required ValueChanged<int> onChanged,
  }) {
    void onInput(String v) {
      DLog.d(v);
      final num = int.tryParse(v) ?? 0;
      if (num <= 0) {
        return;
      }
      onChanged(num);
    }

    return TextField(
      focusNode: focusNode,
      controller: controller,
      // textAlign: TextAlign.center,
      maxLines: 1,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      decoration: InputDecoration(
        constraints: BoxConstraints(
          maxHeight: 32,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 2),
        hintText: "自定义",
        hintStyle: TextStyle(color: Color(0xFFA7A7AE), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (v) => onInput.debounce.call(v),
    );
  }

  Widget buildToolbar({
    FocusNode? focusNode,
    TextEditingController? controller,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Row(
        children: [
          // TextButton(
          //   onPressed: () => focusNode.unfocus(),
          //   child: const Text("完成"),
          // ),
          Container(
            width: 300,
            child: buildText(
              focusNode: focusNode,
              controller: controller,
              onChanged: onChanged,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.keyboard_hide),
            onPressed: () => focusNode?.unfocus(),
          ),
        ],
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12).copyWith(bottom: 34),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              focusNode.requestFocus();
              keyboardAccessoryController.show(
                context,
                buildToolbar(
                  focusNode: focusNode,
                  controller: textController,
                  onChanged: (v) {
                    DLog.d(v);
                  },
                ),
              );
            },
            child: Text("键盘"),
          ),
          TextField(
            focusNode: focusNode,
          ),
          // Spacer(),
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
          buildGift(),
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
    final targetFollowerController = NTargetFollowerController();

    return NTargetFollower(
      controller: targetFollowerController,
      targetAnchor: Alignment.topRight,
      followerAnchor: Alignment.bottomRight,
      target: buildGiftButton(
        countVN: giftCountVN,
        onMore: () {
          DLog.d("onMore");
          targetFollowerController.toggle();
        },
        onSend: () {
          DLog.d("onSend");
          targetFollowerController.toggle();
        },
      ),
      followerBuilder: (context, onHide) {
        return TapRegion(
          onTapInside: (tap) {
            // debugPrint('On Tap Inside!!');
          },
          onTapOutside: (tap) {
            debugPrint('On Tap Outside!!');
            onHide();
          },
          child: buildDropMenu(
            focusNode: focusNode,
            controller: textController,
            onChanged: (int value) {
              DLog.d("onSend $value");
              targetFollowerController.toggle();
              giftCountVN.value = value;
            },
          ),
        );
      },
    );
  }

  Widget buildGiftButton({
    required ValueNotifier<int> countVN,
    VoidCallback? onMore,
    VoidCallback? onSend,
  }) {
    return Container(
      width: 140,
      height: 30,
      padding: const EdgeInsets.only(left: 18),
      decoration: ShapeDecoration(
        shape: StadiumBorder(
          side: BorderSide(width: 1, color: Color(0xFFE91025)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: countVN,
                  builder: (context, value, child) {
                    return GestureDetector(
                      onTap: onMore,
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: 26,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        child: Text(
                          '$value',
                          style: TextStyle(
                            color: Color(0xFF303034),
                            fontSize: 12,
                            fontFamily: 'PingFang SC',
                          ),
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  onTap: onMore,
                  child: Container(
                    width: 24,
                    height: 24,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(),
                    child: Image(
                      image: AssetImage(Assets.imagesIconArrowUp),
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onSend,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 6),
              decoration: ShapeDecoration(
                color: Color(0xFFE91025),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              child: Text(
                '赠送',
                style: TextStyle(
                  color: Color(0xFFFAFAFA),
                  fontSize: 12,
                  fontFamily: 'PingFang SC',
                  height: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropMenu({
    FocusNode? focusNode,
    TextEditingController? controller,
    required ValueChanged<int> onChanged,
  }) {
    // final items = [1, 5, 10, 66, 188].reversed.toList();
    final items = [1, 5, 10, 66, 999].reversed.toList();

    void onInput(String v) {
      DLog.d(v);
      final num = int.tryParse(v) ?? 0;
      if (num <= 0) {
        return;
      }
      onChanged(num);
    }

    return Container(
      width: 120,
      height: 200 + 12,
      padding: EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        // color: Colors.green,
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // height: 200,
            padding: EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Color(0xFFDEDEDE), width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8),
                TextField(
                  focusNode: focusNode,
                  controller: controller,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      maxHeight: 32,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 2),
                    hintText: "自定义",
                    hintStyle: TextStyle(color: Color(0xFFA7A7AE), fontSize: 14),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (v) => onInput.debounce.call(v),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: items.map((e) {
                    return GestureDetector(
                      onTap: () {
                        DLog.d(e);
                        onChanged(e);
                      },
                      child: Container(
                        width: 100,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          // border: Border.all(color: Color(0xFFDEDEDE), width: 0.5),
                          // borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Text(
                          e.toString(),
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontFamily: 'PingFang SC',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
          Image(
            image: AssetImage(Assets.imagesArrowDownFilled),
            width: 12,
            height: 6,
          ),
        ],
      ),
    );
  }
}
