

import 'package:flutter/material.dart';

class DropdownMenuDemo extends StatefulWidget {

  DropdownMenuDemo({
    Key? key, 
    this.title
  }) : super(key: key);

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
      value: e,
      label: e.label,
      enabled: e.label != 'Grey'
    );
  }).toList();

  final iconEntries = IconLabel.values.map((e) {
    return DropdownMenuEntry<IconLabel>(
      value: e,
      label: e.label
    );
  }).toList();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: SafeArea(
        child: Column(
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
        ),
      ),
    );
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
  cloud('Cloud', Icons.cloud_outlined,),
  brush('Brush', Icons.brush_outlined),
  heart('Heart', Icons.favorite);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}
