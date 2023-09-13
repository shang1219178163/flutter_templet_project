
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:flutter_templet_project/vendor/flutter_pickers/address_picker_page.dart';
import 'package:flutter_templet_project/vendor/flutter_pickers/date_picker_page.dart';
import 'package:flutter_templet_project/vendor/flutter_pickers/multiple_link_picker_page.dart';
import 'package:flutter_templet_project/vendor/flutter_pickers/multiple_picker_page.dart';
import 'package:flutter_templet_project/vendor/flutter_pickers/single_picker_page.dart';
import 'package:flutter_templet_project/vendor/flutter_pickers/style_picker_page.dart';


class FlutterPickersDemo extends StatefulWidget {
  const FlutterPickersDemo({super.key});

  @override
  _FlutterPickersDemoState createState() => _FlutterPickersDemoState();
}

class _FlutterPickersDemoState extends State<FlutterPickersDemo> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter选择器'),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      children: [
        _itemView('地址选择器', AddressPickerPage()),
        _itemView('单列选择器', SinglePickerPage()),
        _itemView('多列选择器(无联动)', MultiplePickerPage()),
        _itemView('多列选择器（联动）', MultipleLinkPickerPage()),
        _itemView('日期选择器', DatePickerPage()),
        _itemView('内置样式', StylePickerPage()),
      ],
    );
  }

  Widget _itemView(title, Widget page) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          },
          child: NText(title, color: Colors.white),
        ));
  }
}
