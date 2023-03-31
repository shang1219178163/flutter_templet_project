import 'package:flutter/material.dart';

class RefreshIndicatorDemo extends StatefulWidget {

  const RefreshIndicatorDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _RefreshIndicatorDemoState createState() => _RefreshIndicatorDemoState();
}

class _RefreshIndicatorDemoState extends State<RefreshIndicatorDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => print(e),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Show refresh indicator programmatically on button tap.
          _refreshIndicatorKey.currentState?.show();
        },
        icon: const Icon(Icons.refresh),
        label: const Text('Show Indicator'),
      ),
      body: buildBody(),
    );
  }

  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Widget buildBody() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      color: Colors.white,
      backgroundColor: Colors.blue,
      strokeWidth: 4.0,
      onRefresh: () async {
        // Replace this delay with the code to be executed during refresh
        // and return a Future when code finishs execution.
        return Future<void>.delayed(const Duration(seconds: 3));
      },
      // Pull from top to show refresh indicator.
      child: ListView.builder(
        itemCount: 25,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Item $index'),
          );
        },
      ),
    );
  }

}

