import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/weather.dart';

class ApiService {
  //  API ключ:
  static const String _apiKey = 'b55aa77c6483657c9eccec4ae8914893';

  Future<Weather> fetchWeather(String city) async {
    final trimmed = city.trim();
    if (trimmed.isEmpty) {
      throw Exception('Введите название города');
    }

    // ВАЖНО: Uri.https сам корректно кодирует кириллицу и пробелы
    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': trimmed,
      'appid': _apiKey,
      'units': 'metric',
      'lang': 'ru',
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return Weather.fromJson(data);
    } else {
      // Покажем тело ответа 
      throw Exception('API ошибка ${response.statusCode}: ${response.body}');
    }
  }
}
