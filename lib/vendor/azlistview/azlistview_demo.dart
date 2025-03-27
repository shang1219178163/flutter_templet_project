import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/azlistview/ui/car_models_page.dart';
import 'package:flutter_templet_project/vendor/azlistview/ui/citylist_custom_header_page.dart';
import 'package:flutter_templet_project/vendor/azlistview/ui/citylist_page.dart';
import 'package:flutter_templet_project/vendor/azlistview/ui/contacts_list_page.dart';
import 'package:flutter_templet_project/vendor/azlistview/ui/contacts_page.dart';
import 'package:flutter_templet_project/vendor/azlistview/ui/github_language_page.dart';
import 'package:flutter_templet_project/vendor/azlistview/ui/large_data_page.dart';
import 'package:flutter_templet_project/vendor/azlistview/ui/page_scaffold.dart';

/// 分组列表三方库
class AzlistviewDemo extends StatefulWidget {
  AzlistviewDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _AzlistviewDemoState createState() => _AzlistviewDemoState();
}

class _AzlistviewDemoState extends State<AzlistviewDemo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: onPressed,
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return ListPage([
      PageInfo("GitHub Languages", (ctx) => GitHubLanguagePage(), false),
      PageInfo("Contacts", (ctx) => ContactsPage(), false),
      PageInfo("Contacts List", (ctx) => ContactListPage()),
      PageInfo("City List", (ctx) => CityListPage(), false),
      PageInfo("City List(Custom header)", (ctx) => CityListCustomHeaderPage()),
      PageInfo("Car models", (ctx) => CarModelsPage(), false),
      PageInfo("10000 data", (ctx) => LargeDataPage(), false),
    ]);
  }

  onPressed() {}
}
