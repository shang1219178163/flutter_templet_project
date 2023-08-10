

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_page_view.dart';

class NPageViewDemo extends StatefulWidget {

  NPageViewDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _NPageViewDemoState createState() => _NPageViewDemoState();
}

class _NPageViewDemoState extends State<NPageViewDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody()
    );
  }

  buildBody() {
    return NPageView();
  }

}