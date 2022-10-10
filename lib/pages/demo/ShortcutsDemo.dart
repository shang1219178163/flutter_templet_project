import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShortcutsDemo extends StatefulWidget {

  final String? title;

  ShortcutsDemo({ Key? key, this.title}) : super(key: key);


  @override
  _ShortcutsDemoState createState() => _ShortcutsDemoState();
}

class _ShortcutsDemoState extends State<ShortcutsDemo> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Shortcuts(
        shortcuts: <ShortcutActivator, Intent>{
          LogicalKeySet(LogicalKeyboardKey.arrowUp): const IncrementIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): const DecrementIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            IncrementIntent: CallbackAction<IncrementIntent>(
              onInvoke: (IncrementIntent intent) => setState(() {
                count++;
              }),
            ),
            DecrementIntent: CallbackAction<DecrementIntent>(
              onInvoke: (DecrementIntent intent) => setState(() {
                count--;
              }),
            ),
          },
          child: Focus(
            autofocus: true,
            child: Column(
              children: <Widget>[
                const Text('Add to the counter by pressing the up arrow key'),
                const Text(
                    'Subtract from the counter by pressing the down arrow key'),
                Text('count: $count'),
              ],
            ),
          ),
        ),
      )
    );
  }
}



class IncrementIntent extends Intent {
  const IncrementIntent();
}

class DecrementIntent extends Intent {
  const DecrementIntent();
}
