import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {

  // Твой API ключ OpenWeatherMap
  final String apiKey = "b55aa77c6483657c9eccec4ae8914893";

  Future<Map<String, dynamic>?> fetchWeather(String city) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=ru"
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}