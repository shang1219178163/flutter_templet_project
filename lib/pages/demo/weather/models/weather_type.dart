import 'package:flutter/material.dart';

enum WeatherType { sunny, rainy, snowy, cloudy, thunderstorm, foggy }

extension WeatherTypeExtension on WeatherType {
  String get name {
    switch (this) {
      case WeatherType.sunny:
        return '晴天';
      case WeatherType.rainy:
        return '雨天';
      case WeatherType.snowy:
        return '雪天';
      case WeatherType.cloudy:
        return '多云';
      case WeatherType.thunderstorm:
        return '雷雨';
      case WeatherType.foggy:
        return '雾天';
    }
  }

  Color get cardColor {
    switch (this) {
      case WeatherType.sunny:
        return Colors.orange.shade300;
      case WeatherType.rainy:
        return Colors.blueGrey.shade400;
      case WeatherType.snowy:
        return Colors.lightBlue.shade100;
      case WeatherType.cloudy:
        return Colors.grey.shade400;
      case WeatherType.thunderstorm:
        return Colors.deepPurple.shade300;
      case WeatherType.foggy:
        return Colors.blueGrey.shade200;
    }
  }

  String get temperature {
    switch (this) {
      case WeatherType.sunny:
        return '28°C';
      case WeatherType.rainy:
        return '18°C';
      case WeatherType.snowy:
        return '-2°C';
      case WeatherType.cloudy:
        return '22°C';
      case WeatherType.thunderstorm:
        return '16°C';
      case WeatherType.foggy:
        return '15°C';
    }
  }
}
