import 'package:flutter/material.dart';

class DisplayFeatureDemo extends StatefulWidget {
  DisplayFeatureDemo({super.key, this.title});

  final String? title;

  @override
  State<DisplayFeatureDemo> createState() => _DisplayFeatureDemoState();
}

class _DisplayFeatureDemoState extends State<DisplayFeatureDemo> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => debugPrint(e),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Text("$widget"),
            buildSubScreen(),
            buildDisplayFeature(),
          ],
        ),
      ),
    );
  }

  Widget buildSubScreen() {
    return DisplayFeatureSubScreen(
      anchorPoint: Offset.infinite,
      child: Container(
        width: 300,
        height: 300,
        color: Colors.red,
      ),
    );
  }

  Widget buildDisplayFeature() {
    final mediaQuery = MediaQuery.of(context);
    final displayFeatures = mediaQuery.displayFeatures;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (displayFeatures.isNotEmpty)
          ...displayFeatures.map((feature) {
            return Text(
              'Feature type: ${feature.type}, bounds: ${feature.bounds}',
            );
          }).toList()
        else
          const Text('No display features detected.'),
      ],
    );
  }
}
