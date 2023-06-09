

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SyncfusionFlutterDatepickerDemo extends StatefulWidget {

  SyncfusionFlutterDatepickerDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _SyncfusionFlutterDatepickerDemoState createState() => _SyncfusionFlutterDatepickerDemoState();
}

class _SyncfusionFlutterDatepickerDemoState extends State<SyncfusionFlutterDatepickerDemo> {


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
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildMutiple(),
          ],
        ),
      )
    );
  }
  
  buildMutiple() {
    final initialSelectedDates = [
      DateTime(2023, 6, 1),
      DateTime(2023, 6, 3),
      DateTime(2023, 6, 5),
    ];

    return SfDateRangePicker(
      allowViewNavigation: false,
      // view: DateRangePickerView.month,
      selectionMode: DateRangePickerSelectionMode.multiple,
      initialSelectedDates: initialSelectedDates,
      cellBuilder: (BuildContext context, DateRangePickerCellDetails details) {
        final bool isToday = isSameDate(details.date, DateTime.now());
        if (initialSelectedDates.contains(details.date)) {
          return Container(
            // margin: EdgeInsets.all(2),
            // padding: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.red,
              border: isToday
                  ? Border.all(color: Colors.black, width: 2)
                  : null,
              shape: BoxShape.circle,
            ),
            child: Text(details.date.day.toString()),
          );
        }
        return Container(
          // margin: EdgeInsets.all(2),
          // padding: EdgeInsets.only(top: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              // color: Colors.blueAccent,
              border: isToday
                  ? Border.all(color: Colors.black, width: 2)
                  : null,
            shape: BoxShape.circle,
          ),
          child: Text(details.date.day.toString()),
        );
      },
    );
  }

  bool isSameDate(DateTime date, DateTime dateTime) {
    if (date.year == dateTime.year &&
        date.month == dateTime.month &&
        date.day == dateTime.day) {
      return true;
    }

    return false;
  }
}