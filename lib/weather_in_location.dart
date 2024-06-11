import 'package:flutter/material.dart';
import 'weather_api.dart';
import 'weather_model.dart';
import 'getDay.dart';
import 'package:lottie/lottie.dart';

class LocationWeatherPage extends StatefulWidget {
  const LocationWeatherPage({Key? key, required this.title});

  final String title;

  @override
  State<LocationWeatherPage> createState() => _LocationWeatherPageState();
}

class _LocationWeatherPageState extends State<LocationWeatherPage> {
  final _weatherApi = WeatherApi('e86f7f0b73cdf4a139bfb9951648e7ac');
  Weather? _weather;
  Forecast? _forecast;
  TextEditingController _locationController = TextEditingController();

  _fetchWeather(String location) async {
  try {
    final weather = await _weatherApi.getWeatherFromLocationName(location);
    final forecast = await _weatherApi.getForecastFromLocationName(location);

    // Group by day and calculate average temperatures
    final dailyForecasts = <String, DailyForecast>{};
    final dailyCount = <String, int>{};

    for (var entry in forecast.daily) {
      final dateString = entry.date.toLocal().toString().split(' ')[0];

      if (dailyForecasts.containsKey(dateString)) {
        final existing = dailyForecasts[dateString]!;
        dailyForecasts[dateString] = DailyForecast(
          date: existing.date,
            tempMin: entry.tempMin < existing.tempMin ? entry.tempMin : existing.tempMin,
            tempMax: entry.tempMax > existing.tempMax ? entry.tempMax : existing.tempMax,
            cloudiness: entry.cloudiness, // You may want to average or re-calculate this
            wind: entry.wind,
        );
        dailyCount[dateString] = dailyCount[dateString]! + 1;
      } else {
        dailyForecasts[dateString] = entry;
        dailyCount[dateString] = 1;
      }
    }

    final dailyAverages = dailyForecasts.values.toList();

    setState(() {
      _weather = weather;
      _forecast = Forecast(daily: dailyAverages);
    });
  } catch (e) {
    print(e);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Wpisz miejscowość',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String location = _locationController.text;
                    if (location.isNotEmpty) {
                      _fetchWeather(location);
                    }
                  },
                  child: Text('Wyświetl prognozę pogody'),
                ),

                SizedBox(height: 20),
                if (_weather != null)
                  Column(
                    children: [
                      Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 10.0), // Add spacing before and after the text)
                      child: Text(_weather!.city, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,))),
                      Text('${_weather!.temperature.round()} °C',  style: TextStyle(fontSize: 20)),
                      // SizedBox(height: 20),
                      Lottie.asset(getWeatherAnimation(_weather?.mainCondition),  width: 100, height: 100, ),
                      if (_forecast != null)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 8.0, // Zmniejszamy odstęp między kolumnami
                            columns: [
                              DataColumn(label: Text('Dzień', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),)),
                              DataColumn(label: Text('Temperatura (°C)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),)),
                              DataColumn(label: Text('Wiatr (m/s)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),)),
                          
                            ],
                            rows: _forecast!.daily.map((forecast) {
                              return DataRow(
                                cells: [
                                  DataCell(Center(child: Text(getWeekDay(forecast.date), style: TextStyle(fontSize: 15),))),
                                  DataCell(Center(child:Text('${forecast.tempMin.round()} - ${forecast.tempMax.round()}', style: TextStyle(fontSize: 15),))),
                                  DataCell(Center(child:Text(forecast.wind.round().toString(), style: TextStyle(fontSize: 15),))),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
