import 'package:app/weather_in_location.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'second.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Dodaj tę linię
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikacja pogodowa',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: ''),
      routes: {
        '/forecast': (context) => const ForecastPage(title: ''),
        '/location': (context) => const LocationWeatherPage(title: ''),
      },
    );
  }
}
