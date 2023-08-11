

import 'package:flutter/cupertino.dart';

class AppCupertinoLocalizations extends CupertinoLocalizations {

  final CupertinoLocalizations localizations;

  AppCupertinoLocalizations(this.localizations);

  //只改此处，其它的都原数据返回
  @override
  DatePickerDateOrder get datePickerDateOrder => DatePickerDateOrder.ymd;

  @override
  String get modalBarrierDismissLabel => localizations.modalBarrierDismissLabel;

  @override
  String get selectAllButtonLabel => localizations.selectAllButtonLabel;

  @override
  String get pasteButtonLabel => localizations.pasteButtonLabel;

  @override
  String get copyButtonLabel => localizations.copyButtonLabel;

  @override
  String get cutButtonLabel => localizations.cutButtonLabel;

  @override
  String datePickerYear(int yearIndex) {
    return "$yearIndex";
    // return localizations.datePickerYear(yearIndex);
  }

  @override
  String? timerPickerSecondLabel(int second) => localizations.timerPickerSecondLabel(second);

  @override
  String? timerPickerMinuteLabel(int minute) => localizations.timerPickerMinuteLabel(minute);

  @override
  String? timerPickerHourLabel(int hour) => localizations.timerPickerHourLabel(hour);

  @override
  String timerPickerSecond(int second) => localizations.timerPickerSecond(second);

  @override
  String timerPickerMinute(int minute) => localizations.timerPickerMinute(minute);

  @override
  String timerPickerHour(int hour) => localizations.timerPickerHour(hour);

  @override
  String tabSemanticsLabel({
    required int tabIndex,
    required int tabCount
  }) => localizations.tabSemanticsLabel(tabIndex: tabIndex, tabCount: tabCount);

  @override
  String get alertDialogLabel => localizations.alertDialogLabel;

  @override
  String get todayLabel => localizations.todayLabel;

  @override
  String get postMeridiemAbbreviation => localizations.postMeridiemAbbreviation;

  @override
  String get anteMeridiemAbbreviation => localizations.anteMeridiemAbbreviation;

  @override
  DatePickerDateTimeOrder get datePickerDateTimeOrder => localizations.datePickerDateTimeOrder;

  @override
  String? datePickerMinuteSemanticsLabel(int minute) => localizations.datePickerMinuteSemanticsLabel(minute);

  @override
  String datePickerMinute(int minute) => localizations.datePickerMinute(minute);

  @override
  String? datePickerHourSemanticsLabel(int hour) => localizations.datePickerHourSemanticsLabel(hour);

  @override
  String datePickerHour(int hour) => localizations.datePickerHour(hour);

  @override
  String datePickerMediumDate(DateTime date) => localizations.datePickerMediumDate(date);

  @override
  String datePickerDayOfMonth(int dayIndex, [int? weekDay]) => localizations.datePickerDayOfMonth(dayIndex);

  @override
  String datePickerMonth(int monthIndex) => localizations.datePickerMonth(monthIndex);

  @override
  String get searchTextFieldPlaceholderLabel => localizations.searchTextFieldPlaceholderLabel;

  @override
  List<String> get timerPickerHourLabels => localizations.timerPickerHourLabels;

  @override
  List<String> get timerPickerMinuteLabels => localizations.timerPickerMinuteLabels;

  @override
  List<String> get timerPickerSecondLabels => localizations.timerPickerSecondLabels;

  @override
  // TODO: implement noSpellCheckReplacementsLabel
  String get noSpellCheckReplacementsLabel => throw UnimplementedError();

}

class AppGlobalCupertinoLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {

  @override
  bool isSupported(Locale locale) => DefaultCupertinoLocalizations.delegate.isSupported(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    var localizations = await DefaultCupertinoLocalizations.delegate.load(locale);
    return AppCupertinoLocalizations(localizations);
  }

  @override
  bool shouldReload(LocalizationsDelegate<CupertinoLocalizations> old) =>
      DefaultCupertinoLocalizations.delegate.shouldReload(old);

  @override
  String toString() => 'AppGlobalCupertinoLocalizationsDelegate';
}


