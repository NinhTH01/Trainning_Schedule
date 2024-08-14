import 'package:flutter/material.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/data/models/api/responses/weather_forecast/weather_forecast.dart';
import 'package:ts_basecode/screens/weather/models/weather_container.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

class WeatherForecastContainer extends StatelessWidget {
  const WeatherForecastContainer({
    super.key,
    required this.weather,
    required this.weatherForecast,
  });

  final WeatherForecast weatherForecast;

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
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
            TextConstants.weatherForecastDescription,
            style: AppTextStyles.whites12,
            textAlign: TextAlign.start,
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weatherForecast.list?.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 24.0, top: 4.0),
                  child: Column(
                    children: [
                      Text(
                        weatherForecast.list?[index].dt != null
                            ? WeatherHelper.unixToHH(
                                weatherForecast.list![index].dt!)
                            : '_',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: WeatherHelper.getWeatherIcon(
                          weatherForecast.list?[index].weather?[0].main,
                        ),
                      ),
                      Text(
                        '${weatherForecast.list?[index].main?.temp?.round()}°',
                        style: AppTextStyles.whitew500,
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
