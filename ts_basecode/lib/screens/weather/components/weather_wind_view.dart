import 'package:flutter/material.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/screens/weather/helpers/weather_helper.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

class WeatherWindView extends StatelessWidget {
  const WeatherWindView({super.key, required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: WeatherHelper.getBackgroundColor(
            weather.weatherDataList?[0].mainWeatherStatus),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextConstants.windTitle,
            style: AppTextStyles.s16w700.copyWith(
              color: ColorName.white70,
            ),
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
          style: AppTextStyles.s30w500.copyWith(color: ColorName.white),
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(unit,
                style: AppTextStyles.s12w500.copyWith(
                  color: ColorName.white70,
                )),
            Text(
              name,
              style: AppTextStyles.s12w500.copyWith(
                color: ColorName.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
