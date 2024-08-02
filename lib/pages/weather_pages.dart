import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/theme/theme_provider.dart';

class WeatherPages extends StatefulWidget {
  WeatherPages({super.key});

  @override
  State<WeatherPages> createState() => _WeatherPagesState();
}

class _WeatherPagesState extends State<WeatherPages> {
  final weather_services = WeatherServices("05609490ba917b2b2f6550df95140755");
  bool isDarkNeeded = false;

  Weathermodel? weather_;
  Weathermodel? weather_Nearby;

  // fetch weather --
  fetchWeather() async {
    String cityName = await weather_services.getCurrentCity();
    var w = await weather_services.getNearbyWeather();
    print("All success: ${weather_services.successfulWeathers}");
    try {
      final weather = await weather_services.getWeather(cityName);

      setState(() {
        weather_ = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // init --
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchWeather();
    // test --
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return "sunny";
    }
    switch (mainCondition?.toLowerCase()) {
      case null:
        return "sunny";

      case "mist":
      case "smoke":
      case "fog":
      case "dust":
      case "haze":
      case "clouds":
        return "cloudy";

      case "rain":
      case "drizzle":
      case "shower rain":
        return "rainy";

      case "thunderstrom":
      case "tornado":
        return "thunderRain";

      case "snow":
        return "snow";

      case "clear":
        return "sunny";

      default:
        return "sunny";
    }
  }

  // void Function(bool)? changeTheme() {
  //   isDarkNeeded = true;
  //   context.read<ThemeProvider>().toggleTheme();
  // }

  @override
  Widget build(BuildContext context) {
    final themedata = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Weather App"),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 38.0),
          child: CupertinoSwitch(
            value: themedata.isDark,
            onChanged: (value) {
              themedata.toggleTheme();
            },
            activeColor: Colors.grey[400],
            trackColor: Colors.grey[350],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city --
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${weather_?.cityName}," ?? "Loading..., ",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  weather_?.countryName ?? "Loading country...",
                  style: TextStyle(fontSize: 22),
                ),
              ],
            ),
            SizedBox(height: 30),

            // animations --
            // if(weather_.mainCondition == )
            Lottie.asset(
                "lib/assets/${getWeatherAnimation(weather_?.mainCondition)}.json"),

            SizedBox(height: 45),
            // temp --
            Text(
              "Temp  ${weather_?.temperature.round().toString()} ℃",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "Feels Like ${weather_?.feelsLike != null ? "${weather_?.feelsLike.round().toString()} ℃" : " Loading..."}",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "${weather_?.mainCondition ?? "Loading..."}",
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/more");
                },
                child: Text("More"))
          ],
        ),
      ),
    );
  }
}
