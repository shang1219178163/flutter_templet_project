import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_drop_menu_filter_section_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/extension/dlog.dart';

class DropdownMenuDemo extends StatefulWidget {
  DropdownMenuDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _DropdownMenuDemoState createState() => _DropdownMenuDemoState();
}

class _DropdownMenuDemoState extends State<DropdownMenuDemo> {
  final colorController = TextEditingController();
  final iconController = TextEditingController();

  ColorLabel? selectedColor;
  IconLabel? selectedIcon;

  final colorEntries = ColorLabel.values.map((e) {
    return DropdownMenuEntry<ColorLabel>(
        value: e, label: e.label, enabled: e.label != 'Grey');
  }).toList();

  final iconEntries = IconLabel.values.map((e) {
    return DropdownMenuEntry<IconLabel>(value: e, label: e.label);
  }).toList();

  final _selectedItemVN = ValueNotifier<BoxFit>(BoxFit.none);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            NSectionBox(
              title: "DropdownMenu",
              child: buildDropdownMenu(),
            ),
            NSectionBox(
              title: "MenuAnchor",
              child: buildMenuAnchor<BoxFit>(
                values: BoxFit.values,
                initialItem: BoxFit.values[0],
                cbName: (e) => e.name,
                onChanged: (BoxFit e) {
                  debugPrint(e.name);
                  _selectedItemVN.value = e;
                },
              ),
            ),
            NSectionBox(
              title: "PatientFilterSectionBar",
              child: NDropMenuFilterSectionBar(
                onChanged: (e) {
                  DLog.d(jsonEncode(e.toJson()));
                },
                onSearchChanged: (String value) {
                  DLog.d("onSearchChanged: $value");
                },
                onItemName: (name) => "$name${"\t\t" * 9}",
                constraints: BoxConstraints(
                  maxHeight: 300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// DropdownMenu 下拉菜单
  Widget buildDropdownMenu() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownMenu<ColorLabel>(
                controller: colorController,
                initialSelection: ColorLabel.green,
                label: const Text('Color'),
                dropdownMenuEntries: colorEntries,
                onSelected: (ColorLabel? color) {
                  selectedColor = color;
                  setState(() {});
                },
              ),
              const SizedBox(width: 20),
              DropdownMenu<IconLabel>(
                controller: iconController,
                enableFilter: true,
                leadingIcon: const Icon(Icons.search),
                label: const Text('Icon'),
                dropdownMenuEntries: iconEntries,
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                ),
                onSelected: (IconLabel? icon) {
                  selectedIcon = icon;
                  setState(() {});
                },
              )
            ],
          ),
        ),
        if (selectedColor != null && selectedIcon != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  'You selected a ${selectedColor?.label} ${selectedIcon?.label}'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  selectedIcon?.icon,
                  color: selectedColor?.color,
                ),
              )
            ],
          )
        else
          const Text('Please select a color and an icon.')
      ],
    );
  }

  /// MenuAnchor 下拉菜单
  Widget buildMenuAnchor<E>({
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
          return itemBuilder?.call(controller, selectedItem) ??
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    // padding: EdgeInsets.zero,
                    // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    // minimumSize: Size(50, 18),
                    ),
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
}

enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  grey('Grey', Colors.grey);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}

enum IconLabel {
  smile('Smile', Icons.sentiment_satisfied_outlined),
  cloud(
    'Cloud',
    Icons.cloud_outlined,
  ),
  brush('Brush', Icons.brush_outlined),
  heart('Heart', Icons.favorite);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}
