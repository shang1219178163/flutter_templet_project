import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class RxDartProviderDemo extends StatefulWidget {

  const RxDartProviderDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _RxDartProviderDemoState createState() => _RxDartProviderDemoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _RxDartProviderDemoState extends State<RxDartProviderDemo> {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CounterBloc>(context);

    return Provider<CounterBloc>(
      create: (context) => bloc,
      // dispose: (context, bloc) => bloc.dispose(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title ?? "$widget"),
          ),
          body: Center(
            child: StreamBuilder<int>(
              stream: bloc.intSubject.stream,
              initialData: bloc.intSubject.value,
              builder: (context, snapshot) {
                return Text('${snapshot.data}');
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                bloc.increment();
              })),
    );
  }
}

class CounterBloc {
  // final ValueNotifier<int> intSubject = ValueNotifier(0);
  var intSubject = BehaviorSubject.seeded(0);

  // get stream => intSubject.stream;
  // int get value => intSubject.value;

  increment() {
    intSubject.value++;
  }

  dispose() {
    intSubject.close();
  }
}
