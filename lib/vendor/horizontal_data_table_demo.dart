import 'package:flutter/material.dart';

/// 第三方库 HorizontalDataTable
/// https://pub.dev/packages/horizontal_data_table
class HorizontalDataTableDemo extends StatefulWidget {

  const HorizontalDataTableDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _HorizontalDataTableDemoState createState() => _HorizontalDataTableDemoState();
}

class _HorizontalDataTableDemoState extends State<HorizontalDataTableDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Text(arguments.toString())
    );
  }

}