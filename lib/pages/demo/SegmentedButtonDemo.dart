
//
//  SegmentedButtonDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/4/21 10:54 AM.
//  Copyright © 6/4/21 shang. All rights reserved.
//



import 'package:flutter/material.dart';


class SegmentedButtonDemo extends StatefulWidget {

  final String? title;

  const SegmentedButtonDemo({ Key? key, this.title}) : super(key: key);


  @override
  _SegmentedButtonDemoState createState() => _SegmentedButtonDemoState();
}

class _SegmentedButtonDemoState extends State<SegmentedButtonDemo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Single choice'),
          SingleChoice(),
          SizedBox(height: 20),
          Text('Multiple choice'),
          MultipleChoice(),
          Spacer(),
        ],
      ),
    );
  }
}

enum Calendar { day, week, month, year }

class SingleChoice extends StatefulWidget {
  const SingleChoice({super.key});

  @override
  State<SingleChoice> createState() => _SingleChoiceState();
}

class _SingleChoiceState extends State<SingleChoice> {
  Calendar calendarView = Calendar.day;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Calendar>(
      segments: const <ButtonSegment<Calendar>>[
        ButtonSegment<Calendar>(
          value: Calendar.day,
          label: Text('Day'),
          icon: Icon(Icons.calendar_view_day)
        ),
        ButtonSegment<Calendar>(
          value: Calendar.week,
          label: Text('Week'),
          icon: Icon(Icons.calendar_view_week)
        ),
        ButtonSegment<Calendar>(
          value: Calendar.month,
          label: Text('Month'),
          icon: Icon(Icons.calendar_view_month)
        ),
        ButtonSegment<Calendar>(
          value: Calendar.year,
          label: Text('Year'),
          icon: Icon(Icons.calendar_today)
        ),
      ],
      selected: <Calendar>{calendarView},
      onSelectionChanged: (Set<Calendar> newSelection) {
        calendarView = newSelection.first;
        setState(() {});
      },
      style: OutlinedButton.styleFrom(
        // padding: EdgeInsets.zero,
        // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size(50, 18),
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
    );
  }
}

enum Sizes { extraSmall, small, medium, large, extraLarge }

class MultipleChoice extends StatefulWidget {
  const MultipleChoice({super.key});

  @override
  State<MultipleChoice> createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  Set<Sizes> selection = <Sizes>{Sizes.large, Sizes.extraLarge};

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Sizes>(
      segments: const <ButtonSegment<Sizes>>[
        ButtonSegment<Sizes>(value: Sizes.extraSmall, label: Text('XS')),
        ButtonSegment<Sizes>(value: Sizes.small, label: Text('S')),
        ButtonSegment<Sizes>(value: Sizes.medium, label: Text('M')),
        ButtonSegment<Sizes>(
          value: Sizes.large,
          label: Text('L'),
        ),
        ButtonSegment<Sizes>(value: Sizes.extraLarge, label: Text('XL')),
      ],
      selected: selection,
      multiSelectionEnabled: true,
      onSelectionChanged: (Set<Sizes> newSelection) {
        selection = newSelection;
        setState(() {});
      },
      style: OutlinedButton.styleFrom(
        // padding: EdgeInsets.zero,
        // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size(50, 18),
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
