import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/dlog.dart';

class StreamControllerDemo extends StatefulWidget {
  const StreamControllerDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<StreamControllerDemo> createState() => _StreamControllerDemoState();
}

class _StreamControllerDemoState extends State<StreamControllerDemo> {
  final scrollController = ScrollController();

  final StreamController<String> streamController = StreamController<String>();

  final valueVN = ValueNotifier("");

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    streamController.stream.listen((value) {
      DLog.d(value);
      valueVN.value = value;
    });
  }

  @override
  void didUpdateWidget(covariant StreamControllerDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container(
            //   height: 100,
            //   width: double.infinity,
            //   child: StreamBuilder<String>(
            //     stream: streamController.stream,
            //     builder: ((context, snapshot) {
            //       if (snapshot.hasError) {
            //         return Text("error");
            //       }
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return CupertinoActivityIndicator();
            //       }
            //
            //       final value = snapshot.data ?? '';
            //       return Container(
            //         decoration: BoxDecoration(
            //           color: Colors.transparent,
            //           border: Border.all(color: Colors.blue),
            //           borderRadius: BorderRadius.all(Radius.circular(0)),
            //         ),
            //         child: Text(value),
            //       );
            //     }),
            //   ),
            // ),

            ValueListenableBuilder(
              valueListenable: valueVN,
              builder: (context, value, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  child: Text(value),
                );
              },
            ),
            buildWrap(
              onItem: (String value) {
                streamController.add(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWrap({required ValueChanged<String> onItem}) {
    final list = List.generate(8, (i) => i);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final spacing = 8.0;
        final rowCount = 4.0;
        final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...list.map((e) {
              final btnTitle = "card $e";
              return GestureDetector(
                onTap: () => onItem(btnTitle),
                child: Container(
                  width: itemWidth.truncateToDouble(),
                  height: itemWidth * 1.2,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  child: Text(btnTitle),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
