//
//  DateRangePickerDialogDemo.dart
//  flutter_templet_project
//
//  Created by shang on 3/13/23 5:33 PM.
//  Copyright © 3/13/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class DateRangePickerDialogDemo extends StatefulWidget {

  DateRangePickerDialogDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _DateRangePickerDialogDemoState createState() => _DateRangePickerDialogDemoState();
}

class _DateRangePickerDialogDemoState extends State<DateRangePickerDialogDemo> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  final models = DatePickerEntryMode.values;
  var model = DatePickerEntryMode.values[0];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: models.length, vsync: this);
  }

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
          onPressed: () => print("done"),
        )).toList(),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: models.map((e) => Tab(text: e.toString().split(".").last)).toList(),
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          Column(
            children: [
              Container(
                height: 500,
                width: double.infinity,
                padding: EdgeInsets.all(8),
                child: Wrap(
                  children: [
                    ElevatedButton(onPressed: onPressed, child: Text("button")),
                  ],
                ),
              )
            ],
          ),
        ].map((e) => SliverToBoxAdapter(child: e)).toList(),
      ),
    );
  }
  
  onPressed() {
    _showDateRange();
  }

  _showDateRange() async {
    DateTime firstDate = DateTime(2021, 1, 1);
    DateTime lastDate = DateTime.now();

    var range = await showDateRangePicker(
      context: context,
      initialEntryMode: model,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: DateTimeRange(
        start: DateTime(2022, 10, 1),
        end: DateTime(2022, 10, 6),
      ),
      currentDate: DateTime(2022, 10, 8),
    );
    print(range);

  }

}