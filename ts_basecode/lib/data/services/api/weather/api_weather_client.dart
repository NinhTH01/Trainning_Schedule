import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/data/models/api/responses/weather_forecast/weather_forecast.dart';

part 'api_weather_client.g.dart';

@RestApi(baseUrl: 'https://api.openweathermap.org/data/2.5')
abstract class ApiWeatherClient {
  factory ApiWeatherClient(Dio dio, {String baseUrl}) = _ApiWeatherClient;

  @GET('/weather')
  Future<Weather> getWeather({
    @Query("lat") required String lat,
    @Query("lon") required String lon,
    @Query("appid") required String apiKey,
    @Query("units") required String units,
  });

  @GET('/forecast')
  Future<WeatherForecast> getWeatherForecast({
    @Query("lat") required String lat,
    @Query("lon") required String lon,
    @Query("appid") required String apiKey,
    @Query("units") required String units,
  });
}
