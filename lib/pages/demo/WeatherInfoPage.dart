import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/model/open_weather_model.dart';

// final openWeatherApiKey = "37d219e123620b3fba883e29dabbf559";
final openWeatherApiKey = "4b2ad124d9d8e2cbe5334194cac57dec";

class WeatherInfoPage extends StatefulWidget {
  WeatherInfoPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _WeatherInfoPageState createState() => _WeatherInfoPageState();
}

class _WeatherInfoPageState extends State<WeatherInfoPage> {
  final contentVN = ValueNotifier("");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: onPressed,
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ValueListenableBuilder(
              valueListenable: contentVN,
              builder: (context, value, child) {
                return NText(
                  value,
                  maxLines: 100,
                );
              }),
        ],
      ),
    );
  }

  onPressed() async {
    await requestWeather2();
  }

  requestWeather() async {
    var url =
        "https://api.openweathermap.org/data/2.5/weather?id=1790630&appid=$openWeatherApiKey";

    // url = "https://openweathermap.org/data/2.5/onecall?lat=34.2583&lon=108.9286&units=metric&appid=$openWeatherApiKey";

    try {
      debugPrint("url: $url");

      final response = await Dio().get(
        url,
      );
      final map = response.data;
      debugPrint("jsonStr: ${jsonEncode(map)}");

      final rootModel = OpenWeatherRoot.fromJson(Map.from(map));
      debugPrint("rootModel: ${rootModel.runtimeType}");

      contentVN.value = map.toString();
    } catch (e) {
      contentVN.value = e.toString();
    }
  }

  requestWeather2() async {
    var url =
        "https://api.openweathermap.org/data/2.5/forecast?id=1790630&appid=$openWeatherApiKey";

    try {
      debugPrint("url: $url");

      final response = await Dio().get(
        url,
      );
      final map = response.data;
      // debugPrint("jsonStr: ${jsonEncode(map)}");

      final rootModel = OpenWeatherForecast.fromJson(Map.from(map));
      debugPrint("rootModel: ${rootModel.runtimeType}");

      contentVN.value = map.toString();
    } catch (e) {
      contentVN.value = e.toString();
    }
  }
}
