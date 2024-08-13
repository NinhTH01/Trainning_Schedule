import 'package:flutter/material.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/screens/weather/models/weather_container.dart';

class WeatherWindContainer extends StatelessWidget {
  const WeatherWindContainer({super.key, required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: WeatherHelper.getBackgroundColor(weather.weather?[0].main),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WIND',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child:
                    windItemWidget(weather.wind!.speed! * 3.6, 'KM/H', 'Wind'),
              ),
              Expanded(
                child: windItemWidget(
                  weather.wind?.deg,
                  'Degrees',
                  'Wind Direction',
                ),
              ),
            ],
          ),
          const Divider(),
          windItemWidget(
            weather.wind?.gust == null ? null : weather.wind!.gust! * 3.6,
            'KM/H',
            'Gusts',
          ),
        ],
      ),
    );
  }

  Widget windItemWidget(num? value, String unit, String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          value == null ? '_' : value.round().toString(),
          style: const TextStyle(color: Colors.white, fontSize: 32),
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              unit,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
