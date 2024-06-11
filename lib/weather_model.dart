class Weather {
  final String city;
  final double temperature;
  final String mainCondition;
  

  Weather({
    required this.city,
    required this.temperature,
    required this.mainCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],

    );
  }
}

class Forecast {
  final List<DailyForecast> daily;

  Forecast({required this.daily});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    List<DailyForecast> daily = (json['list'] as List)
        .map((data) => DailyForecast.fromJson(data))
        .toList();
    return Forecast(daily: daily);
  }
}
class DailyForecast {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final int cloudiness;
  final double wind;
  final String? iconUrl;

  DailyForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.cloudiness,
    required this.wind,
    this.iconUrl,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.parse(json['dt_txt']),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      cloudiness: json['clouds']['all'],
      wind: json['wind']['speed'].toDouble(),
      iconUrl: json['weather'][0]['icon'] != null
          ? 'https://openweathermap.org/img/w/${json['weather'][0]['icon']}.png'
          : null,
    );
  }
}
