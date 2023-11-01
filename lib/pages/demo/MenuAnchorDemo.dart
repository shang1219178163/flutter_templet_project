


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_enum_menu_anchor.dart';
import 'package:flutter_templet_project/pages/demo/checkbox_menu_demo.dart';

enum SampleItem { none, itemOne, itemTwo, itemThree }


class MenuAnchorDemo extends StatefulWidget {
  const MenuAnchorDemo({super.key});

  @override
  State<MenuAnchorDemo> createState() => _MenuAnchorDemoState();
}

class _MenuAnchorDemoState extends State<MenuAnchorDemo> {

  final _selectedItemVN = ValueNotifier<SampleItem>(SampleItem.none);

  String defaultValue = "-";

  static const String kMessage = '"Talk less. Smile more." - A. Burr';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MenuAnchorButton')),
      body: buildBody(),
      // body: CheckboxMenuDemo(message: kMessage,),
    );
  }

  buildBody() {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: _selectedItemVN,
          builder: (context, value, child){

            return Text(value.name ?? defaultValue);
          }
        ),
        buildMenuAnchor<SampleItem>(
          values: SampleItem.values,
          onChanged: (SampleItem e) {
            debugPrint(e.name);
            _selectedItemVN.value = e;
          },
        ),

        NEnumMenuAnchor<SampleItem>(
          values: SampleItem.values,
          initialItem: SampleItem.itemThree,
          onChanged: (SampleItem e) {
            debugPrint(e.name);
            _selectedItemVN.value = e;
          },
        ),

      ],
    );
  }

  buildMenuAnchor<E extends Enum>({
    required List<E> values, 
    E? selectedItem, 
    String defaultValue = "-",
    Widget Function(MenuController controller, E? selectedItem)? itemBuilder,
    required ValueChanged<E> onChanged,
  }) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {

        return MenuAnchor(
          builder: (context, MenuController controller, Widget? child) {

            return itemBuilder?.call(controller, selectedItem) ?? OutlinedButton(
              onPressed: (){
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: Text(selectedItem?.name ?? defaultValue),
            );
          },
          menuChildren: values.map((e) {
            return MenuItemButton(
              onPressed: () {
                selectedItem = e;
                setState(() {});
                onChanged.call(e);
              },
              child: Text(e.name),
            );
          }).toList(),
        );
      }
    );
  }
}


