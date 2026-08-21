import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_webview_page.dart';

class NWebViewDemo extends StatefulWidget {
  NWebViewDemo({super.key, this.title});

  final String? title;

  @override
  State<NWebViewDemo> createState() => _NWebViewDemoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _NWebViewDemoState extends State<NWebViewDemo> {
  final initialUrl = 'https://flutter.dev';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title ?? "$widget"),
      //   actions: ['done',].map((e) => TextButton(
      //     child: Text(e,
      //       style: TextStyle(color: Colors.white),
      //     ),
      //     onPressed: () => debugPrint(e),)
      //   ).toList(),
      // ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return NWebViewPage(
      url: initialUrl,
      title: initialUrl,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('initialUrl', initialUrl));
  }
}
