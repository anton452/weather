import 'dart:convert';
import 'package:http/http.dart' as http;

class EarthquakeService {

  Future<List> fetchEarthquakes() async {
    final url = Uri.parse(
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["features"];
      }
    } catch (e) {}

    return [];
  }
}