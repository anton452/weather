import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../services/earthquake_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final weatherService = WeatherService();
  final earthquakeService = EarthquakeService();
  final cityController = TextEditingController();

  Map<String, dynamic>? weather;
  List earthquakes = [];

  Future<void> loadWeather() async {
    final data = await weatherService.fetchWeather(cityController.text);
    setState(() {
      weather = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadEarthquakes();
  }

  Future<void> loadEarthquakes() async {
    final data = await earthquakeService.fetchEarthquakes();
    setState(() {
      earthquakes = data.take(5).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Главный экран")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              "Погода",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: "Введите город",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loadWeather,
                child: const Text("Получить погоду"),
              ),
            ),

            const SizedBox(height: 20),

            if (weather != null) ...[
              Text("Температура: ${weather!["main"]["temp"]} °C"),
              Image.network(
                "https://openweathermap.org/img/wn/${weather!["weather"][0]["icon"]}@2x.png",
              ),
            ],

            const SizedBox(height: 40),

            const Text(
              "Сейсмическая активность",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            for (var quake in earthquakes)
              Card(
                child: ListTile(
                  title: Text("Магнитуда: ${quake["properties"]["mag"]}"),
                  subtitle: Text(quake["properties"]["place"]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}