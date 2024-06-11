import 'package:flutter/material.dart';
import 'weather_api.dart';
import 'weather_model.dart';
import 'getDay.dart';


class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key, required this.title});

  final String title;

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  final _weatherApi = WeatherApi('e86f7f0b73cdf4a139bfb9951648e7ac');
  Forecast? _forecast;

  _fetchForecast() async {
    try {
      String location = await _weatherApi.getCurrentCity();
      List<String> coordinates = location.split(',');
      double latitude = double.parse(coordinates[0]);
      double longitude = double.parse(coordinates[1]);

      final forecast = await _weatherApi.getForecastFromLocation(latitude, longitude);

      // Group by day and calculate min/max temperatures
      final dailyForecasts = <String, DailyForecast>{};
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
            iconUrl: entry.iconUrl,
          );
        } else {
          dailyForecasts[dateString] = entry;
        }
      }

      setState(() {
        _forecast = Forecast(daily: dailyForecasts.values.toList());
      });
    } catch (e) {
      print(e);
    }
  }



  @override
  void initState() {
    super.initState();
    _fetchForecast();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: _forecast == null
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 30.0), // Add spacing before and after the text
                      child: Text(
                        'Prognoza pogody na nadchodzące dni dla twojej lokalizacji ',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10.0,
                        dataRowHeight: 90.0,
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Dzień', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),)),
                          DataColumn(label: Text('')),
                          DataColumn(label: Text('Temperatura (°C)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),)),
                          DataColumn(label: Text('Zachmurzenie (%)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),)),
                          
                        ],
                        rows: _forecast!.daily.map((day) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Center(child: Text(getWeekDay(day.date), style: TextStyle(fontSize: 15),))),
                              DataCell(Center(child: 
                                day.iconUrl != null
                                    ? Transform.scale(
                                        scale: 1.0, // Adjust the scale factor as per your requirement
                                        child: Image.network(day.iconUrl!),
                                      )
                                    : CircularProgressIndicator(), // Show loading indicator if icon URL is not available
                              )),
                              DataCell(Center(child:Text('${day.tempMin.round()} - ${day.tempMax.round()}', style: TextStyle(fontSize: 15),))),
                              DataCell(Center(child:Text(day.cloudiness.toString(), style: TextStyle(fontSize: 15),))),

                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }


}
