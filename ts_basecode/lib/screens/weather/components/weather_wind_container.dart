import 'package:flutter/material.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/screens/weather/models/weather_container.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

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
          Text(
            TextConstants.windTitle,
            style: AppTextStyles.white70s16,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: windItemWidget(
                  weather.wind!.speed! * 3.6,
                  TextConstants.kmh,
                  TextConstants.wind,
                ),
              ),
              Expanded(
                child: windItemWidget(
                  weather.wind?.deg,
                  TextConstants.degrees,
                  TextConstants.windDirection,
                ),
              ),
            ],
          ),
          const Divider(),
          windItemWidget(
            weather.wind?.gust == null ? null : weather.wind!.gust! * 3.6,
            TextConstants.kmh,
            TextConstants.gust,
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
              style: AppTextStyles.white70s12w500,
            ),
            Text(
              name,
              style: AppTextStyles.whites12w500,
            ),
          ],
        ),
      ],
    );
  }
}
