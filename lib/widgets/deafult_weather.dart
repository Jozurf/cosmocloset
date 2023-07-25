import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:cosmocloset/widgets/skelton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DefaultWeather extends StatelessWidget {
  final String? lastKnownTemp;
  final String? lastKnownArea;
  final String? lastKnownWeather;
  const DefaultWeather({super.key, required this.lastKnownTemp, required this.lastKnownArea, required this.lastKnownWeather});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lastKnownTemp == null ? Text("__", style: weatherTemperatureStyle) : Text(lastKnownTemp!, style: weatherTemperatureStyle),
        const SizedBox(width: 12,),
        lastKnownArea == null ? const Text("---------") : Text(lastKnownArea!),
        const SizedBox(width: 12,),
        getWeatherWidget(),
      ],
    );
  }

  Widget getWeatherWidget() {
    switch (lastKnownWeather) {
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
      return const Icon(Icons.sunny, color: textFieldColor, size: 30,);
    }
  }
}
