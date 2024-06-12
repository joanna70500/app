// model aktualnej pogody
class Weather {
  final String city; // wartość nie może być zmieniona po inicjalizacji
  final double temperature;
  final String mainCondition; // główny stan pogody
  
  Weather({
    required this.city,
    required this.temperature,
    required this.mainCondition,
  });

// tworzenie obiektu Weather z mapy JSON
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}
