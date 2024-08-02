import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/more_weather.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/theme/theme_provider.dart';

import 'pages/weather_pages.dart';

void main() {
  runApp(
    // MultiProvider(providers: [
    //   Provider<ThemeProvider>(create:(context) => ThemeProvider(),),
    //   Provider<WeatherServices>(create:(context) => WeatherServices("05609490ba917b2b2f6550df95140755"),),
    // ], child: MainApp(),)
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPages(),
      theme: context.watch<ThemeProvider>().themeData,  // must
      routes: {
        "/more": (context)=>MoreWeather(),
      },
    );
  }
}
