// import 'dart:js_interop';

class Weathermodel {
  String cityName;
  String countryName;
  double temperature;
  double feelsLike;
  String mainCondition;

  Weathermodel({
    required this.cityName,
    required this.countryName,
    required this.temperature,
    required this.feelsLike,
    required this.mainCondition,
  });

  factory Weathermodel.fromJson(Map<String, dynamic> json) {
    print(json);
    return Weathermodel(
      cityName: json['name'],
      countryName: json['sys']['country'],
      temperature: json['main']['temp'],
      feelsLike: json['main']['feels_like'],
      mainCondition: json['weather'][0]['main'],
    );
  }
}
