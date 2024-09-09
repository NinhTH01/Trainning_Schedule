import 'package:flutter/material.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/data/models/api/responses/weather_entry/weather_entry.dart';
import 'package:ts_basecode/data/models/api/responses/weather_forecast/weather_forecast.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/screens/weather/helpers/weather_helper.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';
import 'package:ts_basecode/utilities/extensions/weather_status_extension.dart';

class WeatherForecastView extends StatelessWidget {
  const WeatherForecastView({
    super.key,
    required this.weather,
    required this.weatherForecast,
  });

  final WeatherForecast weatherForecast;

  final Weather weather;

  Icon? getWeatherForecastIcon(WeatherEntry? weatherForecastItem) {
    if (weatherForecastItem?.weather?.firstOrNull == null) {
      return const Icon(Icons.cloud, size: 20.0, color: Colors.grey);
    } else {
      return weatherForecastItem?.weather?[0].mainWeatherStatus!
          .getWeatherIcon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: weather.weatherDataList?[0].mainWeatherStatus == null
            ? ColorName.clearColor
            : weather.weatherDataList?[0].mainWeatherStatus!
                .getBackgroundColor(),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextConstants.weatherForecastDescription,
            style: AppTextStyles.s12w700.copyWith(
              color: ColorName.white,
            ),
            textAlign: TextAlign.start,
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weatherForecast.list?.length,
              itemBuilder: (context, index) {
                final weatherForecastItem = weatherForecast.list?[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 24.0, top: 4.0),
                  child: Column(
                    children: [
                      Text(
                        weatherForecastItem?.dateTime != null
                            ? WeatherHelper.unixToHH(
                                weatherForecastItem!.dateTime!)
                            : '_',
                        style: AppTextStyles.s12w700.copyWith(
                          color: ColorName.white,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: getWeatherForecastIcon(weatherForecastItem)),
                      Text(
                        '${weatherForecastItem?.main?.temp?.round()}°',
                        style: AppTextStyles.s12w700.copyWith(
                          color: ColorName.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
