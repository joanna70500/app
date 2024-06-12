

  Map<int, String> weekDays = {
  1: 'Pon',
  2: 'Wt',
  3: 'Śr',
  4: 'Cz',
  5: 'Pt',
  6: 'Sob',
  7: 'Ndz',
};

String getWeekDay(DateTime date) {
  return weekDays[date.weekday] ?? '';
}


String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'lib/animation/cloudy.json';

    switch (mainCondition.toLowerCase()) {
      case 'thunderstorm':
        return 'lib/animation/lightning_and_rain.json';
      case 'drizzle': 
        return 'lib/animation/sun_and_rain.json';
      case 'rain':
       return 'lib/animation/sun_and_rain.json';
      case 'snow':
        return 'lib/animation/snow.json';
      // mist, smoke, haze, dust, fog, sand, dust, ash, squall, tornado
      case 'atmosphere':
        return 'lib/animation/foggy.json';
      case 'clear':
        return 'lib/animation/sunny.json';
      case 'clouds':
        return 'lib/animation/cloudy.json';
      default:
        return 'lib/animation/cloudy.json';
    }
  }