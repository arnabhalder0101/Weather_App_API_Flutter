import 'package:flutter/material.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'package:weather_app/services/weather_services.dart';

class MoreWeather extends StatelessWidget {
  MoreWeather({super.key});
  var weather_services = WeatherServices("05609490ba917b2b2f6550df95140755");

  @override
  Widget build(BuildContext context) {
    List<dynamic> weather = weather_services.successfulWeathers;

    return Scaffold(
      appBar: AppBar(
        title: Text("More Weather"),
      ),
      // body: Expanded(
      //   child: ListView.builder(
      //     itemCount: weather_services.yourNearByCitiesWeather.length,
      //     itemBuilder: (context, index) {
      //       final individual_weather =
      //           weather_services.yourNearByCitiesWeather[index];
      // return ListTile(
      //   title: Text(individual_weather.cityName +
      //       ", " +
      //       individual_weather.countryName),
      //   subtitle: Column(
      //     children: [
      //       Text(
      //         individual_weather.temperature.round().toString(),
      //       ),
      //       Text(
      //         individual_weather.feelsLike.round().toString(),
      //       ),
      //     ],
      //   ),
      // );
      //     },
      //   ),
      // ),
      body: Expanded(
        child: ListView.builder(
          itemCount: weather.length,
          itemBuilder: (context, index) {
            Weathermodel individual_weather = weather[index];

            return ListTile(
              title: Text(individual_weather.cityName +
                  ", " +
                  individual_weather.countryName),
              subtitle: Column(
                children: [
                  Text(
                    individual_weather.temperature.round().toString(),
                  ),
                  Text(
                    individual_weather.feelsLike.round().toString(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
