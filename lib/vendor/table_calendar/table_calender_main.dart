import 'package:flutter/material.dart';

import 'package:flutter_templet_project/vendor/table_calendar/basics_example.dart';
import 'package:flutter_templet_project/vendor/table_calendar/complex_example.dart';
import 'package:flutter_templet_project/vendor/table_calendar/events_example.dart';
import 'package:flutter_templet_project/vendor/table_calendar/multi_example.dart';
import 'package:flutter_templet_project/vendor/table_calendar/range_example.dart';

class TableCalenderMain extends StatefulWidget {
  TableCalenderMain({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TableCalenderMainState createState() => _TableCalenderMainState();
}

class _TableCalenderMainState extends State<TableCalenderMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Basics'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableBasicsExample()),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Range Selection'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableRangeExample()),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Events'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableEventsExample()),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Multiple Selection'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableMultiExample()),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('Complex'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableComplexExample()),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  buildBtn({required String title, required Widget page}) {
    return ElevatedButton(
      child: Text(title),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
    );
  }
}
