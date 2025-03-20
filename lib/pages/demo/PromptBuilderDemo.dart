import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/PromptBuilder.dart';

class PromptBuilderDemo extends StatefulWidget {
  final String? title;

  const PromptBuilderDemo({Key? key, this.title}) : super(key: key);

  @override
  _PromptBuilderDemoState createState() => _PromptBuilderDemoState();
}

class _PromptBuilderDemoState extends State<PromptBuilderDemo> with WidgetsBindingObserver {
  int _counter = 0;
  GlobalKey centerWidgetKey = GlobalKey();
  GlobalKey bottomWidgetKey = GlobalKey();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    // 页面展示时进行prompt绘制，在此添加observer监听等待渲染完成后挂载prompt
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var prompts = <PromptItem>[];
      prompts.add(PromptItem(centerWidgetKey, "这是中心Widget"));
      prompts.add(PromptItem(bottomWidgetKey, "这是底部Button"));

      PromptBuilder.promptToWidgets(prompts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          // 需要高亮展示的widget，需要声明其GlobalKey
          key: centerWidgetKey,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // 需要高亮展示的widget，需要声明其GlobalKey
        key: bottomWidgetKey,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
