//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
//
// class LocationsTarget{
//
//   LocationsTarget(this.isEN);
//
//   bool isEN = false;
//
//   static LocationsTarget? of(BuildContext context){
//     return Localizations.of<LocationsTarget>(context, LocationsTarget);
//   }
//
//   String get title {
//     return this.isEN ? "Flutter APP" : "Flutter应用";
//   }
//
// }
//
//
// class DemoLocalizationsDelegate extends LocalizationsDelegate<LocationsTarget>{
//   const DemoLocalizationsDelegate()
//
//   static const List<String> langlist = <String>['zh', 'en',];
//
//   @override
//   bool isSupported(Locale locale) {
//     // TODO: implement isSupported
//     return langlist.contains(locale.languageCode);
//   }
//
//
//   @override
//   Future<LocationsTarget> load(Locale locale) {
//     // TODO: implement load
//     return SynchronousFuture(LocationsTarget);
//   }
//
//   @override
//   bool shouldReload(covariant LocalizationsDelegate<LocationsTarget> old) {
//     // TODO: implement shouldReload
//     throw UnimplementedError();
//   }
// }