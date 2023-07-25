import 'package:cosmocloset/resources/fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class WeatherWidget extends StatelessWidget {
  final Weather currentWeather;
  const WeatherWidget({super.key, required this.currentWeather});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(currentWeather.temperature!.celsius!.round().toString(), style: weatherTemperatureStyle,),
        const SizedBox(width: 12,),
        Padding(padding: const EdgeInsets.only(top: 5),child: Text(currentWeather.areaName!)),
        const SizedBox(width: 12,),
        getWeatherWidget(),
      ],
    );
  }
  
  Widget getWeatherWidget() {
    switch (currentWeather.weatherMain) {
      case "Clear":
        return const Icon(Icons.sunny);
      case "Clouds":
        return const Icon(Icons.cloud);
      case "Rain" || "Drizzle":
        return const Icon(Icons.water_drop_rounded);
      case "Thunderstorm":
        return const Icon(Icons.thunderstorm_rounded);
      case "Snow":
        return const Icon(Icons.cloudy_snowing);
      default:
      return Text(currentWeather.weatherMain!, style: weatherTemperatureStyle,);
    }
  }
}