import 'package:flutter/material.dart';
import 'package:flutter_templet_project/pages/demo/weather/models/weather_type.dart';
import 'package:flutter_templet_project/pages/demo/weather/widgets/weather_effects/cloudy_effect.dart';
import 'package:flutter_templet_project/pages/demo/weather/widgets/weather_effects/foggy_effect.dart';
import 'package:flutter_templet_project/pages/demo/weather/widgets/weather_effects/rain_effect.dart';
import 'package:flutter_templet_project/pages/demo/weather/widgets/weather_effects/snow_effect.dart';
import 'package:flutter_templet_project/pages/demo/weather/widgets/weather_effects/sunny_effect.dart';
import 'package:flutter_templet_project/pages/demo/weather/widgets/weather_effects/thunderstorm_effect.dart';

class WeatherCard extends StatelessWidget {
  final WeatherType weatherType;
  final double animationSpeed;

  const WeatherCard({
    super.key,
    required this.weatherType,
    this.animationSpeed = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullScreenWeather(context),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  weatherType.cardColor,
                  weatherType.cardColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Stack(
              children: [
                // 天气效果层
                _buildWeatherEffect(),

                // 信息层
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Spacer(),
                      Text(
                        weatherType.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 2, offset: Offset(1, 1))],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weatherType.temperature,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 2, offset: Offset(1, 1))],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherEffect() {
    // 为不同类型的天气效果提供不同的默认速度
    double speed = animationSpeed;

    // 雾和雪需要更慢的默认速度
    if (weatherType == WeatherType.foggy || weatherType == WeatherType.snowy) {
      speed = animationSpeed * 0.5;
    }
    // 雨天稍慢一点
    else if (weatherType == WeatherType.rainy) {
      speed = animationSpeed * 0.8;
    }

    switch (weatherType) {
      case WeatherType.sunny:
        return SunnyEffect(animationSpeed: speed);
      case WeatherType.rainy:
        return RainEffect(animationSpeed: speed);
      case WeatherType.snowy:
        return SnowEffect(animationSpeed: speed);
      case WeatherType.cloudy:
        return CloudyEffect(animationSpeed: speed);
      case WeatherType.thunderstorm:
        return ThunderstormEffect(animationSpeed: speed);
      case WeatherType.foggy:
        return FoggyEffect(animationSpeed: speed);
    }
  }

  void _showFullScreenWeather(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(weatherType.name),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  weatherType.cardColor,
                  weatherType.cardColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Stack(
              children: [
                _buildWeatherEffect(),
                Center(
                  child: Text(
                    weatherType.temperature,
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 4, offset: Offset(2, 2))],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
