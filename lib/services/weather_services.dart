import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../models/weatherModel.dart';
import 'package:http/http.dart' as http;

class WeatherServices extends ChangeNotifier {
  static const BASE_URL = "http://api.openweathermap.org/data/2.5/weather";
  final String api_key;
  WeatherServices(this.api_key);

  // nearby cities update --
  List<String> yourNearByCities = [];
  List<Weathermodel> yourNearByCitiesWeather = [];

  Future<Weathermodel> getWeather(String cityname) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityname&appid=$api_key&units=metric'));
    // print("response---> " + response.body);

    if (response.statusCode == 200) {
      return Weathermodel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<dynamic> getWeatherJson(String cityname) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityname&appid=$api_key&units=metric'));
    // print("response---> " + response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("NO Data Available for this ${cityname} city");
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // if permission is not given then ask for it and wait for the access --
      permission = await Geolocator.requestPermission();
    }
    // fetch the current location --
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
// convert the location into a list of placemark objects --
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;
    // print(city);

    return city ?? ""; // if city is null return ""
  }

  // get nearby cities -
  Future<List<String>> getNearByCurrentCities() async {
    List<String> nearByCities = [];

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // if permission is not given then ask for it and wait for the access --
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permission denied");
        }
      }

      // fetch the current location --
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // convert the location into a list of placemark objects --

      // x+d -->
      double d = 0.3333; // distance

      // Function to add city to the list with error handling
      Future<void> addCity(double lat, double lon) async {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
          String? city = placemarks[0].locality;
          nearByCities.add(city ?? "None");
        } catch (e) {
          print("Failed to get placemark for coordinates ($lat, $lon): $e");
          nearByCities.add("None");
        }
      }

      await addCity(position.latitude + d, position.longitude);
      await addCity(position.latitude - d, position.longitude);
      await addCity(position.latitude, position.longitude + d);
      await addCity(position.latitude, position.longitude - d);
      await addCity(position.latitude + d, position.longitude + d);
      await addCity(position.latitude + d, position.longitude - d);
      await addCity(position.latitude - d, position.longitude - d);
      await addCity(position.latitude - d, position.longitude + d);
      // print("${position.latitude} + ${position.longitude} ==> ${city}");
      // print(city);
      print(nearByCities);
    } catch (e) {
      print("Error in getNearByCurrentCities: $e");
      throw Exception("Failed to fetch nearby cities: $e");
    }
    notifyListeners();
    return nearByCities;
  }

  List<dynamic> successfulWeathers = [];

  Future<void> getNearbyWeather() async {
    List<Weathermodel> nearByWeathers = [];
    List<String> cities = await getNearByCurrentCities();
    //
    for (int i = 0; i < cities.length; i++) {
      print("debug cities${i} => ${cities[i]}");
      try {
        if (cities[i] != "" || cities[i] != null) {
          var cityWeather = await getWeather(cities[i]);

          // nearByWeathers.add(cityWeather);
          successfulWeathers.add(cityWeather);

          // for simple extraction --> storing -- here!!
          yourNearByCities.add(cities[i]);
        } else {
          print("Null encountered! But chill, I got handled by Arnab!");
        }
      } catch (e) {
        print("Error in getNearbyWeather() => ${e}");
      }
    }
    print(yourNearByCities);
   // print("success: ${successfulWeathers}");

    yourNearByCitiesWeather.addAll(nearByWeathers);
    notifyListeners();
    // return nearByWeathers;
  }
}
