// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/date_time_ext.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_templet_project/vendor/table_calendar/table_calendar_utils.dart';

class TableBasicsExample extends StatefulWidget {
  const TableBasicsExample({Key? key}) : super(key: key);

  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  // DateTime _focusedDay = DateTime.now();
  DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, 9);

  DateTime? _selectedDay;

  final indexs = List.generate(9, (index) => index);
  late final dateTimes = indexs.map((e) => DateTime(2023, 6, e)).toList();

  final eventTypes = [
    Tuple2("已完成事项", Color(0xff37C2BC), ),
    Tuple2("待处理事项", Color(0xff5690F4), ),
    Tuple2("未完成事项", Color(0xffEB6A54), ),
  ];

  final _selectedEvents = ValueNotifier(<Event>[]);

  final events = [
    Event('Today\'s Event 1'),
    Event('Today\'s Event 2'),
    Event('Today\'s Event 11'),
    Event('Today\'s Event 12'),
    Event('Today\'s Event 21'),
    Event('Today\'s Event 22'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    _selectedEvents.value = events;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Basics'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      // color: Colors.yellowAccent,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TableCalendar(
            locale: "zh-CN",
            availableGestures: AvailableGestures.horizontalSwipe,
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              // headerPadding: EdgeInsets.zero,
              leftChevronMargin: EdgeInsets.zero,
              rightChevronMargin: EdgeInsets.zero,
              leftChevronPadding: EdgeInsets.all(0),
              rightChevronPadding: EdgeInsets.all(0),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay){
                // debugPrint("todayBuilder: $day, $focusedDay");
                return Container(
                  margin: EdgeInsets.all(6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: [Colors.green, Colors.blue, Colors.orange][Random().nextInt(3)],
                    shape: BoxShape.circle,
                  ),
                  child: Text("${day.day}\n${day.weekday}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                );
              },
              todayBuilder: (context, day, focusedDay){
                // debugPrint("todayBuilder: $day, $focusedDay");
                return Container(
                  margin: EdgeInsets.all(6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text("今", style: TextStyle(color: Colors.white),),
                );
              },
              selectedBuilder: (context, day, focusedDay){
                // debugPrint("todayBuilder: $day, $focusedDay");
                return Container(
                  margin: EdgeInsets.all(6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xffD8D8D8),
                    shape: BoxShape.circle,
                  ),
                  child: Text("${day.day}", style: TextStyle(color: Color(0xff181818)),),
                );
              },
            ),
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            // calendarFormat: _calendarFormat,
            selectedDayPredicate: (val) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, val);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                setState(() {});
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              debugPrint("onPageChanged: $focusedDay");
              // No need to call `setState()` here
              _focusedDay = focusedDay;

              final first = _focusedDay.calenderMonthPageFisrtDayStr(format: DATE_FORMAT_DAY);
              final last = _focusedDay.calenderMonthPageLastDayStr(format: DATE_FORMAT_DAY_END);
              debugPrint("onPageChanged: calenderMonthPage $first, $last");
            },
          ),
          Container(
            height: 50,
            // color: Colors.red,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: eventTypes.map((e) {
                  return TextButton.icon(
                    onPressed: (){

                    },
                    icon: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: e.item2,
                        shape: BoxShape.circle,
                      ),
                    ),
                    label: Text(e.item1),
                  );
                }).toList()
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {

                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final e = value[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => debugPrint('${e.title}'),
                        title: Text('${e.title}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
