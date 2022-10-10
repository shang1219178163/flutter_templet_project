import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShortcutsDemoOne extends StatefulWidget {

  final String? title;

  ShortcutsDemoOne({ Key? key, this.title}) : super(key: key);


  @override
  _ShortcutsDemoOneState createState() => _ShortcutsDemoOneState();
}

class _ShortcutsDemoOneState extends State<ShortcutsDemoOne> {
  Model model = Model();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
      ),
      body: Shortcuts(
        shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const IncrementIntent(2),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const DecrementIntent(2),
      },
        child: Actions(
          actions: <Type, Action<Intent>>{
            IncrementIntent: IncrementAction(model),
            DecrementIntent: DecrementAction(model),
          },
          child: Focus(
            autofocus: true,
            child: Column(
              children: <Widget>[
                const Text('Add to the counter by pressing the up arrow key'),
                const Text(
                    'Subtract from the counter by pressing the down arrow key'),
                AnimatedBuilder(
                  animation: model,
                  builder: (BuildContext context, Widget? child) {
                    return Text('count: ${model.count}');
                  },
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
class Model with ChangeNotifier {
  int count = 0;
  void incrementBy(int amount) {
    count += amount;
    notifyListeners();
  }

  void decrementBy(int amount) {
    count -= amount;
    notifyListeners();
  }
}

class IncrementIntent extends Intent {
  const IncrementIntent(this.amount);

  final int amount;
}

class DecrementIntent extends Intent {
  const DecrementIntent(this.amount);

  final int amount;
}

class IncrementAction extends Action<IncrementIntent> {
  IncrementAction(this.model);

  final Model model;

  @override
  void invoke(covariant IncrementIntent intent) {
    model.incrementBy(intent.amount);
  }
}

class DecrementAction extends Action<DecrementIntent> {
  DecrementAction(this.model);

  final Model model;

  @override
  void invoke(covariant DecrementIntent intent) {
    model.decrementBy(intent.amount);
  }
}