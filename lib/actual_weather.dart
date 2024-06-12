import 'package:app/actual_forecast.dart';
import 'package:app/weather_in_location.dart';
import 'package:flutter/material.dart';
import 'weather_api.dart';
import 'models/weather_model.dart';
import 'package:lottie/lottie.dart';
import 'get_day.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}




class _HomePageState extends State<HomePage> {
  final _weatherApi = WeatherApi('e86f7f0b73cdf4a139bfb9951648e7ac');
  Weather? _weather;

  _fetchWeather() async {
    try {
      String location = await _weatherApi.getCurrentCity();
      List<String> coordinates = location.split(',');
      double latitude = double.parse(coordinates[0]);
      double longitude = double.parse(coordinates[1]);

      final weather = await _weatherApi.getWeatherFromLocation(latitude, longitude);
      setState(() {
        _weather = weather;
      });
    } catch (e) {

        // ignore: avoid_print
        print(e);
    }
  }


  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  // Funkcja obsługująca naciśnięcie przycisku "Wyszukaj lokalizację"
  void _navigateToLocationWeatherPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationWeatherPage(title: '')), // Przejście do strony wyszukiwania lokalizacji
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.city ?? "Ładowanie lokalizacji...", style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold,),),
            Text('${_weather?.temperature.round()} °C', style: const TextStyle(fontSize: 30),),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForecastPage(title: '')),
                );
              },
              child: const Text('Pokaż prognozę na kolejne dni', style: TextStyle(fontSize: 15),),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _navigateToLocationWeatherPage, // Przejście do strony wyszukiwania lokalizacji
              child: const Text('Sprawdź pogodę w wybranej lokalizacji', style: TextStyle(fontSize: 15),),
            ),
          ],
        ),
      ),
    );
  }
}
