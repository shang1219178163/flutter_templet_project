


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor_for_image.dart';


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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: AppBar(title: Text('$widget')),
      body: buildBody(),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  buildFloatingActionButton() {
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

  buildBody() {
    return Column(
      children: [
        // Spacer(),
        ValueListenableBuilder(
          valueListenable: _selectedItemVN,
          builder: (context, value, child){

            return Text(value.name ?? defaultValue);
          }
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
          cbName: (e) => e.name,
          onChanged: (SomeItemType e) {
            debugPrint(e.name);
            _selectedItemVN.value = e;
          },
        ),

        // NEnumMenuAnchor<SomeItemType>(
        //   values: SomeItemType.values,
        //   initialItem: SomeItemType.itemThree,
        //   onChanged: (SomeItemType e) {
        //     debugPrint(e.name);
        //     _selectedItemVN.value = e;
        //   },
        // ),

      ],
    );
  }

  buildMenuAnchor<E>({
    required List<E> values, 
    required E initialItem,
    required String Function(E e) cbName,
    required ValueChanged<E> onChanged,
    Widget Function(MenuController controller, E? selectedItem)? itemBuilder,
  }) {
    var selectedItem = initialItem;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {

        return MenuAnchor(
          alignmentOffset: Offset(0, 0),
          builder: (context, MenuController controller, Widget? child) {

            return itemBuilder?.call(controller, selectedItem) ?? OutlinedButton(
              onPressed: (){
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
      }
    );
  }


}


