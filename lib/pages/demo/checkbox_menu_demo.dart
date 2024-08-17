import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckboxMenuDemo extends StatefulWidget {
  const CheckboxMenuDemo({super.key, required this.message});

  final String message;

  @override
  State<CheckboxMenuDemo> createState() => _CheckboxMenuDemoState();
}

class _CheckboxMenuDemoState extends State<CheckboxMenuDemo> {
  final _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  static const _showShortcut =
      SingleActivator(LogicalKeyboardKey.keyS, control: true);
  bool _showing = false;

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  void _setMessageVisibility(bool visible) {
    setState(() {
      _showing = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        _showShortcut: () {
          _setMessageVisibility(!_showing);
        },
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MenuAnchor(
            childFocusNode: _buttonFocusNode,
            menuChildren: <Widget>[
              CheckboxMenuButton(
                value: _showing,
                onChanged: (bool? value) {
                  _setMessageVisibility(value!);
                },
                child: const Text('Show Message'),
              ),
              RadioMenuButton(
                groupValue: 0,
                value: 0,
                onChanged: (int? value) {},
                child: const Text('two'),
              ),
            ],
            builder: (context, MenuController controller, Widget? child) {
              return TextButton(
                focusNode: _buttonFocusNode,
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                child: const Text('OPEN MENU'),
              );
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      _showing ? widget.message : '',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
