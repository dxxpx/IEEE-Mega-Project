import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool?> checkFloodConditions(
    {required String latitude, required String longitude}) async {
  final apiKey = 'f3971be2c79140dd898182750243108';
  final lat = latitude;
  final long = longitude;

  final url =
      'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$lat,$long&aqi=yes';

  int floodIndicator = 0;
  bool isFlood = false;

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final weatherData = jsonDecode(response.body);
      final current = weatherData['current'];

      print(current);

      final conditionText = current['condition']['text'];
      if (conditionText == 'Heavy rain' ||
          conditionText == 'Torrential rain' ||
          conditionText == 'Severe thunderstorms' ||
          conditionText == 'Flooding rain' ||
          conditionText == 'Persistent rain' ||
          conditionText == 'Monsoon rain') {
        floodIndicator += 1;
      }

      // Check temperature in Celsius
      final tempC = current['temp_c'];
      const tempCThreshold = 28;
      if (tempC < tempCThreshold) {
        floodIndicator += 1;
      }

      // Check temperature in Fahrenheit
      final tempF = current['temp_f'];
      const tempFThreshold = 70;
      if (tempF < tempFThreshold) {
        floodIndicator += 1;
      }

      // Check wind speed
      final windMph = current['wind_mph'];
      const windSpeedMphThreshold = 20;
      if (windMph > windSpeedMphThreshold) {
        floodIndicator += 1;
      }

      const windSpeedKphThreshold = 20;
      final windKph = current['wind_kph'];
      if (windKph > windSpeedKphThreshold) {
        floodIndicator += 1;
      }

      // Check pressure
      final pressureMb = current['pressure_mb'];
      const pressureMbThreshold = 983;
      if (pressureMb < pressureMbThreshold) {
        floodIndicator += 1;
      }

      final pressureIn = current['pressure_in'];
      const pressureInThreshold = 28;
      if (pressureIn < pressureInThreshold) {
        floodIndicator += 1;
      }

      // Check precipitation
      final precipMm = current['precip_mm'];
      const precipMmThreshold = 150;
      if (precipMm > precipMmThreshold) {
        floodIndicator += 1;
      }

      final precipIn = current['precip_in'];
      const precipInThreshold = 6;
      if (precipIn > precipInThreshold) {
        floodIndicator += 1;
      }

      // Check humidity
      final humidity = current['humidity'];
      const humidityThreshold = 90;
      if (humidity > humidityThreshold) {
        floodIndicator += 1;
      }

      // Check cloud cover
      final cloudCover = current['cloud'];
      const cloudCoverThreshold = 80;
      if (cloudCover > cloudCoverThreshold) {
        floodIndicator += 1;
      }

      // Check visibility
      final visibilityKm = current['vis_km'];
      const visibilityThreshold = 2;
      if (visibilityKm < visibilityThreshold) {
        floodIndicator += 1;
      }

      // Check UV index
      final uv = current['uv'];
      if (uv == 0) {
        floodIndicator += 1;
      }

      // Determine if flooding is likely
      if (floodIndicator >= 6) {
        isFlood = true;
      }

      print('Flood Indicator Count: $floodIndicator');
      print('Is the given area flooded: $isFlood');
      return isFlood;
    } else {
      print('Failed to load weather data');
    }
  } catch (e) {
    print('Error: $e');
  }
  return null;
}
