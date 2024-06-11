import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'weather_model.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

class WeatherApi {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5';
  final String apiKey;

  WeatherApi(this.apiKey);

  Future<Weather> getWeatherFromLocation(double latitude, double longitude) async {
    final response = await http.get(Uri.parse('$BASE_URL/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // await saveResponseToFile('weather_${latitude}_${longitude}.json', jsonResponse);
      return Weather.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Forecast> getForecastFromLocation(double latitude, double longitude, {int cnt = 7}) async {
    final response = await http.get(Uri.parse('$BASE_URL/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // await saveResponseToFile('forecast_${latitude}_${longitude}.json', jsonResponse);
      return Forecast.fromJson(jsonResponse);
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load forecast data');
    }
  }

  Future<Weather> getWeatherFromLocationName(String locationName) async {
    final response = await http.get(Uri.parse('$BASE_URL/weather?q=$locationName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // await saveResponseToFile('weather_$locationName.json', jsonResponse);
      return Weather.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Forecast> getForecastFromLocationName(String locationName) async {
    // Your implementation to fetch forecast data by location name
    final response = await http.get(Uri.parse('$BASE_URL/forecast?q=$locationName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Forecast.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  Future<void> saveResponseToFile(String fileName, Map<String, dynamic> jsonResponse) async {
    try {
      if (kIsWeb) {
        await downloadJsonFile(fileName, jsonResponse);
      } else {
        await saveResponseToDocumentsDirectory(fileName, jsonResponse);
      }
    } catch (e) {
      print('Failed to save response to file: $e');
    }
  }

  Future<void> downloadJsonFile(String fileName, Map<String, dynamic> jsonResponse) async {
    final jsonString = jsonEncode(jsonResponse);
    final bytes = utf8.encode(jsonString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.Url.revokeObjectUrl(url);
    print('File downloaded: $fileName');
  }

  Future<void> saveResponseToDocumentsDirectory(String fileName, Map<String, dynamic> jsonResponse) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(jsonEncode(jsonResponse));
    print('Response saved to documents directory: ${file.path}');
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("Position: ${position.latitude}, ${position.longitude}");

    return "${position.latitude},${position.longitude}";
  }
}

