import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/SynHomeNavWidget.dart';
import 'package:flutter_templet_project/extension/buildContext_extension.dart';

class SynHomeNavDemo extends StatefulWidget {

  final String? title;

  SynHomeNavDemo({ Key? key, this.title}) : super(key: key);


  @override
  _SynHomeNavDemoState createState() => _SynHomeNavDemoState();
}

class _SynHomeNavDemoState extends State<SynHomeNavDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildBody(),
    );
  }

  _buildBody() {
    return Container(
      // height: 200,
      // width: 400,
      constraints: BoxConstraints(
        maxHeight: 200,
      ),
      margin: EdgeInsets.all(12),
      child: SynHomeNavWidget(
        width: screenSize.width - 24,
        // height: 500,
      ),
    );
  }

}